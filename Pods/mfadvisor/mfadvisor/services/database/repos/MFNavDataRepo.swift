//
//  MFNavData.swift
//  mfadvisor
//
//  Created by Akash Tiwari on 03/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core

public class MFNavDataRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MFNavData"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func fundMFNavDataFromDictionary(contentData: Dictionary<String, Any>) -> MFNavData {
        let contentManagedObject = MFNavData(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let id = contentData["id"] {
            contentManagedObject.id =  id as? Int64 ?? 0
            
            if let fundId = contentData["fund_id"] {
                contentManagedObject.fund_id = fundId as? Int64 ?? 0
            }
            
            if let fundNavValue = contentData["fund_nav_value"] {
                contentManagedObject.fund_nav_value = fundNavValue as? Double ?? 0.0
            }
            
            if let year = contentData["year"] {
                contentManagedObject.year = year as? Int16 ?? 0
            }
            
            if let month = contentData["month"] {
                contentManagedObject.month = month as? Int16 ?? 0
            }
            
            if let day = contentData["day"] {
                contentManagedObject.day = day as? Int16 ?? 0
            }
            
            if let benchmarkNavValue = contentData["benchmark_nav_value"] {
                contentManagedObject.benchmark_nav_value = benchmarkNavValue as? Double ?? 0.0
            }
        }
        return contentManagedObject
    }
    
    func createMFNavData(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: fundMFNavDataFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func navDataHaving(fundId: Int64) -> [MFNavData] {
        return readEntries(condition: NSPredicate(format: "fund_id == %d", fundId), entity: entityName, context: managedContext) as? [MFNavData] ?? []
    }
    
    public func getMaxNavDataId() -> Int64 {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        do {
            let fetchedElements = try managedContext?.fetch(fetchRequest) as? [NSManagedObject] ?? []
            if fetchedElements.count > 0{
                return (fetchedElements[0] as! MFNavData).id
            } else {
                return 0
            }
        } catch {
            logToConsole(printObject: error as NSError)
            return 0
        }
    }
}

