//
//  Achievement+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension Achievement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Achievement> {
        return NSFetchRequest<Achievement>(entityName: "Achievement")
    }

    @NSManaged public var item_count: Int32
    @NSManaged public var level: Int16
    @NSManaged public var name: String?
    @NSManaged public var type: Int16

}
