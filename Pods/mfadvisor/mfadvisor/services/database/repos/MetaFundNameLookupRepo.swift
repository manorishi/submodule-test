//
//  MetaFundNameLookupRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaFundNameLookupRepo contains CRUD operations related to MetaFundNameLookup table
 */
public class MetaFundNameLookupRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaFundNameLookup"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func fundNameLookupFromDictionary(contentData: Dictionary<String, Any>) -> MetaFundNameLookup {
        let contentManagedObject = MetaFundNameLookup(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        
        if let id = contentData["fund_id"] {
            contentManagedObject.fund_id =  id as? String ?? ""
            
            if let fundSlot = contentData["fund_slot"] {
                contentManagedObject.fund_slot = fundSlot as? String ?? ""
            }
            
        }
        return contentManagedObject
    }
    
    func createFundNameLookup(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: fundNameLookupFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func contentHavingId(fundId: Int32) -> MetaFundNameLookup? {
        return readEntry(condition: NSPredicate(format: "fund_id == %@", fundId), entity: entityName, context: managedContext) as? MetaFundNameLookup ?? nil
    }
    
    public func fundIdHaving(slot: String) -> String?{
        guard let fundNameLookUpEntry = readEntry(condition: NSPredicate(format: "fund_slot == %@", slot), entity: entityName, context: managedContext) as? MetaFundNameLookup else{
            return nil
        }
        return fundNameLookUpEntry.fund_id
    }
}
