//
//  AppDelegate.swift
//  MappedOut
//
//  Created by Thomas Clifford on 3/8/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        GMSServices.provideAPIKey("AIzaSyCFa_eDQldbY_7UqCKSAVgxPCwdTW5L7Jc")
        // Override point for customization after application launch.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.userDidLogout), name: userDidLogoutNotification, object: nil)
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "mappedout"
                configuration.clientKey = "dsf22eoahfaihfuai2e901980rh"
                configuration.server = "http://mappedout.herokuapp.com/parse"
            })
        )

        

        // check if user is logged in.
        if PFUser.currentUser() != nil {
            
            User.registerSubclass()
            PFUser.registerSubclass()
            // if there is a logged in user then load the home view controller
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CoreViewController") as UIViewController
            window?.rootViewController=vc
            
        }
        
       
        User.registerSubclass()
        PFUser.registerSubclass()
        

        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.channels = ["global"]
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    
    
    func userDidLogout(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()! as UIViewController
        window?.rootViewController=vc
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "mappedout"
                configuration.clientKey = "dsf22eoahfaihfuai2e901980rh"
                configuration.server = "http://mappedout.herokuapp.com/parse"
            })
        )
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        if shortcutItem.type == "com.olddonkey.createevent"{
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let createeventVC = sb.instantiateViewControllerWithIdentifier("createNavi") as! UINavigationController
            
            let root = UIApplication.sharedApplication().keyWindow?.rootViewController
            root?.presentViewController(createeventVC, animated: true, completion: { 
                completionHandler(true)
            })
        }
        if shortcutItem.type == "com.olddonkey.mapview"{
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let createeventVC = sb.instantiateViewControllerWithIdentifier("CoreViewController") as! MyTabBarController
            
            createeventVC.selectedIndex = 1
            self.window?.rootViewController!.presentViewController(createeventVC, animated: true, completion: {
                completionHandler(true)
            })
        }
        if shortcutItem.type == "com.olddonkey.friend"{
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let createeventVC = sb.instantiateViewControllerWithIdentifier("CoreViewController") as! MyTabBarController
            
            createeventVC.selectedIndex = 2
            self.window?.rootViewController!.presentViewController(createeventVC, animated: true, completion: {
                completionHandler(true)
            })
        }
        if shortcutItem.type == "com.olddonkey.settings"{
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let createeventVC = sb.instantiateViewControllerWithIdentifier("CoreViewController") as! MyTabBarController
            
            createeventVC.selectedIndex = 3
            self.window?.rootViewController!.presentViewController(createeventVC, animated: true, completion: {
                completionHandler(true)
            })
        }
    }


}

