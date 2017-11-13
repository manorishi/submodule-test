//
//  MetaFundData+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Apple on 28/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaFundData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaFundData> {
        return NSFetchRequest<MetaFundData>(entityName: "MetaFundData");
    }

    @NSManaged public var compare_icon1: String?
    @NSManaged public var compare_icon2: String?
    @NSManaged public var compare_icon3: String?
    @NSManaged public var compare_point1: String?
    @NSManaged public var compare_point2: String?
    @NSManaged public var compare_point3: String?
    @NSManaged public var disclaimer1: String?
    @NSManaged public var exit_load: String?
    @NSManaged public var fund_description: String?
    @NSManaged public var fund_id: String?
    @NSManaged public var fund_type1: String?
    @NSManaged public var fund_type2: String?
    @NSManaged public var key_ratio_label1: String?
    @NSManaged public var key_ratio_label2: String?
    @NSManaged public var key_ratio_label3: String?
    @NSManaged public var liquidity_options: String?
    @NSManaged public var lockin_period: String?
    @NSManaged public var other_fund1_id: String?
    @NSManaged public var other_fund2_id: String?
    @NSManaged public var other_fund3_id: String?
    @NSManaged public var other_fund4_id: String?
    @NSManaged public var product_label: String?
    @NSManaged public var product_label_disclaimer: String?
    @NSManaged public var riskometer: String?
    @NSManaged public var specialty_disclaimer: String?
    @NSManaged public var specialty_icon1: String?
    @NSManaged public var specialty_icon2: String?
    @NSManaged public var specialty_icon3: String?
    @NSManaged public var specialty_line1: String?
    @NSManaged public var specialty_line2: String?
    @NSManaged public var specialty_line3: String?
    @NSManaged public var tenure_line: String?
    @NSManaged public var top_image1: String?
    @NSManaged public var top_image2: String?

}
