//
//  Pdf+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension Pdf {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pdf> {
        return NSFetchRequest<Pdf>(entityName: "Pdf")
    }

    @NSManaged public var id: Int32
    @NSManaged public var image_version: Int32
    @NSManaged public var name: String?
    @NSManaged public var pdf_description: String?
    @NSManaged public var pdf_url: String?
    @NSManaged public var pdf_version: Int32
    @NSManaged public var share_text: String?
    @NSManaged public var thumbnail_url: String?

}
