//
//  MetaCategoryMaster+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Apple on 28/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaCategoryMaster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaCategoryMaster> {
        return NSFetchRequest<MetaCategoryMaster>(entityName: "MetaCategoryMaster");
    }

    @NSManaged public var cat_description: String?
    @NSManaged public var cat_icon_ref1: String?
    @NSManaged public var cat_id: String?
    @NSManaged public var cat_image_ref1: String?
    @NSManaged public var cat_name: String?

}
