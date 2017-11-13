//
//  ContentTypeRepo.swift
//  Core
//
//  Created by kunal singh on 21/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 ContentTypeRepo perform CRUD operation on ContentType entity.
 */

import Foundation
import CoreData

public class ContentTypeRepo{
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "ContentType"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func contentTypeObjectFromDictionary(contentType: Dictionary<String, Any>) -> ContentType{
        let contentTypeManagedObject = ContentType(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let contentId = contentType["id"] {
            contentTypeManagedObject.id =  contentId as? Int16 ?? 0
        }
        if let contentType = contentType["content_type"] {
            contentTypeManagedObject.content_type =  contentType as? String ?? ""
        }
        return contentTypeManagedObject
    }
    
    func createContentType(contentArray: [Dictionary<String, Any>]) -> Bool{
        for content:Dictionary in contentArray {
            if !createEntry(object: contentTypeObjectFromDictionary(contentType: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func contentHavingId(contentId: Int16) -> ContentType?{
        return readEntry(condition: NSPredicate(format: "id == %d", contentId), entity: entityName, context: managedContext) as? ContentType ?? nil
    }
    
    
}
