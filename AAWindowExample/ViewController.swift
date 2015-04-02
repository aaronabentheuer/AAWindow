//
//  ViewController.swift
//  AAWindowExample
//
//  Created by Julian Abentheuer on 15.03.15.
//  Copyright (c) 2015 overview+DETAIL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //Everything in the ViewController (except the subscribing to notifications) is just for the demo-application. Setting up happens in "AppDelegate.swift".
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        var cameraImageView : UIImageView = UIImageView(frame: UIScreen.mainScreen().bounds)
        var cameraImage = UIImage(named: "CameraImage")
        cameraImageView.image = cameraImage
        cameraImageView.contentMode = UIViewContentMode.ScaleAspectFill
        cameraImageView.alpha = 0
        self.view.addSubview(cameraImageView)
        
        var stateLabel : UILabel = UILabel(frame: UIScreen.mainScreen().bounds)
        stateLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        stateLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        stateLabel.textAlignment = .Center
        stateLabel.text = "Application is active."
        stateLabel.sizeToFit()
        self.view.addSubview(stateLabel)
        
        self.view.addConstraints([NSLayoutConstraint(item: stateLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0), NSLayoutConstraint(item: stateLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)])
        
        NSNotificationCenter.defaultCenter().addObserverForName("applicationWillResignActiveWithControlCenter", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            
            UIView.animateWithDuration(0.15, animations: {
                
                stateLabel.text = "Control Center is opened."
                stateLabel.textColor = UIColor(red: 115/255, green: 255/255, blue: 204/255, alpha: 1)
                stateLabel.sizeToFit()
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone) {
                    stateLabel.center.y = self.view.frame.height * 0.15
                }
            })
            
            var fadeInOutAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            fadeInOutAnimation.fromValue = 1
            fadeInOutAnimation.toValue = 1.1
            fadeInOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            fadeInOutAnimation.duration = 0.5
            fadeInOutAnimation.autoreverses = true
            fadeInOutAnimation.repeatCount = HUGE
            fadeInOutAnimation.removedOnCompletion = false
            fadeInOutAnimation.fillMode = kCAFillModeBoth
            
            stateLabel.layer.shouldRasterize = true
            stateLabel.layer.addAnimation(fadeInOutAnimation, forKey: "scale")
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            
            UIView.animateWithDuration(0.15, animations: {
                
                stateLabel.text = "Application is active."
                stateLabel.textColor = UIColor(red: 115/255, green: 255/255, blue: 204/255, alpha: 1)
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone) {
                    stateLabel.center.y = self.view.center.y
                }
            })
            
            var fadeInOutAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            fadeInOutAnimation.toValue = 1
            fadeInOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            fadeInOutAnimation.duration = 0.5
            fadeInOutAnimation.autoreverses = false
            fadeInOutAnimation.removedOnCompletion = false
            fadeInOutAnimation.fillMode = kCAFillModeBoth
            
            stateLabel.layer.shouldRasterize = true
            stateLabel.layer.addAnimation(fadeInOutAnimation, forKey: "scale")
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName("applicationWillResignActiveWithoutControlCenter", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            
            UIView.animateWithDuration(0.15, animations: {
                
                stateLabel.text = "Application is inactive."
                stateLabel.sizeToFit()
                stateLabel.textColor = UIColor.lightGrayColor()
                
            })
        })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

