//
//  AAWindow.swift
//  AAWindowExample
//
//  Created by Julian Abentheuer on 15.03.15.
//  Copyright (c) 2015 overview+DETAIL. All rights reserved.
//

import UIKit

class AAWindow: UIWindow {

    fileprivate var activeCornerRadius : CGFloat = 0
    fileprivate var inactiveCornerRadius : CGFloat = 0
    fileprivate var cornerRadiusAnimationDuration : Double = 0.15
    
    fileprivate var willOpenControlCenter : Bool = false
    fileprivate var controlCenterOpened : Bool = false
    var timer : Timer = Timer()
    
    //This notification will fire when the user opens Control Center.
    fileprivate var applicationWillResignActiveWithControlCenterNotification = Notification(name: Notification.Name(rawValue: "applicationWillResignActiveWithControlCenter"), object: nil)
    //This notification will fire when the application becomes inactive for whatever reason, except when the user launches Control Center.
    fileprivate var applicationWillResignActiveWithoutControlCenterNotification = Notification(name: Notification.Name(rawValue: "applicationWillResignActiveWithoutControlCenter"), object: nil)

    init(frame: CGRect, cornerRadius: Float) {
        super.init(frame: frame)
        
        //clipsToBounds is necessary for the cornerRadius to work.
        self.clipsToBounds = true
        self.layer.cornerRadius = inactiveCornerRadius
        self.backgroundColor = UIColor.black
        
        activeCornerRadius = CGFloat(cornerRadius)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    //This will fire once the application becomes active (i.e. on startup or on return from Multitasking Switcher)
    @objc fileprivate func applicationDidBecomeActive (_ notification : Notification) {
        
        if (controlCenterOpened) {
            controlCenterOpened = false
        } else {
            self.layer.cornerRadius = activeCornerRadius
            //Animates back to the active cornerRadius.
            self.layer.add(animateCornerRadius(inactiveCornerRadius, toValue: activeCornerRadius, withDuration: cornerRadiusAnimationDuration, forKey: "cornerRadius"), forKey: "cornerRadius")
        }
    }
    
    //This will fire once the application becomes inactive (i.e. user opens Multitasking Switcher, Control Center, Notification Center…)
    @objc fileprivate func applicationWillResignActive (_ notification : Notification) {
        
        //willOpenControlCenter is true for a short period of time when the user touches in the bottom area of the screen. If in this period of time "applicationWillResignActive" is called it's highly likely (basically certain) that the user has launched Control Center.
        if (willOpenControlCenter) {

            NotificationCenter.default.post(applicationWillResignActiveWithControlCenterNotification)
            
            if (timer.isValid) {
                timer.invalidate()
            }
            
            willOpenControlCenter = false
            controlCenterOpened = true
        } else {
            NotificationCenter.default.post(applicationWillResignActiveWithoutControlCenterNotification)
            
            self.layer.cornerRadius = inactiveCornerRadius
            self.layer.add(animateCornerRadius(activeCornerRadius, toValue: inactiveCornerRadius, withDuration: cornerRadiusAnimationDuration, forKey: "cornerRadius"), forKey: "cornerRadius")
        }
    }
    
    fileprivate var touchLocation : CGPoint = CGPoint()
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        //Filter touches from other UIEventTypes.
        if (event.type == UIEventType.touches) {
            for touchevent in event.allTouches! {
                let touch = touchevent 

                if (touch.phase == UITouchPhase.began && touch.location(in: self).y - self.frame.height * 0.9 >= 0) {
                    //willOpenControlCenter is true for a short period of time when the user touches in the bottom area of the screen. If in this period of time "applicationWillResignActive" is called it's highly likely (basically certain) that the user has launched Control Center.
                    willOpenControlCenter = true
                    
                    if (timer.isValid) {
                        timer.invalidate()
                    }
                    
                    //If the Statusbar is hidden (which means the app is in full-screen mode) the timerInterval has to be longer since it will take the user a maximum amount of ~3 seconds to open Control Center since he has to use the little handle coming up from the bottom.
                    let timerInterval : Double = {
                        if (UIApplication.shared.isStatusBarHidden) {
                            return 2.75
                        } else {
                            return 0.5
                        }
                    }()
                    
                    timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(AAWindow.handleTimer), userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    @objc fileprivate func handleTimer () {
        willOpenControlCenter = false
    }
    
    //CornerRadius Animation setup.
    fileprivate func animateCornerRadius(_ fromValue : CGFloat, toValue: CGFloat, withDuration : Double, forKey : String) -> CABasicAnimation {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: forKey)
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
