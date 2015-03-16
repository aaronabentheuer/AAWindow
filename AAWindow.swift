//
//  AAWindow.swift
//  AAWindowExample
//
//  Created by Julian Abentheuer on 15.03.15.
//  Copyright (c) 2015 overview+DETAIL. All rights reserved.
//

import UIKit

class AAWindow: UIWindow {

    private var activeCornerRadius : CGFloat = 0
    private var inactiveCornerRadius : CGFloat = 0
    private var cornerRadiusAnimationDuration : Double = 0.15
    
    private var willOpenControlCenter : Bool = false
    var timer : NSTimer = NSTimer()
    
    private var applicationWillResignActiveWithControlCenterNotification = NSNotification(name: "applicationWillResignActiveWithControlCenter", object: nil)
    private var applicationWillResignActiveWithoutControlCenterNotification = NSNotification(name: "applicationWillResignActiveWithoutControlCenter", object: nil)

    init(frame: CGRect, cornerRadius: Float) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = inactiveCornerRadius
        self.backgroundColor = UIColor.blackColor()
        
        activeCornerRadius = CGFloat(cornerRadius)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    @objc private func applicationDidBecomeActive (notification : NSNotification) {
        self.layer.cornerRadius = activeCornerRadius
        self.layer.addAnimation(animateCornerRadius(inactiveCornerRadius, toValue: activeCornerRadius, withDuration: cornerRadiusAnimationDuration, forKey: "cornerRadius"), forKey: "cornerRadius")
    }
    
    @objc private func applicationWillResignActive (notification : NSNotification) {
        
        self.layer.cornerRadius = inactiveCornerRadius
        self.layer.addAnimation(animateCornerRadius(activeCornerRadius, toValue: inactiveCornerRadius, withDuration: cornerRadiusAnimationDuration, forKey: "cornerRadius"), forKey: "cornerRadius")
        
        if (willOpenControlCenter) {

            NSNotificationCenter.defaultCenter().postNotification(applicationWillResignActiveWithControlCenterNotification)
            
            if (timer.valid) {
                timer.invalidate()
            }
            
            willOpenControlCenter = false
        } else {
            NSNotificationCenter.defaultCenter().postNotification(applicationWillResignActiveWithoutControlCenterNotification)
        }
    }
    
    private var touchLocation : CGPoint = CGPoint()
    
    override func sendEvent(event: UIEvent) {
        super.sendEvent(event)
        
        if (event.type == UIEventType.Touches) {
            for touchevent in event.allTouches()! {
                var touch = touchevent as! UITouch

                if (touch.phase == UITouchPhase.Began && touch.locationInView(self).y - self.frame.height * 0.9 >= 0) {
                    willOpenControlCenter = true
                    
                    if (timer.valid) {
                        timer.invalidate()
                    }
                    
                    var timerInterval : Double = {
                        if (UIApplication.sharedApplication().statusBarHidden) {
                            return 2.5
                        } else {
                            return 0.5
                        }
                    }()
                    
                    timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector: Selector("handleTimer"), userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    @objc private func handleTimer () {
        willOpenControlCenter = false
    }
    
    private func animateCornerRadius(fromValue : CGFloat, toValue: CGFloat, withDuration : Double, forKey : String) -> CABasicAnimation {
        
        var animation : CABasicAnimation = CABasicAnimation(keyPath: forKey)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = withDuration
        
        return animation
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}