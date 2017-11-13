//
//  DirectoryDisplayType+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension DirectoryDisplayType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DirectoryDisplayType> {
        return NSFetchRequest<DirectoryDisplayType>(entityName: "DirectoryDisplayType")
    }

    @NSManaged public var content_type: String?
    @NSManaged public var id: Int32

}
