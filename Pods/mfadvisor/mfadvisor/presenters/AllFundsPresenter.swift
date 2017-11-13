//
//  AllFundsPresenter.swift
//  mfadvisor
//
//  Created by Apple on 02/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 AllFundsPresenter handle UI logic for AllFundsViewController including navigation to other controllers
 */
class AllFundsPresenter:NSObject,AllFundsScreenProtocol {
    weak var allFundsViewController: AllFundsViewController!
    var allFundsInteractor: AllFundsInteractor!
    let FUND_DETAIL_VIEW_CONTROLLER = "FundDetailViewController"
    
    init(allFundsViewController: AllFundsViewController) {
        self.allFundsViewController = allFundsViewController
        allFundsInteractor = AllFundsInteractor()
    }
    
    /// Get fund data from local database
    func fundsDataList(isExpandable: Bool) -> [AllFundData] {
        return allFundsInteractor.allFundsData(managedObjectContext: allFundsViewController.managedObjectContext!, isExpandable: isExpandable)
    }
    
    func selectedSalesPitchFundData(_ fundata: FundData, fundOptionType: FundOptionsType) {
        switch fundOptionType {
        case .salesPitch:
            gotoSalesPitch(fundId:fundata.fundId, fundName: fundata.name)
        case .performance:
            gotoPerformance(fundId:fundata.fundId, fundName: fundata.name)
        case .presentation:
            gotoPresentation(fundId:fundata.fundId, fundName: fundata.name)
        case .fundComparison:
            gotoFundComparison(fundId:fundata.fundId, fundName: fundata.name)
        case .swpCalculator:
            gotoSwpCalculator(fundId:fundata.fundId, fundName: fundata.name)
        case .sipCalculator:
            gotoSipCalculator(fundId:fundata.fundId, fundName: fundata.name)
        }
    }
    
    func gotoFundComparison(fundId:String, fundName:String?) {
        if let fundDetailVC = fundDetailViewController() {
            fundDetailVC.fundId = fundId
            fundDetailVC.titleString = fundName
            fundDetailVC.moveToFundComparisonViewController()
            allFundsViewController.gotoViewController(fundDetailVC)
        }
    }
    
    func gotoPerformance(fundId:String, fundName:String?) {
        if let fundDetailVC = fundDetailViewController() {
            fundDetailVC.fundId = fundId
            fundDetailVC.titleString = fundName
            fundDetailVC.moveToPerformanceViewController()
            allFundsViewController.gotoViewController(fundDetailVC)
        }
    }
    
    func gotoPresentation(fundId:String, fundName:String?) {
        if let fundDetailVC = fundDetailViewController() {
            fundDetailVC.fundId = fundId
            fundDetailVC.titleString = fundName
            fundDetailVC.moveToPresentationViewController()
            allFundsViewController.gotoViewController(fundDetailVC)
        }
    }
    
    func gotoSalesPitch(fundId:String, fundName:String?) {
        if let fundDetailVC = fundDetailViewController() {
            fundDetailVC.fundId = fundId
            fundDetailVC.titleString = fundName
            fundDetailVC.moveToSalesPitchViewController()
            allFundsViewController.gotoViewController(fundDetailVC)
        }
    }
    
    func gotoSwpCalculator(fundId:String, fundName:String?) {
        if let swpCalculatorVC = fundDetailViewController() {
            swpCalculatorVC.fundId = fundId
            swpCalculatorVC.titleString = fundName
            swpCalculatorVC.moveToSWPCalculatorViewController()
            swpCalculatorVC.hidesBottomBarWhenPushed = true
            allFundsViewController.gotoViewController(swpCalculatorVC)
        }
    }
    
    func gotoSipCalculator(fundId:String, fundName:String?) {
        if let sipCalculatorVC = fundDetailViewController() {
            sipCalculatorVC.fundId = fundId
            sipCalculatorVC.titleString = fundName
            sipCalculatorVC.moveToSIPCalculatorViewController()
            sipCalculatorVC.hidesBottomBarWhenPushed = true
            allFundsViewController.gotoViewController(sipCalculatorVC)
        }
    }
    
    func fundDetailViewController() -> FundDetailViewController? {
        var fundDetailVC:FundDetailViewController?
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            fundDetailVC = FundDetailViewController(nibName: FUND_DETAIL_VIEW_CONTROLLER, bundle: bundle)
            fundDetailVC?.managedObjectContext = allFundsViewController.managedObjectContext
        }
        return fundDetailVC
    }
    
    /// Get section for collapsible cell
    func getSectionIndex(row: NSInteger, tableViewSection:Int, dataArray:[FundData]) -> Int {
        let indices = getHeaderIndices(tableViewSection: tableViewSection, dataArray: dataArray)
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        
        return -1
    }
    
    /// Get index for rows under collapsible view
    func getRowIndex(row: NSInteger, tableViewSection:Int, dataArray:[FundData]) -> Int {
        var index = row
        let indices = getHeaderIndices(tableViewSection: tableViewSection, dataArray: dataArray)
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        
        return index
    }
    
    func getHeaderIndices(tableViewSection:Int, dataArray:[FundData]) -> [Int] {
        var index = 0
        var indices: [Int] = []
        
        for section in dataArray {
            indices.append(index)
            index += section.items.count + 1
        }
        
        return indices
    }
    
    func marketData(completionHandler:@escaping (_ status:Bool, _ marketData: MarketData?) -> ()){
        allFundsInteractor.liveMarketData(completionHandler: completionHandler)
    }
    
}
