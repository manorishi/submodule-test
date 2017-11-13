//
//  UserAchievementRepo.swift
//  Core
//
//  Created by Apple on 06/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 UserAchievementRepo perform CRUD operation on UserAchievement entity.
 */

import Foundation
import CoreData

public class UserAchievementRepo {
    
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "UserAchievement"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func userAchievementObjectFromDictionary(userAchievement: Dictionary<String, Any>, is_synced: Bool) -> UserAchievement {
        let userAchievementManagedObject = UserAchievement(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let achievement_level = userAchievement["achievement_level"]{
            userAchievementManagedObject.achievement_level = achievement_level as? Int16 ?? 0
        }
        if let achieved_at = userAchievement["achieved_at"] as? String{
            userAchievementManagedObject.achieved_at = date(from: achieved_at)
        }
        userAchievementManagedObject.is_synced = is_synced
        return userAchievementManagedObject
    }
    
    private func date(from: String) -> NSDate?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.date(from: from) as NSDate?
    }
    
    @discardableResult
    public func createUserAchievement(userAchievementsArray: [Dictionary<String, Any>]) -> Bool{
        for userAchievement:Dictionary in userAchievementsArray {
            if !createEntry(object: userAchievementObjectFromDictionary(userAchievement: userAchievement, is_synced: true)){
                return false
            }
        }
        return true
    }
    
    @discardableResult
    public func addUserAchievement(userAchievement:[String : Any], isSynced: Bool) -> Bool{
        if !createEntry(object: userAchievementObjectFromDictionary(userAchievement: userAchievement, is_synced: isSynced)){
            return false
        }
        return true
    }
    
    @discardableResult
    public func deleteUserAchievements() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func allUserAchievement() -> [UserAchievement]{
        return readAllEntries(entity: entityName, context: managedContext) as? [UserAchievement] ?? []
    }

}
