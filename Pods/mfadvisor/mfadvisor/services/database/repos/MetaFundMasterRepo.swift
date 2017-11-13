//
//  MetaFundMasterRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaFundMasterRepo contains CRUD operations related to MetaFundMaster table
 */
public class MetaFundMasterRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaFundMaster"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func fundMasterFromDictionary(contentData: Dictionary<String, Any>) -> MetaFundMaster {
        let contentManagedObject = MetaFundMaster(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let id = contentData["fund_id"] {
            contentManagedObject.fund_id =  id as? String ?? ""
            
            if let fundName = contentData["fund_name"] {
                contentManagedObject.fund_name = fundName as? String ?? ""
            }
            
            if let fundInitials = contentData["fund_initials"] {
                contentManagedObject.fund_initials = fundInitials as? String ?? ""
            }
            
            if let fundManager = contentData["fund_manager"] {
                contentManagedObject.fund_manager = fundManager as? String ?? ""
            }
            
            if let fundManagerSince = contentData["fund_manager_since"] {
                contentManagedObject.fund_manager_since = fundManagerSince as? String ?? ""
            }
            
            if let fundBenchmark1 = contentData["fund_benchmark_1"] {
                contentManagedObject.fund_benchmark_1 = fundBenchmark1 as? String ?? ""
            }
            
            if let fundBenchmark2 = contentData["fund_benchmark_2"] {
                contentManagedObject.fund_benchmark_2 = fundBenchmark2 as? String ?? ""
            }
            
            if let fundCategoryId = contentData["fund_category_id"] {
                contentManagedObject.fund_category_id = fundCategoryId as? String ?? ""
            }
            
            if let fundInceptionDate = dateFromString(contentData["fund_inception_date"] as? String ?? "") {
                contentManagedObject.fund_inception_date = fundInceptionDate as NSDate?
            }
            
            if let fundEndDate = dateFromString(contentData["fund_end_date"] as? String ?? "") {
                contentManagedObject.fund_end_date = fundEndDate as NSDate?
            }
            
            if let fundSnapshot = contentData["fund_snapshot"] {
                contentManagedObject.fund_snapshot = fundSnapshot as? String ?? ""
            }
            
        }
        return contentManagedObject
    }
    
    private func dateFromString(_ string:String?) -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.date(from:string ?? "")
    }
    
    func createFundMaster(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: fundMasterFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func fundHavingId(fundId: String) -> MetaFundMaster?{
        return readEntry(condition: NSPredicate(format: "fund_id == %@", fundId), entity: entityName, context: managedContext) as? MetaFundMaster ?? nil
    }
    
    func fundHavingCategoryId(categoryId: String) -> [MetaFundMaster] {
        return readEntries(condition: NSPredicate(format: "fund_category_id == %@", categoryId), entity: entityName, context: managedContext) as? [MetaFundMaster] ?? []
    }
    
    public func allFundMaster() -> [MetaFundMaster] {
        return readAllEntries(entity: entityName, context: managedContext) as? [MetaFundMaster] ?? []
    }
}
