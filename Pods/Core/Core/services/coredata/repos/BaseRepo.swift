//
//  BaseRepo.swift
//  Core
//
//  Created by kunal singh on 21/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 BaseRepo contains common methods for Repo's class like create, delete and read operations from coredata.
 */

import Foundation
import CoreData

/**
 Create and save NSManagedObject to coredata.
 */
func createEntry(object: NSManagedObject) -> Bool{
    do {
        try object.managedObjectContext?.save()
    } catch {
        logToConsole(printObject: error as NSError)
        return false
    }
    return true
}

/**
 Delete NSManagedObjectContext from coredata.
 */
func deleteEntry(entityName: String, context: NSManagedObjectContext?) -> Bool{
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    fetchRequest.includesPropertyValues = false
    do {
        let contentItems = try context?.fetch(fetchRequest) as? [NSManagedObject] ?? []
        for content in contentItems {
            context?.delete(content)
        }
        try context?.save()
    } catch {
        logToConsole(printObject: error as NSError)
        return false
    }
    return true
}

/**
 Get data from coredata entity base on NSPredicate and return NSManagedObject.
 */
public func readEntry(condition: NSPredicate, entity: String, context: NSManagedObjectContext?) -> NSManagedObject?{
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    fetchRequest.predicate = condition
    do {
        let fetchedElements = try context?.fetch(fetchRequest) as? [NSManagedObject] ?? []
        if fetchedElements.count > 0{
            return fetchedElements[0]
        }
    } catch {
        logToConsole(printObject: error as NSError)
        return nil
    }
    return nil
}

/**
 Get data from coredata entity base on NSPredicate and return array of NSManagedObject.
 */
public func readEntries(condition: NSPredicate, entity: String, context: NSManagedObjectContext?) -> [NSManagedObject]{
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    fetchRequest.predicate = condition
    do {
        return try context?.fetch(fetchRequest) as? [NSManagedObject] ?? []
    } catch {
        logToConsole(printObject: error as NSError)
        return []
    }
}

/**
 Get data from coredata entity.
 */
public func readAllEntries(entity: String, context: NSManagedObjectContext?) -> [NSManagedObject]{
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    do {
        return try context?.fetch(fetchRequest) as? [NSManagedObject] ?? []
    } catch {
        logToConsole(printObject: error as NSError)
        return []
    }
}

public func readAllEntriesOrderedBy(key: String, isAscending: Bool, entity: String, condition: NSPredicate?, context: NSManagedObjectContext?) -> [NSManagedObject]{
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    let sortDescriptor = NSSortDescriptor(key: key, ascending: isAscending)
    if let predicateCondition = condition {
        fetchRequest.predicate = predicateCondition
    }
    fetchRequest.sortDescriptors = [sortDescriptor]
    do {
        return try context?.fetch(fetchRequest) as? [NSManagedObject] ?? []
    } catch {
        logToConsole(printObject: error as NSError)
        return []
    }
}


