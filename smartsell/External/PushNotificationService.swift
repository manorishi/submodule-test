//
//  PushNotificationService.swift
//  smartsell
//
//  Created by Apple on 19/05/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core
import UserNotifications

/**
 Register push notification.
*/

class PushNotificationService {
    
    ///Update FCM token on server
    func updateFCMOnServer(completionHandler: ((_ status:Bool) -> Void)?) {
        let pushNotificationInteractor = PushNotificationInteractor()
        if let fcmToken = FirebaseService().getFCMToken() {
            pushNotificationInteractor.updateFCMOnServer(fcmToken: fcmToken, completionHandler: completionHandler)
        }
        else {
            completionHandler?(false)
        }
    }
    
    
    ///Register for push notification
    func registerPushNotification() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = (UIApplication.shared.delegate as? AppDelegate)
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        }
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func updateAppVersionTopicOnFirebase() {
        PushNotificationInteractor().checkAppUpgradeAndSubscribeTopic()
    }
    
    func updateUserLevelOnShareCount() {
        PushNotificationInteractor().updateUserLevelOnShareCount()
    }
    
    func saveNotificationDataInKeychain(userInfo:[String:AnyObject]) {
        PushNotificationInteractor().saveNotificationDataInKeychain(userInfo: userInfo)
    }
    
    func saveNotificationData(userInfo:[AnyHashable:Any]) {
        PushNotificationInteractor().saveNotificationData(userInfo: userInfo)
    }
    
}
