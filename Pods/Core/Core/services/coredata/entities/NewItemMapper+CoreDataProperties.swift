//
//  NewItemMapper+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension NewItemMapper {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewItemMapper> {
        return NSFetchRequest<NewItemMapper>(entityName: "NewItemMapper")
    }

    @NSManaged public var content_id: Int32
    @NSManaged public var content_type_id: Int16
    @NSManaged public var id: Int32
    @NSManaged public var sequence: Int16

}
