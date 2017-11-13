//
//  MetaMutualFundSelectionRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaMutualFundSelectionRepo contains CRUD operations related to MetaMutualFundSelection table
 */
public class MetaMutualFundSelectionRepo: MFABaseRepo {
    
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaMutualFundSelection"
    private let defaultMaxAge = 100
    private let defaultMaxInvestmentDuration = 35
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func mutualFundSelectionFromDictionary(contentData: Dictionary<String, Any>) -> MetaMutualFundSelection {
        let contentManagedObject = MetaMutualFundSelection(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        
        if let id = contentData["id"] {
            contentManagedObject.id =  id as? String ?? ""
            
            if let minAge = contentData["min_age"] {
                contentManagedObject.min_age = minAge as? Int16 ?? 0
            }
            
            if let maxAge = contentData["max_age"] {
                contentManagedObject.max_age = maxAge as? Int16 ?? 0
            }
            
            if let minDuration = contentData["min_duration"] {
                contentManagedObject.min_duration = minDuration as? Int16 ?? 0
            }
            
            if let maxDuration = contentData["max_duration"] {
                contentManagedObject.max_duration = maxDuration as? Int16 ?? 0
            }
            
            if let riskAppetite = contentData["risk_appetite"] {
                contentManagedObject.risk_appetite = riskAppetite as? String ?? ""
            }
            
            if let lockinFlag = contentData["lockin_flag"] {
                contentManagedObject.lockin_flag = lockinFlag as? String ?? ""
            }
            
            if let slot1 = contentData["slot1"] {
                contentManagedObject.slot1 = slot1 as? Float ?? 0.0
            }
            
            if let slot2 = contentData["slot2"] {
                contentManagedObject.slot2 = slot2 as? Float ?? 0.0
            }
            
            if let slot3 = contentData["slot3"] {
                contentManagedObject.slot3 = slot3 as? Float ?? 0.0
            }
            
            if let slot4 = contentData["slot4"] {
                contentManagedObject.slot4 = slot4 as? Float ?? 0.0
            }
            
            if let slot5 = contentData["slot5"] {
                contentManagedObject.slot5 = slot5 as? Float ?? 0.0
            }
            
            if let slot6 = contentData["slot6"] {
                contentManagedObject.slot6 = slot6 as? Float ?? 0.0
            }
            
        }
        return contentManagedObject
    }
    
    func createMutualFundSelection(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: mutualFundSelectionFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func contentHavingId(id: Int32) -> MetaMutualFundSelection? {
        return readEntry(condition: NSPredicate(format: "id == %@", id), entity: entityName, context: managedContext) as? MetaMutualFundSelection ?? nil
    }
    
    public func contentWith(minAge: Int, maxAge: Int?, minDuration: Int, maxDuration: Int?, riskAppetite: String, lockInFlag: String) -> MetaMutualFundSelection?{
        let maxA = maxAge == nil ? defaultMaxAge : maxAge
        let maxD = maxDuration == nil ? defaultMaxInvestmentDuration : maxDuration
        return readEntry(condition: NSPredicate(format: "min_age == %d && max_age == %d && min_duration == %d && max_duration == %d && risk_appetite == %@ && lockin_flag == %@", minAge, maxA!, minDuration, maxD!, riskAppetite, lockInFlag), entity: entityName, context: managedContext) as? MetaMutualFundSelection ?? nil
    }
    
}
