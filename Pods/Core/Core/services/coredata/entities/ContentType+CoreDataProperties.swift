//
//  ContentType+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension ContentType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContentType> {
        return NSFetchRequest<ContentType>(entityName: "ContentType")
    }

    @NSManaged public var content_type: String?
    @NSManaged public var id: Int16

}
