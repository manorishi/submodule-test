//
//  MetaMutualFundMinInvestmentRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaMutualFundMinInvestmentRepo contains CRUD operations related to MetaMutualFundMinInvestment table
 */
public class MetaMutualFundMinInvestmentRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaMutualFundMinInvestment"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func mutualFundMinInvestmentFromDictionary(contentData: Dictionary<String, Any>) -> MetaMutualFundMinInvestment {
        let contentManagedObject = MetaMutualFundMinInvestment(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        
        if let fundId = contentData["fund_id"] {
            contentManagedObject.fund_id =  fundId as? String ?? ""
            
            if let lumpsumMinimum = contentData["lumpsum_minimum"] {
                contentManagedObject.lumpsum_minimum = lumpsumMinimum as? Float ?? 0
            }
            
            if let lumpsumMaximum = contentData["lumpsum_maximum"] {
                contentManagedObject.lumpsum_maximum = lumpsumMaximum as? Double ?? 0
            }
            
            if let sipMinimum = contentData["sip_minimum"] {
                contentManagedObject.sip_minimum = sipMinimum as? Float ?? 0
            }
            
            if let sipMaximum = contentData["sip_maximum"] {
                contentManagedObject.sip_maximum = sipMaximum as? Double ?? 0
            }
            
            if let sipMinMultiple = contentData["sip_min_multiple"] {
                contentManagedObject.sip_min_multiple = sipMinMultiple as? Float ?? 0
            }
            
            if let lumpsumMinMultiple = contentData["lumpsum_min_multiple"] {
                contentManagedObject.lumpsum_min_multiple = lumpsumMinMultiple as? Float ?? 0
            }
        }
        
        return contentManagedObject
    }
    
    func createMutualFundMinInvestment(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: mutualFundMinInvestmentFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func contentHavingId(fundId: String) -> MetaMutualFundMinInvestment? {
        return readEntry(condition: NSPredicate(format: "fund_id == %@", fundId), entity: entityName, context: managedContext) as? MetaMutualFundMinInvestment ?? nil
    }
}
