//
//  FundComaprisonPresenter.swift
//  mfadvisor
//
//  Created by Apple on 07/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core

/**
 FundComaprisonPresenter handle UI logic for FundComaprisonViewController such as enable/disable button
 */
class FundComaprisonPresenter: NSObject {

    weak var fundComparisonViewController:FundComaprisonViewController!
    var fundComparisonInteractor:FundComaprisonInteractor!
    
    let FUND_COMPARE_DETAIL_VC = "FundCompareDetailViewController"
    
    init(fundComparisonViewController:FundComaprisonViewController) {
        self.fundComparisonViewController = fundComparisonViewController
        self.fundComparisonInteractor = FundComaprisonInteractor()
    }
    
    func fundCategoryId(fundId:String, managedObjectContext: NSManagedObjectContext) -> String {
        return fundComparisonInteractor.fundCategoryIdHaving(fundId: fundId, managedObjectContext: managedObjectContext)
    }
    
    func otherFundsData(fundCategoryId:String, managedObjectContext: NSManagedObjectContext) -> [MetaOtherFundMaster]{
        return fundComparisonInteractor.otherFunds(fundCategoryId: fundCategoryId, managedObjectContext: managedObjectContext)
    }
    
    func updateCreatePerformanceButton() {
        
        var enableButton = false
        for (_, value) in fundComparisonViewController.otherFundsSelection {
            if value {
                enableButton = true
                break
            }
        }
        
        if enableButton && isAnyYearsSelected() {
            fundComparisonViewController.compareFundsButton.backgroundColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
            fundComparisonViewController.compareFundsButton.isEnabled = true
        }
        else {
            fundComparisonViewController.compareFundsButton.backgroundColor = UIColor.lightGray
            fundComparisonViewController.compareFundsButton.isEnabled = false
            
        }
    }
    
    func isAnyYearsSelected() -> Bool{
        return (fundComparisonViewController.selectedYears.first || fundComparisonViewController.selectedYears.third ||
            fundComparisonViewController.selectedYears.fifth ||
            fundComparisonViewController.selectedYears.threeMonth ||
            fundComparisonViewController.selectedYears.sixMonth)
    }
    
    func getSelectedFundsData() -> [String:String] {
        var selectedFund:[String:String] = [:]
        for otherFundMatser in fundComparisonViewController.otherFundsDataArray {
            if fundComparisonViewController.otherFundsSelection[otherFundMatser.other_fund_id!] == true {
                selectedFund[otherFundMatser.other_fund_id!] = otherFundMatser.fund_name ?? ""
            }
        }
        return selectedFund
    }
    
    func fundComaprisonDetailViewControllerObject() -> FundCompareDetailViewController? {
        var fundComaprisonDetailVC:FundCompareDetailViewController?
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            fundComaprisonDetailVC = FundCompareDetailViewController(nibName: FUND_COMPARE_DETAIL_VC, bundle: bundle)
            fundComaprisonDetailVC?.managedObjectContext = fundComparisonViewController .managedObjectContext
        }
        return fundComaprisonDetailVC
    }
    
}
