//
//  PushNotificationInteractor.swift
//  smartsell
//
//  Created by Apple on 19/05/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

/**
 Register FCM token on server. Register topics on firebase. Save and delete notifcation data.
 */

class PushNotificationInteractor {
    
    let fcmKey = "fcm"
    let MF_PULSE = "MF_PULSE_BANK_RM"
    let OS_IOS = "IOS_BANK_RM"
    let MF_RM = "MF_RM"
    let BANK_CSO = "BANK_CSO"
    let BANK_RM = "BANK_RM"
    let BEGINNER = "BEGINNER"
    let INTERMEDIATE = "INTERMEDIATE"
    let EXPERT = "EXPERT"
    
    /**
     Update fcm token on server.
     */
    func updateFCMOnServer(fcmToken:String,completionHandler: ((_ status:Bool) -> Void)?) {
        if KeyChainService.sharedInstance.getValue(key: ConfigKeys.ACCESS_TOKEN_KEY) != nil {
            NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: AppUrlConstants.updateFCM, params: nil, httpBody: [fcmKey:fcmToken as AnyObject], completionHandler: {[weak self] (responseStatus, response) in
                if responseStatus == .success {
                    completionHandler?(true)
                    self?.registerPushNotificationTopics()
                }
                else {
                    completionHandler?(false)
                }
            })
        }
    }
    
    /**
     Register notification topics on firebase.
     */
    func registerPushNotificationTopics() {
        let firebaseService = FirebaseService()
        firebaseService.subscribe(toTopic: MF_PULSE)
        firebaseService.subscribe(toTopic: OS_IOS)
        firebaseService.subscribe(toTopic: "BANK_PBRM")
        if let data = KeyChainService.sharedInstance.getData(key: ConfigKeys.USER_DATA_KEY) {
            if let userData = NSKeyedUnarchiver.unarchiveObject(with: data) as? UserData {
                if let mobileNumber = userData.userName {
                    firebaseService.subscribe(toTopic: mobileNumber)
                }
//                if let userTypeId = getUserTypeNameFromId(userType: userData.userTypeId) {
//                    firebaseService.subscribe(toTopic: userTypeId)
//                }
                if let location = userData.location {
                    firebaseService.subscribe(toTopic: "\(location.uppercased())_BANK_RM")
                }
            }
        }
//        if let userLevel = getUserLevelOnShareCount() {
//            firebaseService.subscribe(toTopic: userLevel)
//        }
        checkAppUpgradeAndSubscribeTopic()
    }
    
    /**
     Check for app update. Subscribe new version and unsubscribe older version.
     */
    func checkAppUpgradeAndSubscribeTopic() {
        if let _ = KeyChainService.sharedInstance.getValue(key: ConfigKeys.ACCESS_TOKEN_KEY) {
            let firebaseService = FirebaseService()
            let currentVersion = Bundle.main.object(forInfoDictionaryKey:     "CFBundleShortVersionString") as? String
            
            let versionOfLastRun = KeyChainService.sharedInstance.getValue(key: AppConstants.APP_PREVIOUS_VERSION_KEY)
            
            if versionOfLastRun == nil {
                // First start after installing the app
                firebaseService.subscribe(toTopic: "IOS_BANK_RM_V\(currentVersion ?? "")")
            }
            else if versionOfLastRun != currentVersion {
                // App was updated since last run
                firebaseService.subscribe(toTopic: "IOS_BANK_RM_V\(currentVersion ?? "")")
                firebaseService.unsubscribe(fromTopic: "IOS_BANK_RM_V\(versionOfLastRun ?? "")")
            }
            else {
                // nothing changed
            }
            KeyChainService.sharedInstance.setValue(string: currentVersion ?? "", key: AppConstants.APP_PREVIOUS_VERSION_KEY)
        }
    }
    
    /**
     Subscribe user level to firebase.
     */
    func updateUserLevelOnShareCount() {
        if let userLevel = getUserLevelOnShareCount() {
            let firebaseService = FirebaseService()
            firebaseService.subscribe(toTopic: userLevel)
            if userLevel == INTERMEDIATE {
                firebaseService.unsubscribe(fromTopic: BEGINNER)
            }
            else if userLevel == EXPERT {
                firebaseService.unsubscribe(fromTopic: BEGINNER)
                firebaseService.unsubscribe(fromTopic: INTERMEDIATE)
            }
        }
    }
    
    func getShareCount() -> Int {
        let pdfCount = Int(KeyChainService.sharedInstance.getValue(key: ConfigKeys.PDF_COUNT_KEY) ?? "0") ?? 0
        let posterCount = Int(KeyChainService.sharedInstance.getValue(key: ConfigKeys.POSTER_COUNT_KEY) ?? "0") ?? 0
        let videoCount = Int(KeyChainService.sharedInstance.getValue(key: ConfigKeys.VIDEO_COUNT_KEY) ?? "0") ?? 0
        
        return (pdfCount + posterCount + videoCount)
    }
    
    func getUserLevelOnShareCount() -> String?{
        
        let count = getShareCount()
        
        if count < 25 {
            return BEGINNER
        }
        else if (count >= 25 && count < 75) {
            return INTERMEDIATE
        }
        else if (count >= 75) {
            return EXPERT
        }
        else {
            return nil
        }
    }
    
    func getUserTypeNameFromId(userType:Int?) -> String? {
        switch userType ?? 0 {
        case 1:
            return MF_RM
        case 2:
            return BANK_CSO
        case 3:
            return BANK_RM
        default:
            return nil
        }
    }
    
    /**
     Save notifcation data in keychain.
     */
    func saveNotificationDataInKeychain(userInfo:[String:AnyObject]) {
        let pushNotificationDataObj = AnnouncementData(announcementData: userInfo)
        
        let annoucement = NSKeyedArchiver.archivedData(withRootObject: pushNotificationDataObj)
        KeyChainService.sharedInstance.setValue(data: annoucement, key: AppConstants.PUSH_NOTIFICATION_DATA_KEY)
    }
    
    /**
     Delete notification data from keychain.
     */
    func deleteNotificationDataFromKeychain() {
        KeyChainService.sharedInstance.deleteValue(key: AppConstants.PUSH_NOTIFICATION_DATA_KEY)
    }
    
    /**
     Save notifcation data in local database.
     */
    func saveNotificationData(userInfo:[AnyHashable:Any]) {
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            let mfNotificationRepo = CoreDataService.sharedInstance.mfNotificationRepo(context:managedObjectContext)
            mfNotificationRepo.createNotification(userInfo: userInfo)
        }
    }
    
}
