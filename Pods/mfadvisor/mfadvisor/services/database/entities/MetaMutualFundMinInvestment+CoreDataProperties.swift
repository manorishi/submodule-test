//
//  MetaMutualFundMinInvestment+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Apple on 28/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaMutualFundMinInvestment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaMutualFundMinInvestment> {
        return NSFetchRequest<MetaMutualFundMinInvestment>(entityName: "MetaMutualFundMinInvestment");
    }

    @NSManaged public var fund_id: String?
    @NSManaged public var lumpsum_maximum: Double
    @NSManaged public var lumpsum_min_multiple: Float
    @NSManaged public var lumpsum_minimum: Float
    @NSManaged public var sip_maximum: Double
    @NSManaged public var sip_min_multiple: Float
    @NSManaged public var sip_minimum: Float

}
