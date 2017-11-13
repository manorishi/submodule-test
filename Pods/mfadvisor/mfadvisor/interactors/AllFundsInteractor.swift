//
//  AllFundsInteractor.swift
//  mfadvisor
//
//  Created by Apple on 02/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData
import Core

/**
 AllFundsInteractor fetches all funds and its details from db to display on AllFundsViewCOntroller
 */
public class AllFundsInteractor:NSObject {
    
    let META_CATEGORY_MASTER_ENTITY_NAME = "MetaCategoryMaster"
    
    /// Get all funds category from local database and append popular funds on top of array.
    func getFundsCategory(managedObjectContext: NSManagedObjectContext) -> [MetaCategoryMaster] {
        let fundsCategoryRepo = MFADataService.sharedInstance.metaCategoryMasterRepo(context: managedObjectContext)
        var fundsCategory = fundsCategoryRepo.allCategories()
        
        fundsCategory = fundsCategory.sorted(by: { $0.cat_id! < $1.cat_id! })
        
        let popularCategory = MetaCategoryMaster(entity: NSEntityDescription.entity(forEntityName: META_CATEGORY_MASTER_ENTITY_NAME, in: managedObjectContext)!, insertInto: nil)
        
        popularCategory.cat_id =  "-1"
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            popularCategory.cat_name = NSLocalizedString("POPULAR_FUNDS", tableName: nil, bundle: bundle, value: "", comment: "")
        }
        else {
            popularCategory.cat_name = ""
        }
        
        popularCategory.cat_description = ""
        popularCategory.cat_icon_ref1 = ""
        popularCategory.cat_image_ref1 = ""
        
        fundsCategory.insert(popularCategory, at: 0)
        return fundsCategory
    }
    
    /// Get all popular funds from local database and return sorted array based on its position value
    func getPopularFundsIds(managedObjectContext: NSManagedObjectContext) -> [MetaPopularFundsConfig] {
        let popularFundsRepo = MFADataService.sharedInstance.metaPopularFundsConfigRepo(context: managedObjectContext)
        let popularFunds = popularFundsRepo.allPopularFunds()
        let sortedPopularFunds = popularFunds.sorted { $0.position < $1.position}
        return sortedPopularFunds
    }
    
    /// Get all popular fund data from table and return array of FundData
    func popularFundData(managedObjectContext: NSManagedObjectContext) -> [FundData] {
        let popularFundIds = getPopularFundsIds(managedObjectContext: managedObjectContext)
        let fundMasterRepo = MFADataService.sharedInstance.metaFundMasterRepo(context: managedObjectContext)
        let fundDataLiveRepo = MFADataService.sharedInstance.metaFundDataLiveRepo(context: managedObjectContext)
        
        var fundDataArray:[FundData] = []
        for popularFund in popularFundIds {
            
            let fundDatamaster = fundMasterRepo.fundHavingId(fundId: popularFund.fund_id!)
            let fundDataLive = fundDataLiveRepo.fundDataLiveHaving(fundId: popularFund.fund_id!)
            var fundData = FundData(fundId: fundDatamaster?.fund_id ?? "", name: fundDatamaster?.fund_name ?? "", fundInitial: fundDatamaster?.fund_initials ?? "", items: fundOptionItems())
            fundData.fundNav = fundDataLive?.nav
            fundDataArray.append(fundData)
        }
        return fundDataArray
    }
    
    ///Return array of AllFundData which conatins all popular fund and category funds data.
    func allFundsData(managedObjectContext: NSManagedObjectContext, isExpandable: Bool) -> [AllFundData] {
        
        let fundMasterRepo = MFADataService.sharedInstance.metaFundMasterRepo(context: managedObjectContext)
        let fundDataLiveRepo = MFADataService.sharedInstance.metaFundDataLiveRepo(context: managedObjectContext)
        let categories = getFundsCategory(managedObjectContext: managedObjectContext)
        
        var allFundDataArray:[AllFundData] = []
        
        for category in categories {
            var fundDataArray:[FundData] = []
            
            if category.cat_id == "-1" {
                fundDataArray = popularFundData(managedObjectContext: managedObjectContext)
            }
            else {
                let categoryFunds = fundMasterRepo.fundHavingCategoryId(categoryId: category.cat_id!)
                for fund in categoryFunds {
                    var fundData = FundData(fundId: fund.fund_id!, name: fund.fund_name ?? "", fundInitial: fund.fund_initials ?? "", items: fundOptionItems())
                    let fundDataLive = fundDataLiveRepo.fundDataLiveHaving(fundId: fund.fund_id!)
                    fundData.fundNav = fundDataLive?.nav
                    fundDataArray.append(fundData)
                }
            }
            if fundDataArray.count != 0 {
                let allFundData = AllFundData(categoryId: category.cat_id!, categoryName: category.cat_name ?? "", fundData: fundDataArray, isExpandable: isExpandable)
                allFundDataArray.append(allFundData)
            }
        }
        return allFundDataArray
    }
    
    /// Return array of strings containing funds options
    func fundOptionItems() -> [String] {
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
        return [NSLocalizedString("SALES_PITCH_FAQ", tableName: nil, bundle: bundle, value: "", comment: ""),
                NSLocalizedString("PRESENTATION_SHOW_SHARE", tableName: nil, bundle: bundle, value: "", comment: ""),
                NSLocalizedString("DETAILED_PERFORMANCE_DATA", tableName: nil, bundle: bundle, value: "", comment: ""),
                NSLocalizedString("FUND_COMPARISON", tableName: nil, bundle: bundle, value: "", comment: ""),
                NSLocalizedString("CALCULATE_SWP", tableName: nil, bundle: bundle, value: "", comment: ""),
                NSLocalizedString("CALCULATE_SIP", tableName: nil, bundle: bundle, value: "", comment: "")]
        }
        return []
    }
    
    public func liveMarketData(completionHandler:@escaping (_ status:Bool, _ marketData: MarketData?) -> ()){
        let marketDataParser = MarketDataParser()
        let marketData: MarketData = MarketData()
        var isSensexDataAvailable = false, isNiftyDataAvailable = false
        
        NetworkService.sharedInstance.networkClient?.doGETRequest(requestURL: MFUrlConstants.sensexDataUrl, params: nil, httpBody: nil, completionHandler: { (responseStatus, response) in
            DispatchQueue.main.async{
                isSensexDataAvailable = true
                switch responseStatus{
                case .success:
                    let sensexData = marketDataParser.parseMarketData(response: response)
                    marketData.bseIndex = sensexData.index
                    marketData.bseDaysChange = sensexData.daysChange
                    marketData.bseOpen = sensexData.open
                    marketData.bsePrevClose = sensexData.close
                    marketData.dataDate = sensexData.date
                    if isSensexDataAvailable && isNiftyDataAvailable{
                        completionHandler(true,  marketData)
                    }
                default:
                    completionHandler(false, nil)
                }
            }
        })
        
        NetworkService.sharedInstance.networkClient?.doGETRequest(requestURL: MFUrlConstants.niftyDataUrl, params: nil, httpBody: nil, completionHandler: { (responseStatus, response) in
            DispatchQueue.main.async{
                isNiftyDataAvailable = true
                switch responseStatus{
                case .success:
                    let niftyData = marketDataParser.parseMarketData(response: response)
                    marketData.nseIndex = niftyData.index
                    marketData.nseDaysChange = niftyData.daysChange
                    marketData.nseOpen = niftyData.open
                    marketData.nsePrevClose = niftyData.close
                    marketData.dataDate = niftyData.date
                    if isSensexDataAvailable && isNiftyDataAvailable{
                        completionHandler(true,  marketData)
                    }
                default:
                    completionHandler(false, nil)
                }
            }
        })
    }
    
}
