//
//  MetaFundNameLookup+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Apple on 28/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaFundNameLookup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaFundNameLookup> {
        return NSFetchRequest<MetaFundNameLookup>(entityName: "MetaFundNameLookup");
    }

    @NSManaged public var fund_id: String?
    @NSManaged public var fund_slot: String?

}
