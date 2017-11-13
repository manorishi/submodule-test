//
//  FirebaseService.swift
//  smartsell
//
//  Created by Apple on 24/05/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Firebase

/**
 Initialise Firebase, get fcm token, subscribe and unsubscribe topic.
 */

class FirebaseService:ExternalServicesProtocol {

    func initializeService() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = (UIApplication.shared.delegate as? AppDelegate)
    }
    
    func getFCMToken() -> String? {
        return Messaging.messaging().fcmToken
    }
    
    func subscribe(toTopic:String) {
        Messaging.messaging().subscribe(toTopic: toTopic)
    }
    
    func unsubscribe(fromTopic:String) {
        Messaging.messaging().unsubscribe(fromTopic: fromTopic)
    }
}
