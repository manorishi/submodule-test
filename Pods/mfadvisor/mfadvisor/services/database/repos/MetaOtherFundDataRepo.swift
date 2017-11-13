//
//  MetaOtherFundDataRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaOtherFundDataRepo contains CRUD operations related to MetaOtherFundData table
 */
public class MetaOtherFundDataRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaOtherFundData"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func otherFundDataFromDictionary(contentData: Dictionary<String, Any>) -> MetaOtherFundData {
        let contentManagedObject = MetaOtherFundData(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let id = contentData["other_fund_id"] {
            contentManagedObject.other_fund_id =  id as? String ?? ""
            
            if let otherFundDescription = contentData["other_fund_description"] {
                contentManagedObject.other_fund_description = otherFundDescription as? String ?? ""
            }
            
            if let expenseRatio = contentData["expense_ratio"] {
                contentManagedObject.expense_ratio = expenseRatio as? Float ?? 0.0
            }
            
            if let peRatio = contentData["pe_ratio"] {
                contentManagedObject.pe_ratio = peRatio as? Float ?? 0.0
            }
            
            if let portfolioHighlights = contentData["portfolio_highlights"] {
                contentManagedObject.portfolio_highlights = portfolioHighlights as? String ?? ""
            }
            
            if let riskHighlights = contentData["risk_highlights"] {
                contentManagedObject.risk_highlights = riskHighlights as? String ?? ""
            }
            
            if let exitLoad = contentData["exit_load"] {
                contentManagedObject.exit_load = exitLoad as? String ?? ""
            }
            
            if let entryLoad = contentData["entry_load"] {
                contentManagedObject.entry_load = entryLoad as? String ?? ""
            }
            
            if let lockinPeriod = contentData["lockin_period"] {
                contentManagedObject.lockin_period = lockinPeriod as? String ?? ""
            }
            
            if let fundSelectionAssurance = contentData["fund_selection_assurance"] {
                contentManagedObject.fund_selection_assurance = fundSelectionAssurance as? String ?? ""
            }
            
            if let alpha = contentData["alpha"] {
                contentManagedObject.alpha = alpha as? Float ?? 0.0
            }
            
            if let beta = contentData["beta"] {
                contentManagedObject.beta = beta as? Float ?? 0.0
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
                contentManagedObject.fund_modified_duration = fundModifiedDuration as? Float ?? 0.0
            }
            
            if let fundYtm = contentData["fund_ytm"] {
                contentManagedObject.fund_ytm = fundYtm as? Float ?? 0.0
            }
            
            if let fundAvgMaturity = contentData["fund_avg_maturity"] {
                contentManagedObject.fund_avg_maturity = fundAvgMaturity as? Float ?? 0.0
            }
            
            if let liquidityOptions = contentData["liquidity_options"] {
                contentManagedObject.liquidity_options = liquidityOptions as? String ?? ""
            }
            
            if let riskometer = contentData["riskometer"] {
                contentManagedObject.riskometer = riskometer as? String ?? ""
            }
            
            if let productLabel = contentData["product_label"] {
                contentManagedObject.product_label = productLabel as? String ?? ""
            }
            
            if let sharpeRatio = contentData["sharpe_ratio"] {
                contentManagedObject.sharpe_ratio = sharpeRatio as? Float ?? 0.0
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
            
            if let return3Month = contentData["return3_months"] {
                contentManagedObject.return3_months = return3Month as? Float ?? 0.0
            }
            
            if let return6Month = contentData["return6_months"] {
                contentManagedObject.return6_months = return6Month as? Float ?? 0.0
            }
            
            if let returnsSinceInception = contentData["returns_since_inception"] {
                contentManagedObject.returns_since_inception = returnsSinceInception as? Float ?? 0.0
            }
            
            if let since10kInception = contentData["since_10k_inception"] {
                contentManagedObject.since_10k_inception = since10kInception as? Float ?? 0.0
            }
        }
        return contentManagedObject
    }
    
    
    func createOtherFundDataFromDictionary(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: otherFundDataFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func contentHavingId(otherFundId: String) -> MetaOtherFundData?{
        return readEntry(condition: NSPredicate(format: "other_fund_id == %@", otherFundId), entity: entityName, context: managedContext) as? MetaOtherFundData ?? nil
    }
    
    public func otherFundDataHaving(fundIds:[String]) -> [MetaOtherFundData] {
        if fundIds.count != 0 {
            return readEntries(condition: NSPredicate(format: "other_fund_id IN %@", fundIds), entity: entityName, context: managedContext) as? [MetaOtherFundData] ?? []
        }
        else{
            return []
        }
    }
}
