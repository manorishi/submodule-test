//
//  AppDelegateExtensions.swift
//  smartsell
//
//  Created by Apple on 19/05/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications
import Firebase
import Core

/**
 Appdelegate extension used to handle push notifcation delegate methods.
 */

extension AppDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        gotoNotificationTargetScreen(userInfo: userInfo)
    }
    
    /**
     Check application state and redirect to target screen.
     */
    func gotoNotificationTargetScreen(userInfo:[AnyHashable:Any]) {
        if let _ = KeyChainService.sharedInstance.getValue(key: ConfigKeys.ACCESS_TOKEN_KEY) {
            saveNotificationInLocalDB(userInfo: userInfo)
            if let userInfoDict = userInfo as? [String:AnyObject] {
                let annoucement = AnnouncementData(announcementData: userInfoDict)
                let annoucementData = NSKeyedArchiver.archivedData(withRootObject: annoucement)
                if UIApplication.shared.applicationState == .active {
                    saveNotificationDataInKeychain(userInfo: userInfo)
                    if let homeScreenVC = topViewControllerWithRootViewController(rootViewController: UIApplication.shared.keyWindow?.rootViewController) as? HomeScreenViewController {
                     //   homeScreenVC.showNotificationAlert()
                    }
                }
                else if UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive {
                    gotoTargetScreenFromHomeController(annoucementData: annoucementData)
                }
                else {
                    goToHomeController()
                    gotoTargetScreenFromHomeController(annoucementData: annoucementData)
                }
            }
        }
        else {
            gotoLoginController()
        }
    }
    
    /**
     Redirect to home screen.
     */
    func gotoTargetScreenFromHomeController(annoucementData: Data) {
        if let mainTabbar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            mainTabbar.selectedIndex = 0
            if let homeScreenNC = mainTabbar.selectedViewController as? UINavigationController, let homeScreenVC = homeScreenNC.viewControllers.first as? HomeScreenViewController {
//                if homeScreenVC.eventHandler == nil {
//                    _ = homeScreenVC.view
//                }
//                homeScreenVC.eventHandler.clickedOnAnnouncementTarget(data:annoucementData)
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func saveNotificationDataInKeychain(userInfo:[AnyHashable:Any]) {
        if let userInfoData = userInfo as? [String:AnyObject] {
            PushNotificationService().saveNotificationDataInKeychain(userInfo: userInfoData)
        }
    }
    
    func saveNotificationInLocalDB(userInfo:[AnyHashable:Any]) {
        PushNotificationService().saveNotificationData(userInfo: userInfo)
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        gotoNotificationTargetScreen(userInfo: userInfo)
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        gotoNotificationTargetScreen(userInfo: userInfo)
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        let pushNotificationService = PushNotificationService()
        if let fcmToken = FirebaseService().getFCMToken() {
            print("fcm token = \(fcmToken)")
        }
        pushNotificationService.updateFCMOnServer(completionHandler: nil)
    }
}
