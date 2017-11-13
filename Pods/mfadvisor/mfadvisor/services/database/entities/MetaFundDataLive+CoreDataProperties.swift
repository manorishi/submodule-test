//
//  MetaFundDataLive+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Sunil Sharma on 9/25/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaFundDataLive {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaFundDataLive> {
        return NSFetchRequest<MetaFundDataLive>(entityName: "MetaFundDataLive")
    }

    @NSManaged public var alpha: Float
    @NSManaged public var as_on_date: NSDate?
    @NSManaged public var benchmark1_year_return: Float
    @NSManaged public var benchmark3_year_return: Float
    @NSManaged public var benchmark5_year_return: Float
    @NSManaged public var beta: Float
    @NSManaged public var category_alpha: Float
    @NSManaged public var category_avg_maturity: Float
    @NSManaged public var category_beta: Float
    @NSManaged public var category_mean: Float
    @NSManaged public var category_modified_duration: Double
    @NSManaged public var category_sharpe: Float
    @NSManaged public var category_sortino: Float
    @NSManaged public var category_std_dev: Float
    @NSManaged public var category_ytm: Float
    @NSManaged public var category1_year_return: Float
    @NSManaged public var category3_year_return: Float
    @NSManaged public var category5_year_return: Float
    @NSManaged public var expense_ratio: Float
    @NSManaged public var fund_avg_maturity: Float
    @NSManaged public var fund_id: String?
    @NSManaged public var fund_mean: Float
    @NSManaged public var fund_modified_duration: Double
    @NSManaged public var fund_sharpe: Float
    @NSManaged public var fund_sortino: Float
    @NSManaged public var fund_std_dev: Float
    @NSManaged public var fund_ytm: Float
    @NSManaged public var nav: Float
    @NSManaged public var pe_ratio: Float
    @NSManaged public var return_since_inception: Float
    @NSManaged public var return1_year: Float
    @NSManaged public var return3_year: Float
    @NSManaged public var return5_year: Float
    @NSManaged public var since_10k_inception: Float
    @NSManaged public var as_on_date_performance: NSDate?
    @NSManaged public var as_on_date_parameters: NSDate?
    @NSManaged public var as_on_date_sip: NSDate?
    @NSManaged public var sip_return1_year: Float
    @NSManaged public var sip_return5_year: Float
    @NSManaged public var sip_return3_year: Float
    @NSManaged public var sip_benchmark1_year_return: Float
    @NSManaged public var sip_benchmark5_year_return: Float
    @NSManaged public var sip_benchmark3_year_return: Float
    @NSManaged public var return3_months: Float
    @NSManaged public var return6_months: Float
    @NSManaged public var benchmark3_months_return: Float
    @NSManaged public var benchmark6_months_return: Float

}
