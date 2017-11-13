//
//  MetaFundMaster+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Akash Tiwari on 28/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaFundMaster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaFundMaster> {
        return NSFetchRequest<MetaFundMaster>(entityName: "MetaFundMaster")
    }

    @NSManaged public var fund_benchmark_1: String?
    @NSManaged public var fund_benchmark_2: String?
    @NSManaged public var fund_category_id: String?
    @NSManaged public var fund_end_date: NSDate?
    @NSManaged public var fund_id: String?
    @NSManaged public var fund_inception_date: NSDate?
    @NSManaged public var fund_initials: String?
    @NSManaged public var fund_manager: String?
    @NSManaged public var fund_manager_since: String?
    @NSManaged public var fund_name: String?
    @NSManaged public var fund_snapshot: String?

}
