//
//  NotificationRepo.swift
//  Core
//
//  Created by Apple on 19/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 MFNotificationRepo perform CRUD operation on MFNotification entity.
 */

import UIKit
import CoreData

public class MFNotificationRepo: NSObject {

    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MFNotification"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func notificationDataFromUserInfo(_ userInfo:[AnyHashable : Any]) -> MFNotification {
        
        let notificationManagedObject = MFNotification(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        
//        let aps = userInfo["aps"] as? [String:AnyObject]
//        if let data = aps?["alert"] as? [String:AnyObject] {
            if let id = userInfo["id"] {
                notificationManagedObject.id = id as? String ?? ""
            }
            if let title = userInfo["title"] {
                notificationManagedObject.title = title as? String ?? ""
            }
            if let body = userInfo["message"]{
                notificationManagedObject.body = body as? String ?? ""
            }
            notificationManagedObject.date = NSDate()
        //}
        return notificationManagedObject
    }
    
    func isNotificationDataPresent(userInfo:[AnyHashable : Any]) -> Bool {
        if let id = userInfo["id"] as? String {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            do {
                let count = try managedContext?.count(for: fetchRequest)
                return count == 0 ? false : true
            }
            catch {
                logToConsole(printObject: error as NSError)
                return false
            }
        }
        else {
            return false
        }
    }
    
    @discardableResult
    public func createNotification(userInfo:[AnyHashable : Any]) -> Bool {
        if !isNotificationDataPresent(userInfo: userInfo) {
            if !createEntry(object: notificationDataFromUserInfo(userInfo)){
                return false
            }
        }
        return true
    }
    
    @discardableResult
    public func deleteNotifications() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func allNotifications() -> [MFNotification] {
        return readAllEntries(entity: entityName, context: managedContext) as? [MFNotification] ?? []
    }
    
    @discardableResult
    public func deleteOldNotificationData() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        fetchRequest.predicate = NSPredicate(format: "date < %@", previousMonth as NSDate)
        do {
            let contentItems = try managedContext?.fetch(fetchRequest) as? [NSManagedObject] ?? []
            for content in contentItems {
                managedContext?.delete(content)
            }
            try managedContext?.save()
        }
        catch {
            logToConsole(printObject: error as NSError)
            return false
        }
        return true
    }
    
    public func lastMonthNotification() -> [MFNotification] {
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        return readEntries(condition: NSPredicate(format: "date >= %@", previousMonth as NSDate), entity: entityName, context: managedContext) as? [MFNotification] ?? []
    }
    
}
