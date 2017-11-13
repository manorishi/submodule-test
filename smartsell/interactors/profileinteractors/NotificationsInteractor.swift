//
//  NotificationsInteractor.swift
//  smartsell
//
//  Created by Anurag Dake on 13/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import CoreData
import Core

/**
 Get data from notification table and delete old notification data.
 */

class NotificationsInteractor {
    
    /**
     Get notification data from local db.
     */
    func getNotificationData(managedObjectContext:NSManagedObjectContext) -> [NotificationData] {
        let mfNotificationRepo = CoreDataService.sharedInstance.mfNotificationRepo(context:managedObjectContext)
        let mfNotificationArray = mfNotificationRepo.lastMonthNotification()
        var notificationDataArray:[NotificationData] = []
        for mfNotification in mfNotificationArray {
            let notificationData = NotificationData(mfNotification: mfNotification)
            notificationDataArray.append(notificationData)
        }
        return notificationDataArray
    }
    
    /**
     Delete old notification data.
     */
    @discardableResult
    func deleteOldNotificationData(managedObjectContext:NSManagedObjectContext) -> Bool {
          let mfNotificationRepo = CoreDataService.sharedInstance.mfNotificationRepo(context:managedObjectContext)
        return mfNotificationRepo.deleteOldNotificationData()
    }
    
}
