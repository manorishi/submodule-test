//
//  PosterImageElement+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension PosterImageElement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PosterImageElement> {
        return NSFetchRequest<PosterImageElement>(entityName: "PosterImageElement")
    }

    @NSManaged public var height: Int16
    @NSManaged public var id: Int32
    @NSManaged public var keep_aspect_ratio: Bool
    @NSManaged public var left_margin: Int16
    @NSManaged public var on_by_default: Bool
    @NSManaged public var poster_id: Int32
    @NSManaged public var shape: String?
    @NSManaged public var top_margin: Int16
    @NSManaged public var width: Int16

}
