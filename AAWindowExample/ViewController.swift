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
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        var cameraImageView : UIImageView = UIImageView(frame: UIScreen.mainScreen().bounds)
        var cameraImage = UIImage(named: "CameraImage")
        cameraImageView.image = cameraImage
        cameraImageView.contentMode = UIViewContentMode.ScaleAspectFill
        cameraImageView.alpha = 0
        self.view.addSubview(cameraImageView)
        
        var stateLabel : UILabel = UILabel(frame: UIScreen.mainScreen().bounds)
        stateLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        stateLabel.textAlignment = .Center
        stateLabel.text = "Application is active."
        self.view.addSubview(stateLabel)
        
        NSNotificationCenter.defaultCenter().addObserverForName("applicationWillResignActiveWithControlCenter", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            
            UIView.animateWithDuration(0.15, animations: {
                
                stateLabel.text = "Control Center is opened."
                stateLabel.textColor = UIColor.blackColor()
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone) {
                    stateLabel.center.y = self.view.frame.height * 0.15
                }
            })
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            
            UIView.animateWithDuration(0.15, animations: {
                
                stateLabel.text = "Application is active."
                stateLabel.textColor = UIColor.blackColor()
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone) {
                    stateLabel.center.y = self.view.center.y
                }
            })
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName("applicationWillResignActiveWithoutControlCenter", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            
            UIView.animateWithDuration(0.15, animations: {
                
                stateLabel.text = "Application is inactive."
                stateLabel.textColor = UIColor.orangeColor()
                
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

