//
//  MetaImageHerolineSelection+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Apple on 28/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaImageHerolineSelection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaImageHerolineSelection> {
        return NSFetchRequest<MetaImageHerolineSelection>(entityName: "MetaImageHerolineSelection");
    }

    @NSManaged public var duration_upto: Int16
    @NSManaged public var hero_line: String?
    @NSManaged public var hero_line_type: Int16
    @NSManaged public var image: String?
    @NSManaged public var risk: String?

}
