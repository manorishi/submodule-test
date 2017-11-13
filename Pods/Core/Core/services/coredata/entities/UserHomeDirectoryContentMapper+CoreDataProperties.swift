//
//  UserHomeDirectoryContentMapper+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 14/09/17.
//
//

import Foundation
import CoreData


extension UserHomeDirectoryContentMapper {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserHomeDirectoryContentMapper> {
        return NSFetchRequest<UserHomeDirectoryContentMapper>(entityName: "UserHomeDirectoryContentMapper")
    }

    @NSManaged public var content_id: Int32
    @NSManaged public var content_type_id: Int16
    @NSManaged public var id: Int32
    @NSManaged public var sequence: Int16
    @NSManaged public var user_type_id: Int16

}
