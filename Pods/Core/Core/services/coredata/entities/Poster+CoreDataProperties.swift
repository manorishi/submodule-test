//
//  Poster+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension Poster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Poster> {
        return NSFetchRequest<Poster>(entityName: "Poster")
    }

    @NSManaged public var id: Int32
    @NSManaged public var image_version: Int32
    @NSManaged public var name: String?
    @NSManaged public var poster_description: String?
    @NSManaged public var share_text: String?
    @NSManaged public var thumbnail_url: String?

}
