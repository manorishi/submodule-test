//
//  Directory+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 15/09/17.
//
//

import Foundation
import CoreData


extension Directory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Directory> {
        return NSFetchRequest<Directory>(entityName: "Directory")
    }

    @NSManaged public var directory_description: String?
    @NSManaged public var display_id_type: Int16
    @NSManaged public var id: Int32
    @NSManaged public var image_version: Int32
    @NSManaged public var name: String?
    @NSManaged public var thumbnail_url: String?
    @NSManaged public var confidential: Bool

}
