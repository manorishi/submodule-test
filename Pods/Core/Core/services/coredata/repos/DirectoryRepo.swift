//
//  DirectoryRepo.swift
//  Core
//
//  Created by Anurag Dake on 21/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 DirectoryRepo perform CRUD operation on Directory entity.
 */

import Foundation
import CoreData

public class DirectoryRepo{
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "Directory"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func directoryObjectFromDictionary(directory: Dictionary<String, Any>) -> Directory{
        let directoryManagedObject = Directory(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let directoryId = directory["id"] {
            directoryManagedObject.id =  directoryId as? Int32 ?? 0
        }
        if let name = directory["name"] {
            directoryManagedObject.name =  name as? String ?? ""
        }
        if let description = directory["description"]{
            directoryManagedObject.directory_description = description as? String ?? ""
        }
        if let thumbnailUrl = directory["thumbnailUrl"] {
            directoryManagedObject.thumbnail_url =  thumbnailUrl as? String ?? ""
        }
        if let imageVersion = directory["imageVersion"] {
            directoryManagedObject.image_version =  imageVersion as? Int32 ?? 0
        }
        if let displayTypeId = directory["displayTypeId"] {
            directoryManagedObject.display_id_type =  displayTypeId as? Int16 ?? 0
        }
        if let confidential = directory["confidential"] {
            directoryManagedObject.confidential = confidential as? Int ?? 0 == 1 ? true: false
        }
        return directoryManagedObject
    }
    
    
    func createDirectories(directoryArray: [Dictionary<String, Any>]) -> Bool{
        for directory:Dictionary in directoryArray {
            if !createEntry(object: directoryObjectFromDictionary(directory: directory)){
                return false
            }
        }
        return true
    }
    
    func deleteDirectories() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func directoryHavingId(directoryId: Int32) -> Directory?{
        return readEntry(condition: NSPredicate(format: "id == %d", directoryId), entity: entityName, context: managedContext) as? Directory ?? nil
    }
    
    func allDirectories() -> [Directory]{
        return readAllEntries(entity: entityName, context: managedContext) as? [Directory] ?? []
    }
}
