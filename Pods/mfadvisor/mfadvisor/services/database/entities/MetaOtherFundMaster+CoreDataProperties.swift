//
//  MetaOtherFundMaster+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Akash Tiwari on 28/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaOtherFundMaster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaOtherFundMaster> {
        return NSFetchRequest<MetaOtherFundMaster>(entityName: "MetaOtherFundMaster")
    }

    @NSManaged public var benchmark1: String?
    @NSManaged public var benchmark2: String?
    @NSManaged public var fund_category_id: String?
    @NSManaged public var fund_manager: String?
    @NSManaged public var fund_name: String?
    @NSManaged public var other_fund_id: String?
    @NSManaged public var fund_snapshot: String?

}
