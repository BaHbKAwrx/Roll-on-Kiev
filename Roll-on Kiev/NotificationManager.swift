//
//  NotificationManager.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 8/19/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class NotificationManager: NSObject {

    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization(for application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            notificationCenter.delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            notificationCenter.requestAuthorization(options: authOptions) { (_, _) in }
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
    }
}

// MARK: - UN and Messaging Delegate Methods
extension NotificationManager: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
}
