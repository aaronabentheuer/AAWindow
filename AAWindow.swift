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
    
    //This notification will fire when the user opens Control Center.
    private var applicationWillResignActiveWithControlCenterNotification = NSNotification(name: "applicationWillResignActiveWithControlCenter", object: nil)
    //This notification will fire when the application becomes inactive for whatever reason, except when the user launches Control Center.
    private var applicationWillResignActiveWithoutControlCenterNotification = NSNotification(name: "applicationWillResignActiveWithoutControlCenter", object: nil)

    init(frame: CGRect, cornerRadius: Float) {
        super.init(frame: frame)
        
        //clipsToBounds is necessary for the cornerRadius to work.
        self.clipsToBounds = true
        self.layer.cornerRadius = inactiveCornerRadius
        self.backgroundColor = UIColor.blackColor()
        
        activeCornerRadius = CGFloat(cornerRadius)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    //This will fire once the application becomes active (i.e. on startup or on return from Multitasking Switcher)
    @objc private func applicationDidBecomeActive (notification : NSNotification) {
        self.layer.cornerRadius = activeCornerRadius
        //Animates back to the active cornerRadius.
        self.layer.addAnimation(animateCornerRadius(inactiveCornerRadius, toValue: activeCornerRadius, withDuration: cornerRadiusAnimationDuration, forKey: "cornerRadius"), forKey: "cornerRadius")
    }
    
    //This will fire once the application becomes inactive (i.e. user opens Multitasking Switcher, Control Center, Notification Center…)
    @objc private func applicationWillResignActive (notification : NSNotification) {
        
        self.layer.cornerRadius = inactiveCornerRadius
        self.layer.addAnimation(animateCornerRadius(activeCornerRadius, toValue: inactiveCornerRadius, withDuration: cornerRadiusAnimationDuration, forKey: "cornerRadius"), forKey: "cornerRadius")
        
        //willOpenControlCenter is true for a short period of time when the user touches in the bottom area of the screen. If in this period of time "applicationWillResignActive" is called it's highly likely (basically certain) that the user has launched Control Center.
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
        
        //Filter touches from other UIEventTypes.
        if (event.type == UIEventType.Touches) {
            for touchevent in event.allTouches()! {
                var touch = touchevent as! UITouch

                if (touch.phase == UITouchPhase.Began && touch.locationInView(self).y - self.frame.height * 0.9 >= 0) {
                    //willOpenControlCenter is true for a short period of time when the user touches in the bottom area of the screen. If in this period of time "applicationWillResignActive" is called it's highly likely (basically certain) that the user has launched Control Center.
                    willOpenControlCenter = true
                    
                    if (timer.valid) {
                        timer.invalidate()
                    }
                    
                    //If the Statusbar is hidden (which means the app is in full-screen mode) the timerInterval has to be longer since it will take the user a maximum amount of ~3 seconds to open Control Center since he has to use the little handle coming up from the bottom.
                    var timerInterval : Double = {
                        if (UIApplication.sharedApplication().statusBarHidden) {
                            return 2.75
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
    
    //CornerRadius Animation setup.
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