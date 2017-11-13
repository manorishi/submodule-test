//
//  UserDirectoryContentMapperRepo.swift
//  Core
//
//  Created by Anurag Dake on 24/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 UserDirectoryContentMapperRepo perform CRUD operation on UserDirectoryContentMapper entity.
 */

import Foundation
import CoreData

public class UserDirectoryContentMapperRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "UserDirectoryContentMapper"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func userDirectoryContentObjectFromDictionary(userDirectoryContent: Dictionary<String, Any>, userTypeId: Int16) -> UserDirectoryContentMapper?{
        guard let userTypeIdObject = userDirectoryContent["userTypeId"] as? Int16  else {
            return nil
        }
        if userTypeIdObject != userTypeId{
            return nil
        }
        
        let userDirectoryContentManagedObject = UserDirectoryContentMapper(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let userDirectoryContentId = userDirectoryContent["id"] {
            userDirectoryContentManagedObject.id =  userDirectoryContentId as? Int32 ?? 0
        }
        if let directoryId = userDirectoryContent["directoryId"] {
            userDirectoryContentManagedObject.directory_id =  directoryId as? Int32 ?? 0
        }
        if let contentId = userDirectoryContent["contentId"] {
            userDirectoryContentManagedObject.content_id =  contentId as? Int32 ?? 0
        }
        if let contentTypeId = userDirectoryContent["contentTypeId"] {
            userDirectoryContentManagedObject.content_type_id =  contentTypeId as? Int16 ?? 0
        }
        if let sequence = userDirectoryContent["sequence"] {
            userDirectoryContentManagedObject.sequence =  sequence as? Int16 ?? 0
        }
        userDirectoryContentManagedObject.user_type_id = userTypeIdObject
        return userDirectoryContentManagedObject
    }
    
    func createUserDirectoryContent(userDirectoryContentArray: [Dictionary<String, Any>], userTypeId: Int16) -> Bool{
        for content:Dictionary in userDirectoryContentArray {
            let directoryData = userDirectoryContentObjectFromDictionary(userDirectoryContent: content, userTypeId: userTypeId)
            if let directorytObject = directoryData {
                if !createEntry(object: directorytObject){
                    return false
                }
            }
        }
        return true
    }
    
    func deleteUserDirectoryContents() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func userDirectoryContentHavingId(userDirectoryContentId: Int32) -> UserDirectoryContentMapper?{
        return readEntry(condition: NSPredicate(format: "id == %d", userDirectoryContentId), entity: entityName, context: managedContext) as? UserDirectoryContentMapper ?? nil
    }
    
    public func userDirectoryContentHavingDirectoryId(directoryId: Int32) -> [UserDirectoryContentMapper]{
        return readEntries(condition: NSPredicate(format: "directory_id == %d", directoryId), entity: entityName, context: managedContext) as? [UserDirectoryContentMapper] ?? []
    }
    
    public func userDirectoryContents() -> [UserDirectoryContentMapper]{
        return readAllEntries(entity: entityName, context: managedContext) as? [UserDirectoryContentMapper] ?? []
    }
    
    public func favouriteContentWith(contentIds:[Int32]) -> [UserDirectoryContentMapper] {
        if contentIds.count != 0 {
            return readEntries(condition: NSPredicate(format: "content_id IN %@", contentIds), entity: entityName, context: managedContext) as? [UserDirectoryContentMapper] ?? []
        }
        else{
            return []
        }
    }
}
