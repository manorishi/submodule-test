//
//  NewItemMapperRepo.swift
//  Core
//
//  Created by kunal singh on 21/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 NewItemMapperRepo perform CRUD operation on NewItemMapper entity.
 */

import Foundation
import CoreData

public class NewItemMapperRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "NewItemMapper"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func newItemObjectFromDictionary(newItem: Dictionary<String, Any>) -> NewItemMapper{
        let newItemManagedObject = NewItemMapper(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let itemId = newItem["id"] {
            newItemManagedObject.id =  itemId as? Int32 ?? 0
        }
        if let contentId = newItem["contentId"] {
            newItemManagedObject.content_id =  contentId as? Int32 ?? 0
        }
        if let contentTypeId = newItem["contentTypeId"] {
            newItemManagedObject.content_type_id =  contentTypeId as? Int16 ?? 0
        }
        if let sequence = newItem["sequence"] {
            newItemManagedObject.sequence =  sequence as? Int16 ?? 0
        }
        return newItemManagedObject
    }
    
    
    func createNewItem(newItemArray: [Dictionary<String, Any>]) -> Bool{
        for content:Dictionary in newItemArray {
            if !createEntry(object: newItemObjectFromDictionary(newItem: content)){
                return false
            }
        }
        return true
    }
    
    func deleteNewItem() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func newItemHavingId(itemId: Int16) -> NewItemMapper?{
        return readEntry(condition: NSPredicate(format: "id == %d", itemId), entity: entityName, context: managedContext) as? NewItemMapper ?? nil
    }
    
    public func newItems() -> [NewItemMapper]{
        return readAllEntries(entity: entityName, context: managedContext) as? [NewItemMapper] ?? []
    }
    
    
}

