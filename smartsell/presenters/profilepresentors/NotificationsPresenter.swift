//
//  NotificationsPresenter.swift
//  smartsell
//
//  Created by Anurag Dake on 13/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import CoreData
import Core

/**
 NotificationsPresenter handle UI logic for NotificationViewController
 */
class NotificationsPresenter: NotificationsProtocol {
    weak var notificationsViewController: NotificationsViewController!
    var notificationsInteractor: NotificationsInteractor!
    
    init(notificationsViewController: NotificationsViewController) {
        self.notificationsViewController = notificationsViewController
        notificationsInteractor = NotificationsInteractor()
    }
    
    @discardableResult
    func deleteOldNotificationData(managedObjectContext:NSManagedObjectContext) -> Bool {
        return notificationsInteractor.deleteOldNotificationData(managedObjectContext: managedObjectContext)
    }
    
    func getNotificationData(managedObjectContext:NSManagedObjectContext) -> [NotificationData] {
        return notificationsInteractor.getNotificationData(managedObjectContext: managedObjectContext)
    }
}
