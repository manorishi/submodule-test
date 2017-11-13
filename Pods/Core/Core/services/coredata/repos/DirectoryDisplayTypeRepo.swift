//
//  DirectoryDisplayTypeRepo.swift
//  Core
//
//  Created by Anurag Dake on 24/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 DirectoryDisplayTypeRepo perform CRUD operation on DirectoryDisplayType entity.
 */

import Foundation
import CoreData

public class DirectoryDisplayTypeRepo{
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "DirectoryDisplayType"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func directoryDisplayTypeObjectFromDictionary(directoryDisplayType: Dictionary<String, Any>) -> DirectoryDisplayType{
        let directoryDisplayTypeManagedObject = DirectoryDisplayType(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let directoryDisplayTypeId = directoryDisplayType["id"] {
            directoryDisplayTypeManagedObject.id =  directoryDisplayTypeId as? Int32 ?? 0
        }
        if let directoryDisplayType = directoryDisplayType["display_type"] {
            directoryDisplayTypeManagedObject.content_type =  directoryDisplayType as? String ?? ""
        }
        return directoryDisplayTypeManagedObject
    }
    
    
    func createDirectoryDisplayType(directoryDisplayTypeArray: [Dictionary<String, Any>]) -> Bool{
        for directoryDisplayType:Dictionary in directoryDisplayTypeArray {
            if !createEntry(object: directoryDisplayTypeObjectFromDictionary(directoryDisplayType: directoryDisplayType)){
                return false
            }
        }
        return true
    }
    
    func deletedirectoryDisplayType() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func directoryDisplayTypeHavingId(directoryDisplayTypeId: Int16) -> DirectoryDisplayType?{
        return readEntry(condition: NSPredicate(format: "id == %d", directoryDisplayTypeId), entity: entityName, context: managedContext) as? DirectoryDisplayType ?? nil
    }

}
