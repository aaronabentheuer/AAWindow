# AAWindow
UIWindow subclass to enable behavior like adaptive round-corners &amp; detecting when Control Center is opened.

##Features
* **Adaptive rounded corners for UIWindow.**

  Rounded corners on application frames have been very popular in the early days of iOS because they give you a feeling of the screen disappearing and the app blending with the device (just like on Apple Watch). Since iOS 7 though rounded corners seemed to disappear. There are however still a few (even big-name) projects that use rounded corners for their app's window, one of the more popular being "Hyperlapse" by Facebook/Instagram. Hyperlapse looks really great (especially because there's not much of a UI at all), but once you take it to the Multitasking Switcher it starts to collide with iOS. One can clearly see tiny artefacts on each corner of the app-preview that ruin the effect. If you define a corner-radius in AAWindow it automatically animates it to `*.layer.cornerRadius = 0` once the app is in a inactive state and animates back once it's active again.
  
  You set your cornerRadius by setting up AAWindow and passing a value other than `0` for `cornerRadius`:
  
  ```    
  var window: UIWindow? = {
        let window = AAWindow(frame: UIScreen.mainScreen().bounds, cornerRadius: 6)
        return window
        }()
  ```
  
* **Detecting when the user opens Control Center.**

  Apple very deliberately chose not to expose to us designers and developers whether the user opened Notification Center, Control Center, the Multitasking Switcher or whatever else might have caused the app to be inactive. When developing "Cousteau" (the project from which "[AASecondaryScreen](https://github.com/aaronabentheuer/AASecondaryScreen)" originated) I wished there was a way I could assist the user in setting up AirPlay Mirroring, since this is a process that a lot of users still aren't familiar with. That's why I came up with a solution that is built into AAWindow, that triggers an NSNotification `applicationWillResignActiveWithControlCenter` once the user opened Control Center. You can subscribe to this notification and react to it for example when you want to assist the user in setting up AirPlay, AirDrop or anything else accesible through Control Center. But remember, with great power comes great responsibility, so you shouldn't use this to force your users into activating things they might very deliberately have turned off in the first place. Especially with AirPlay it can be used quite effectively though.
  
  This is automatically available once AAWindow is setup correctly in `AppDelegate.swift`:
  
  ```    
  var window: UIWindow? = {
        let window = AAWindow(frame: UIScreen.mainScreen().bounds, cornerRadius: 0)
        return window
        }()
  ```
  
  You can then subscribe to `applicationWillResignActiveWithControlCenter` by using one of the provided methods `NSNotificationCenter.defaultCenter().addObsever*` from anywhere in your application.
