//
//  NotificationService.swift
//  CallNotificationService
//
//  Created by Shakeeb Majid on 12/26/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UserNotifications
import UserNotificationsUI

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        // 6. Add some actions and add them in a category which is then added to the notificationCategories
        let acceptAction = UNNotificationAction(identifier: "accept", title: "Accept", options: [.foreground])
        let declineAction = UNNotificationAction(identifier: "decline", title: "Decline", options: [.foreground])
        let category = UNNotificationCategory(identifier: "call", actions: [acceptAction, declineAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title)"
            
            contentHandler(bestAttemptContent)
        }
        

    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        if response.actionIdentifier == "accept" {
            print("hellooooooo sally")
            completion(.dismiss)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
