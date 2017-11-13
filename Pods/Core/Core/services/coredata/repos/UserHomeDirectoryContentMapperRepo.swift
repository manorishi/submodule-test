//
//  UserHomeDirectoryContentMapper.swift
//  Core
//
//  Created by Anurag Dake on 24/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 UserHomeDirectoryContentMapperRepo perform CRUD operation on UserHomeDirectoryContentMapper entity.
 */

import Foundation
import CoreData

public class UserHomeDirectoryContentMapperRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "UserHomeDirectoryContentMapper"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func userHomeDirectoryContentObjectFromDictionary(userHomeDirectoryContent: Dictionary<String, Any>, userTypeId: Int16) -> UserHomeDirectoryContentMapper?{
        guard let userTypeIdObject = userHomeDirectoryContent["userTypeId"] as? Int16  else {
            return nil
        }
        if userTypeIdObject != userTypeId{
            return nil
        }
        
        let userHomeDirectoryContentManagedObject = UserHomeDirectoryContentMapper(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let userHomeDirectoryContentId = userHomeDirectoryContent["id"] {
            userHomeDirectoryContentManagedObject.id =  userHomeDirectoryContentId as? Int32 ?? 0
        }
        if let contentId = userHomeDirectoryContent["contentId"] {
            userHomeDirectoryContentManagedObject.content_id =  contentId as? Int32 ?? 0
        }
        if let contentTypeId = userHomeDirectoryContent["contentTypeId"] {
            userHomeDirectoryContentManagedObject.content_type_id =  contentTypeId as? Int16 ?? 0
        }
        if let sequence = userHomeDirectoryContent["sequence"] {
            userHomeDirectoryContentManagedObject.sequence =  sequence as? Int16 ?? 0
        }
        userHomeDirectoryContentManagedObject.user_type_id = userTypeIdObject
        return userHomeDirectoryContentManagedObject
    }
    
    
    func createUserHomeDirectoryContent(userHomeDirectoryContentArray: [Dictionary<String, Any>], userTypeId: Int16) -> Bool{
        for content:Dictionary in userHomeDirectoryContentArray {
            let homeContentData = userHomeDirectoryContentObjectFromDictionary(userHomeDirectoryContent: content, userTypeId: userTypeId)
            if let homeContentObject = homeContentData {
                if !createEntry(object: homeContentObject){
                    return false
                }
            }
        }
        return true
    }
    
    func deleteUserHomeDirectoryContents() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func userHomeDirectoryContentHavingId(userHomeDirectoryContentId: Int16) -> UserHomeDirectoryContentMapper?{
        return readEntry(condition: NSPredicate(format: "id == %d", userHomeDirectoryContentId), entity: entityName, context: managedContext) as? UserHomeDirectoryContentMapper ?? nil
    }
    
    public func userHomeDirectoryContents() -> [UserHomeDirectoryContentMapper]{
        return readAllEntries(entity: entityName, context: managedContext) as? [UserHomeDirectoryContentMapper] ?? []
    }
}
