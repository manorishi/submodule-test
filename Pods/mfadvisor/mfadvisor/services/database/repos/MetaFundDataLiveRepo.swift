//
//  MetaFundDataLiveRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaFundDataLiveRepo contains CRUD operations related to MetaFundDataLive table
 */
public class MetaFundDataLiveRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaFundDataLive"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func fundDataLiveFromDictionary(contentData: Dictionary<String, Any>) -> MetaFundDataLive {
        let contentManagedObject = MetaFundDataLive(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let id = contentData["fund_id"] {
            contentManagedObject.fund_id =  id as? String ?? ""
            
            if let expenseRatio = contentData["expense_ratio"] {
                contentManagedObject.expense_ratio = expenseRatio as? Float ?? 0.0
            }
            
            if let peRatio = contentData["pe_ratio"] {
                contentManagedObject.pe_ratio = peRatio as? Float ?? 0.0
            }
            
            if let nav = contentData["nav"] {
                contentManagedObject.nav = nav as? Float ?? 0.0
            }
            
            if let return1Year = contentData["return1_year"] {
                contentManagedObject.return1_year = return1Year as? Float ?? 0.0
            }
            
            if let return3Year = contentData["return3_year"] {
                contentManagedObject.return3_year = return3Year as? Float ?? 0.0
            }
            
            if let return5Year = contentData["return5_year"] {
                contentManagedObject.return5_year = return5Year as? Float ?? 0.0
            }
            
            if let return3Months = contentData["return3_months"] {
                contentManagedObject.return3_months = return3Months as? Float ?? 0.0
            }
            
            if let return6Months = contentData["return6_months"] {
                contentManagedObject.return6_months = return6Months as? Float ?? 0.0
            }
            
            if let returnSinceInception = contentData["return_since_inception"] {
                contentManagedObject.return_since_inception = returnSinceInception as? Float ?? 0.0
            }
            
            if let since10kInception = contentData["since_10k_inception"] {
                contentManagedObject.since_10k_inception = since10kInception as? Float ?? 0.0
            }
            
            if let category1YearReturn = contentData["category1_year_return"] {
                contentManagedObject.category1_year_return = category1YearReturn as? Float ?? 0.0
            }
            
            if let category3YearReturn = contentData["category3_year_return"] {
                contentManagedObject.category3_year_return = category3YearReturn as? Float ?? 0.0
            }
            
            if let category5YearReturn = contentData["category5_year_return"] {
                contentManagedObject.category5_year_return = category5YearReturn as? Float ?? 0.0
            }
            
            if let benchmark1YearReturn = contentData["benchmark1_year_return"] {
                contentManagedObject.benchmark1_year_return = benchmark1YearReturn as? Float ?? 0.0
            }
            
            if let benchmark3YearReturn = contentData["benchmark3_year_return"] {
                contentManagedObject.benchmark3_year_return = benchmark3YearReturn as? Float ?? 0.0
            }
            
            if let benchmark5YearReturn = contentData["benchmark5_year_return"] {
                contentManagedObject.benchmark5_year_return = benchmark5YearReturn as? Float ?? 0.0
            }
            
            if let benchmark3MonthReturn = contentData["benchmark3_months_return"] {
                contentManagedObject.benchmark3_months_return = benchmark3MonthReturn as? Float ?? 0.0
            }
            
            if let benchmark6MonthReturn = contentData["benchmark6_months_return"] {
                contentManagedObject.benchmark6_months_return = benchmark6MonthReturn as? Float ?? 0.0
            }
            
            if let sipReturn1Year = contentData["sip_return1_year"] {
                contentManagedObject.sip_return1_year = sipReturn1Year as? Float ?? 0.0
            }
            
            if let sipReturn3Year = contentData["sip_return3_year"] {
                contentManagedObject.sip_return3_year = sipReturn3Year as? Float ?? 0.0
            }
            
            if let sipReturn5Year = contentData["sip_return5_year"] {
                contentManagedObject.sip_return5_year = sipReturn5Year as? Float ?? 0.0
            }
            
            if let sipBenchmark1YearReturn = contentData["sip_benchmark1_year_return"] {
                contentManagedObject.sip_benchmark1_year_return = sipBenchmark1YearReturn as? Float ?? 0.0
            }
            
            if let sipBenchmark3YearReturn = contentData["sip_benchmark3_year_return"] {
                contentManagedObject.sip_benchmark3_year_return = sipBenchmark3YearReturn as? Float ?? 0.0
            }
            
            if let sipBenchmark5YearReturn = contentData["sip_benchmark5_year_return"] {
                contentManagedObject.sip_benchmark5_year_return = sipBenchmark5YearReturn as? Float ?? 0.0
            }
            
            if let beta = contentData["beta"] {
                contentManagedObject.beta = beta as? Float ?? 0.0
            }
            
            if let alpha = contentData["alpha"] {
                contentManagedObject.alpha = alpha as? Float ?? 0.0
            }
            
            if let fundStdDev = contentData["fund_std_dev"] {
                contentManagedObject.fund_std_dev = fundStdDev as? Float ?? 0.0
            }
            
            if let fundMean = contentData["fund_mean"] {
                contentManagedObject.fund_mean = fundMean as? Float ?? 0.0
            }
            
            if let fundSharpe = contentData["fund_sharpe"] {
                contentManagedObject.fund_sharpe = fundSharpe as? Float ?? 0.0
            }
            
            if let fundSortino = contentData["fund_sortino"] {
                contentManagedObject.fund_sortino = fundSortino as? Float ?? 0.0
            }
            
            if let fundModifiedDuration = contentData["fund_modified_duration"] {
                contentManagedObject.fund_modified_duration = fundModifiedDuration as? Double ?? 0.0
            }
            
            if let fundYtm = contentData["fund_ytm"] {
                contentManagedObject.fund_ytm = fundYtm as? Float ?? 0.0
            }
            
            if let fundAvgMaturity = contentData["fund_avg_maturity"] {
                contentManagedObject.fund_avg_maturity = fundAvgMaturity as? Float ?? 0.0
            }
            
            if let categoryBeta = contentData["category_beta"] {
                contentManagedObject.category_beta = categoryBeta as? Float ?? 0.0
            }
            
            if let categoryAlpha = contentData["category_alpha"] {
                contentManagedObject.category_alpha = categoryAlpha as? Float ?? 0.0
            }
            
            if let categoryStdDev = contentData["category_std_dev"] {
                contentManagedObject.category_std_dev = categoryStdDev as? Float ?? 0.0
            }
            
            if let categoryMean = contentData["category_mean"] {
                contentManagedObject.category_mean = categoryMean as? Float ?? 0.0
            }
            
            if let categorySharpe = contentData["category_sharpe"] {
                contentManagedObject.category_sharpe = categorySharpe as? Float ?? 0.0
            }
            
            if let categorySortino = contentData["category_sortino"] {
                contentManagedObject.category_sortino = categorySortino as? Float ?? 0.0
            }
            
            if let categoryModifiedDuration = contentData["category_modified_duration"] {
                contentManagedObject.category_modified_duration = categoryModifiedDuration as? Double ?? 0.0
            }
            
            if let categoryYtm = contentData["category_ytm"] {
                contentManagedObject.category_ytm = categoryYtm as? Float ?? 0.0
            }
            
            if let categoryAvgMaturity = contentData["category_avg_maturity"] {
                contentManagedObject.category_avg_maturity = categoryAvgMaturity as? Float ?? 0.0
            }
            
            if let asOnDate = dateFromString(contentData["as_on_date"] as? String) {
                contentManagedObject.as_on_date = asOnDate as NSDate?
            }
            
            if let asOnDatePerformance = dateFromString(contentData["as_on_date_performance"] as? String) {
                contentManagedObject.as_on_date_performance = asOnDatePerformance as NSDate?
            }
            
            if let asOnDateParameters = dateFromString(contentData["as_on_date_parameters"] as? String) {
                contentManagedObject.as_on_date_parameters = asOnDateParameters as NSDate?
            }
            
            if let asOnDateSIP = dateFromString(contentData["as_on_date_sip"] as? String) {
                contentManagedObject.as_on_date_sip = asOnDateSIP as NSDate?
            }
        }
        return contentManagedObject
    }
    
    private func dateFromString(_ string:String?) -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.date(from:string ?? "")
    }
    
    func createFundDataLive(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: fundDataLiveFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func fundDataLiveHaving(fundId: String) -> MetaFundDataLive? {
        return readEntry(condition: NSPredicate(format: "fund_id == %@", fundId), entity: entityName, context: managedContext) as? MetaFundDataLive ?? nil
    }
}
