# AAWindow
This UIWindow-subclass is a collection of features that are intended to further polish the apps that we use daily.
For now I've included two features that I haven't seen before and I thought might be interesting for a lot of people: **Adaptive App cornerRadius & detecting when the user opens Control Center** *(to provide assistance for example when setting up AirPlay)*. I've been using it in almost all of my projects for university and will update it constantly as I come across new features. UIWindow is often overlooked and still bears a lot of potential. Stay tuned.

##Features
* **Adaptive rounded corners for UIWindow.**

  Rounded corners on application frames have been very popular in the early days of iOS because they give you a feeling of the screen disappearing and the app blending with the device (just like nowadays on Apple Watch). Since iOS 7 though, rounded corners seemed to disappear. There are however still a few (even big-name) projects that use rounded corners for their app's window, one of the more popular being "Hyperlapse" by Facebook/Instagram. Hyperlapse looks really great (especially because there's not much of a UI at all), but once you take it to the Multitasking Switcher it starts to collide with iOS. One can clearly see tiny artefacts on each corner of the app-preview that ruin the effect. If you define a corner-radius in AAWindow it automatically animates it to `*.layer.cornerRadius = 0` once the app is in a inactive state and animates back once it's active again.
  
  You set your cornerRadius by setting up AAWindow and passing a value other than `0` for `cornerRadius`:
  
  ```    
  var window: UIWindow? = {
        let window = AAWindow(frame: UIScreen.mainScreen().bounds, cornerRadius: 6)
        return window
        }()
  ```
  
* **Detecting when the user opens Control Center.**

  Apple very deliberately chose not to expose to us designers and developers whether the user opened Notification Center, Control Center, the Multitasking Switcher or whatever else might cause an app to be inactive. When developing "Cousteau" (the project from which "[AASecondaryScreen](https://github.com/aaronabentheuer/AASecondaryScreen)" originated) I wished there was a way I could assist the user in setting up AirPlay Mirroring, since this is a process that a lot of users still aren't familiar with. That's why I came up with a solution that is built into AAWindow, that triggers an NSNotification (`applicationWillResignActiveWithControlCenter`) once the user opens Control Center. You can subscribe to this notification and react to it for example when you want to assist the user in setting up AirPlay, AirDrop or anything else accesible through Control Center. But remember, with great power comes great responsibility, so you shouldn't use this to force your users into activating things they might very deliberately have turned off in the first place. Especially with AirPlay it can be used quite effectively though.
  
  This is automatically available once AAWindow is setup correctly in `AppDelegate.swift`:
  
  ```    
  var window: UIWindow? = {
        let window = AAWindow(frame: UIScreen.mainScreen().bounds, cornerRadius: 0)
        return window
        }()
  ```
  
  You can then subscribe to two provided NSNotifications automatically coming with AAWindow by using one of the provided methods `NSNotificationCenter.defaultCenter().addObsever*` from anywhere in your application:
  
  * `applicationWillResignActiveWithControlCenter` will fire when the user opens Control Center.
  * `applicationWillResignActiveWithoutControlCenter` will fire whenever `applicationWillResignActive` is called (i.e. the user opening Notification Center, …) except when the user opens Control Center.

##Example Project
The very simple example project hopefully demonstrates the gist of using "AAWindow" and is thoroughly commented. If you have any questions don't hesitate contacting me [@aaronabentheuer](http://www.twitter.com/aaronabentheuer).

![screencast](https://github.com/aaronabentheuer/AAWindow/blob/master/screencast.gif)

##License
Released under the **MIT License**.
Copyright © 2015 [Aaron Abentheuer](http://www.aaronabentheuer.com).

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
