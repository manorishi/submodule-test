//
//  Favourite+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension Favourite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourite> {
        return NSFetchRequest<Favourite>(entityName: "Favourite")
    }

    @NSManaged public var content_id: Int32
    @NSManaged public var content_type_id: Int16
    @NSManaged public var is_favourite: Bool
    @NSManaged public var is_synced: Bool

}
