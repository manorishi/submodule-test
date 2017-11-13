//
//  MetaImageHerolineSelectionRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaImageHerolineSelectionRepo contains CRUD operations related to MetaImageHerolineSelection table
 */
public class MetaImageHerolineSelectionRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaImageHerolineSelection"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func imageHerolineSelectionFromDictionary(contentData: Dictionary<String, Any>) -> MetaImageHerolineSelection {
        let contentManagedObject = MetaImageHerolineSelection(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
            
        if let durationUpto = contentData["duration_upto"] {
            contentManagedObject.duration_upto = durationUpto as? Int16 ?? 0
        }
        
        if let risk = contentData["risk"] {
            contentManagedObject.risk = risk as? String ?? ""
        }
        
        if let herolineType = contentData["hero_line_type"] {
            contentManagedObject.hero_line_type = herolineType as? Int16 ?? 0
        }
        
        if let heroLine = contentData["hero_line"] {
            contentManagedObject.hero_line = heroLine as? String ?? ""
        }
        
        if let image = contentData["image"] {
            contentManagedObject.image = image as? String ?? ""
        }

        
        return contentManagedObject
    }
    
    func createImageHerolineSelection(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: imageHerolineSelectionFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func heroLineSelectionItem(durationUpto: Int, risk: String) -> MetaImageHerolineSelection?{
        let duration = durationUpto <= 3 ? 3 : 35
        return readEntry(condition: NSPredicate(format: "duration_upto == %d && risk == %@", duration, risk), entity: entityName, context: managedContext) as? MetaImageHerolineSelection ?? nil
    }
}
