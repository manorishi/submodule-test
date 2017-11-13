//
//  PosterTextElement+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension PosterTextElement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PosterTextElement> {
        return NSFetchRequest<PosterTextElement>(entityName: "PosterTextElement")
    }

    @NSManaged public var default_text: String?
    @NSManaged public var font_color: String?
    @NSManaged public var font_family: String?
    @NSManaged public var font_size: Int16
    @NSManaged public var id: Int32
    @NSManaged public var left_margin: Int16
    @NSManaged public var on_by_default: Bool
    @NSManaged public var poster_id: Int32
    @NSManaged public var right_margin: Int16
    @NSManaged public var text_alignment: String?
    @NSManaged public var top_margin: Int16

}
