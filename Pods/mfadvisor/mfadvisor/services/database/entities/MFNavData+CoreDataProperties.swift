//
//  MFNavData+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Akash Tiwari on 03/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MFNavData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MFNavData> {
        return NSFetchRequest<MFNavData>(entityName: "MFNavData")
    }

    @NSManaged public var benchmark_nav_value: Double
    @NSManaged public var day: Int16
    @NSManaged public var fund_id: Int64
    @NSManaged public var fund_nav_value: Double
    @NSManaged public var id: Int64
    @NSManaged public var month: Int16
    @NSManaged public var year: Int16

}
