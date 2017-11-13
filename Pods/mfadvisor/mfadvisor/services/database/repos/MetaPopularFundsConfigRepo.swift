
//
//  MetaPopularFundsConfigRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaPopularFundsConfigRepo contains CRUD operations related to MetaPopularFundsConfig table
 */
public class MetaPopularFundsConfigRepo: MFABaseRepo {
    
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaPopularFundsConfig"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func popularFundsConfigFromDictionary(contentData: Dictionary<String, Any>) -> MetaPopularFundsConfig{
        let contentManagedObject = MetaPopularFundsConfig(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let id = contentData["fund_id"] {
            contentManagedObject.fund_id =  id as? String ?? ""
            
            if let position = contentData["position"] {
                contentManagedObject.position = position as? Int32 ?? 0
            }
        }
        return contentManagedObject
    }
    
    
    func createPopularFundsConfig(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: popularFundsConfigFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    func allPopularFunds() -> [MetaPopularFundsConfig] {
        return readAllEntries(entity: entityName, context: managedContext) as? [MetaPopularFundsConfig] ?? []
    }
    
    public func contentHavingId(fundId: Int32) -> MetaPopularFundsConfig? {
        return readEntry(condition: NSPredicate(format: "fund_id == %@", fundId), entity: entityName, context: managedContext) as? MetaPopularFundsConfig ?? nil
    }
}
