//
//  NotificationData.swift
//  smartsell
//
//  Created by Apple on 20/05/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

/**
 Conatins notification data.
 */
class NotificationData: NSObject {
    var title:String!
    var body:String!
    var date:String!
    var time:String!
    
    init(mfNotification:MFNotification) {
        self.title = mfNotification.title ?? ""
        self.body = mfNotification.body ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yy"
        let date = mfNotification.date as Date? ?? Date()
        self.date = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "hh:mm a"
        self.time = dateFormatter.string(from: date)
    }
}
