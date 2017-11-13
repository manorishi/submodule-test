//
//  UserAchievement+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension UserAchievement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAchievement> {
        return NSFetchRequest<UserAchievement>(entityName: "UserAchievement")
    }

    @NSManaged public var achieved_at: NSDate?
    @NSManaged public var achievement_level: Int16
    @NSManaged public var is_synced: Bool

}
