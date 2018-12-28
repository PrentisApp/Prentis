//
//  AppDelegate.swift
//  Prentis
//
//  Created by Shakeeb Majid on 9/1/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import IQKeyboardManagerSwift
import PushNotifications
import Alamofire
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let pushNotifications = PushNotifications.shared
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotifications.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.pushNotifications.handleNotification(userInfo: userInfo)
        print("hi you just entered before")
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        print("hi you just entered after")
        UserDefaults.standard.set(aps["caller"], forKey: "caller")
        completionHandler(.newData)
    }
    
    //var ref: DatabaseReference!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]
        
        // 1
        if let notification = notificationOption as? [String: AnyObject],
            let aps = notification["aps"] as? [String: AnyObject] {
            
            UserDefaults.standard.set(aps["caller"], forKey: "caller")
            
        }
        
        self.pushNotifications.start(instanceId: "4ae3f5f0-a0ec-4b96-8ac1-aa02de51c422")
        self.pushNotifications.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self

        //try? self.pushNotifications.subscribe(interest: "debug-hello")
        
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                if response.actionIdentifier == "accept" {
                        print("Handle accept action identifier")
                    } else if response.actionIdentifier == "decline" {
                        print("Handle decline action identifier")
                    } else {
                        print("No custom action identifiers chosen")
                    }
                // Make sure completionHandler method is at the bottom of this func
                completionHandler()
            }
    
}

