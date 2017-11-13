//
//  MFABaseRepo.swift
//  mfadvisor
//
//  Created by Apple on 26/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData
import Core

/**
 MFABaseRepo is base repo for all MFAdvisor repos
 */
public class MFABaseRepo {
    func createEntry(object: NSManagedObject) -> Bool{
        do {
            try object.managedObjectContext?.save()
        } catch {
            logToConsole(printObject: error as NSError)
            return false
        }
        return true
    }
    
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
    
    
    public func readAllEntries(entity: String, context: NSManagedObjectContext?) -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            return try context?.fetch(fetchRequest) as? [NSManagedObject] ?? []
        } catch {
            logToConsole(printObject: error as NSError)
            return []
        }
    }
}
