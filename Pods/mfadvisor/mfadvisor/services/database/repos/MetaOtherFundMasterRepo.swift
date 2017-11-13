//
//  MetaOtherFundMasterRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaOtherFundMasterRepo contains CRUD operations related to MetaOtherFundMaster table
 */
public class MetaOtherFundMasterRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaOtherFundMaster"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func otherFundMasterFromDictionary(contentData: Dictionary<String, Any>) -> MetaOtherFundMaster {
        let contentManagedObject = MetaOtherFundMaster(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let id = contentData["other_fund_id"] {
            contentManagedObject.other_fund_id =  id as? String ?? ""
            
            if let fundName = contentData["fund_name"] {
                contentManagedObject.fund_name = fundName as? String ?? ""
            }
            
            if let fundManager = contentData["fund_manager"] {
                contentManagedObject.fund_manager = fundManager as? String ?? ""
            }
            
            if let benchmark1 = contentData["benchmark1"] {
                contentManagedObject.benchmark1 = benchmark1 as? String ?? ""
            }
            
            if let benchmark2 = contentData["benchmark2"] {
                contentManagedObject.benchmark2 = benchmark2 as? String ?? ""
            }
            
            if let fundCategoryId = contentData["fund_category_id"] {
                contentManagedObject.fund_category_id = fundCategoryId as? String ?? ""
            }
            
            if let fundSnapshot = contentData["fund_snapshot"] {
                contentManagedObject.fund_snapshot = fundSnapshot as? String ?? ""
            }
        }
        return contentManagedObject
    }
    
    
    func createOtherFundMaster(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: otherFundMasterFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    func fundsOfCategory(categoryId:String) -> [MetaOtherFundMaster]{
        return readEntries(condition: NSPredicate(format: "fund_category_id == %@", categoryId), entity: entityName, context: managedContext) as? [MetaOtherFundMaster] ?? []
    }
    
    public func contentHavingId(otherFundId: String) -> MetaOtherFundMaster?{
        return readEntry(condition: NSPredicate(format: "other_fund_id == %@", otherFundId), entity: entityName, context: managedContext) as? MetaOtherFundMaster ?? nil
    }
}
