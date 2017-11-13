//
//  MetaCategoryMasterRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaCategoryMasterRepo contains CRUD operations related to MetaCategoryMaster table
 */
public class MetaCategoryMasterRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaCategoryMaster"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func categoryMasterFromDictionary(contentData: Dictionary<String, Any>) -> MetaCategoryMaster{
        let contentManagedObject = MetaCategoryMaster(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let id = contentData["cat_id"] {
            contentManagedObject.cat_id =  id as? String ?? ""
            
            if let name = contentData["cat_name"] {
                contentManagedObject.cat_name = name as? String ?? ""
            }
            
            if let catDescription = contentData["cat_description"] {
                contentManagedObject.cat_description = catDescription as? String ?? ""
            }
            
            if let categoryIcon = contentData["cat_icon_ref1"] {
                contentManagedObject.cat_icon_ref1 = categoryIcon as? String ?? ""
            }
            
            if let categoryImage = contentData["cat_image_ref1"] {
                contentManagedObject.cat_image_ref1 = categoryImage as? String ?? ""
            }
        }
        return contentManagedObject
    }
    
    func createCategoryMaster(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: categoryMasterFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func contentHavingId(categoryId: Int32) -> MetaCategoryMaster?{
        return readEntry(condition: NSPredicate(format: "cat_id == %@", categoryId), entity: entityName, context: managedContext) as? MetaCategoryMaster ?? nil
    }
    
    public func allCategories() ->  [MetaCategoryMaster]{
        return readAllEntries(entity: entityName, context: managedContext) as? [MetaCategoryMaster] ?? []
    }

}
