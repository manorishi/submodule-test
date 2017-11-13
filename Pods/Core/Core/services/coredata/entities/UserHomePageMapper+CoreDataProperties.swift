//
//  UserHomePageMapper+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension UserHomePageMapper {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserHomePageMapper> {
        return NSFetchRequest<UserHomePageMapper>(entityName: "UserHomePageMapper")
    }

    @NSManaged public var id: Int32
    @NSManaged public var item_id: Int32
    @NSManaged public var item_type: Int16
    @NSManaged public var sequence: Int16
    @NSManaged public var user_type_id: Int16

}
