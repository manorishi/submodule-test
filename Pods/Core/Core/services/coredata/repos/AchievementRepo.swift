//
//  AchievementRepo.swift
//  Core
//
//  Created by kunal singh on 20/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 AchievementRepo perform CRUD operation on Achievement entity.
 */

import Foundation
import CoreData

public class AchievementRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "Achievement"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func achievementObjectFromDictionary(achievement: Dictionary<String, Any>, type: AchievementType) -> Achievement{
        let achievementManagedObject = Achievement(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let level = achievement["level"] {
            achievementManagedObject.level =  level as? Int16 ?? 0
        }
        achievementManagedObject.type = Int16(type.rawValue)
        switch type {
        case .fundSelector:
            if let item_count = achievement["fs_item_count"] {
                achievementManagedObject.item_count =  item_count as? Int32 ?? 0
            }
            if let achievement_description = achievement["fs_achievement"] {
                achievementManagedObject.name =  achievement_description as? String
            }
        case .marketingMaterial:
            if let item_count = achievement["mm_item_count"] {
                achievementManagedObject.item_count =  item_count as? Int32 ?? 0
            }
            if let achievement_description = achievement["mm_achievement"] {
                achievementManagedObject.name =  achievement_description as? String
            }
        }
        return achievementManagedObject
    }
    
    func createAchievements(achievementArray: [Dictionary<String, Any>], type: AchievementType) -> Bool{
        for achievement:Dictionary in achievementArray {
            if !createEntry(object: achievementObjectFromDictionary(achievement: achievement, type: type)){
                return false
            }
        }
        return true
    }
    
    func deleteAchievements() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func allAchievements(type: AchievementType) -> [Achievement] {
        return readEntries(condition: NSPredicate(format: "type == %d", Int16(type.rawValue)), entity: entityName, context: managedContext) as? [Achievement] ?? []
    }
    
}
