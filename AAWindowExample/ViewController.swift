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
        
        self.view.backgroundColor = UIColor.darkGray
        
        let cameraImageView: UIImageView = UIImageView(frame: UIScreen.main.bounds)
        let cameraImage = UIImage(named: "CameraImage")
        cameraImageView.image = cameraImage
        cameraImageView.contentMode = UIViewContentMode.scaleAspectFill
        cameraImageView.alpha = 0
        self.view.addSubview(cameraImageView)
        
        let stateLabel: UILabel = UILabel(frame: UIScreen.main.bounds)
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        stateLabel.textAlignment = .center
        stateLabel.text = "Application is active."
        stateLabel.sizeToFit()
        self.view.addSubview(stateLabel)
        
        self.view.addConstraints([NSLayoutConstraint(item: stateLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0), NSLayoutConstraint(item: stateLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)])
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "applicationWillResignActiveWithControlCenter"), object: nil, queue: OperationQueue.main, using: { notification in
            
            UIView.animate(withDuration: 0.15, animations: {
                
                stateLabel.text = "Control Center is opened."
                stateLabel.textColor = UIColor(red: 115/255, green: 255/255, blue: 204/255, alpha: 1)
                stateLabel.sizeToFit()
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
                    stateLabel.center.y = self.view.frame.height * 0.15
                }
            })
            
            let fadeInOutAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            fadeInOutAnimation.fromValue = 1
            fadeInOutAnimation.toValue = 1.1
            fadeInOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            fadeInOutAnimation.duration = 0.5
            fadeInOutAnimation.autoreverses = true
            fadeInOutAnimation.repeatCount = HUGE
            fadeInOutAnimation.isRemovedOnCompletion = false
            fadeInOutAnimation.fillMode = kCAFillModeBoth
            
            stateLabel.layer.shouldRasterize = true
            stateLabel.layer.add(fadeInOutAnimation, forKey: "scale")
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: OperationQueue.main, using: { notification in
            
            UIView.animate(withDuration: 0.15, animations: {
                
                stateLabel.text = "Application is active."
                stateLabel.textColor = UIColor(red: 115/255, green: 255/255, blue: 204/255, alpha: 1)
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
                    stateLabel.center.y = self.view.center.y
                }
            })
            
            let fadeInOutAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            fadeInOutAnimation.toValue = 1
            fadeInOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            fadeInOutAnimation.duration = 0.5
            fadeInOutAnimation.autoreverses = false
            fadeInOutAnimation.isRemovedOnCompletion = false
            fadeInOutAnimation.fillMode = kCAFillModeBoth
            
            stateLabel.layer.shouldRasterize = true
            stateLabel.layer.add(fadeInOutAnimation, forKey: "scale")
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "applicationWillResignActiveWithoutControlCenter"), object: nil, queue: OperationQueue.main, using: { notification in
            
            UIView.animate(withDuration: 0.15, animations: {
                
                stateLabel.text = "Application is inactive."
                stateLabel.sizeToFit()
                stateLabel.textColor = UIColor.lightGray
                
            })
        })
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

