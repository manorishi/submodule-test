//
//  MetaOtherFundData+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Akash Tiwari on 27/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaOtherFundData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaOtherFundData> {
        return NSFetchRequest<MetaOtherFundData>(entityName: "MetaOtherFundData")
    }

    @NSManaged public var alpha: Float
    @NSManaged public var beta: Float
    @NSManaged public var entry_load: String?
    @NSManaged public var exit_load: String?
    @NSManaged public var expense_ratio: Float
    @NSManaged public var fund_avg_maturity: Float
    @NSManaged public var fund_mean: Float
    @NSManaged public var fund_modified_duration: Float
    @NSManaged public var fund_selection_assurance: String?
    @NSManaged public var fund_sharpe: Float
    @NSManaged public var fund_sortino: Float
    @NSManaged public var fund_std_dev: Float
    @NSManaged public var fund_ytm: Float
    @NSManaged public var liquidity_options: String?
    @NSManaged public var lockin_period: String?
    @NSManaged public var other_fund_description: String?
    @NSManaged public var other_fund_id: String?
    @NSManaged public var pe_ratio: Float
    @NSManaged public var portfolio_highlights: String?
    @NSManaged public var product_label: String?
    @NSManaged public var return1_year: Float
    @NSManaged public var return3_year: Float
    @NSManaged public var return5_year: Float
    @NSManaged public var returns_since_inception: Float
    @NSManaged public var risk_highlights: String?
    @NSManaged public var riskometer: String?
    @NSManaged public var sharpe_ratio: Float
    @NSManaged public var since_10k_inception: Float
    @NSManaged public var return3_months: Float
    @NSManaged public var return6_months: Float

}
