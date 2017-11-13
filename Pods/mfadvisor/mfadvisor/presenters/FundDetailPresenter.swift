//
//  FundDetailPresenter.swift
//  mfadvisor
//
//  Created by Apple on 07/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData

/**
 FundDetailPresenter handle UI logic for FundDetailViewController
 */
class FundDetailPresenter: NSObject {

    weak var fundDetailViewController: FundDetailViewController!
    var fundDetailInteractor: FundDetailInteractor!
    
    let SALESPITCH_VIEW_CONTROLLER = "SalesPitchViewController"
    let PRESENTATION_VIEW_CONTROLLER = "PresentationViewController"
    let PERFORMANCE_VIEW_CONTROLLER = "PerformanceViewController"
    let FUNDCOMPARISON_VIEW_CONTROLLER = "FundComaprisonViewController"
    let SWPCALCULATOR_VIEW_CONTROLLER = "SWPCalViewController"
    let SIPCALCULATOR_VIEW_CONTROLLER = "SIPCalViewController"
    
    init(fundDetailViewController: FundDetailViewController) {
        self.fundDetailViewController = fundDetailViewController
        fundDetailInteractor = FundDetailInteractor()
    }
    
    func fundNameFrom(fundId:String, managedObjectContext: NSManagedObjectContext) -> String? {
        return fundDetailInteractor.fundNameFrom(fundId: fundId, managedObjectContext: managedObjectContext)
    }
    
    func salesPitchViewControllerObject(managedObjectContext:NSManagedObjectContext, fundId:String,fundName:String?) -> SalesPitchViewController? {
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else { return nil }
        let salesPitchVC = SalesPitchViewController(nibName: SALESPITCH_VIEW_CONTROLLER, bundle: bundle)
        salesPitchVC.managedObjectContext = managedObjectContext
        salesPitchVC.fundId = fundId
        salesPitchVC.fundName = fundName
        salesPitchVC.loadView()
        salesPitchVC.viewDidLoad()
        return salesPitchVC
    }
    
    func presentationViewControllerObject(managedObjectContext:NSManagedObjectContext, fundId:String,fundName:String?) -> PresentationViewController? {
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else { return nil }
        let presentationVC = PresentationViewController(nibName: PRESENTATION_VIEW_CONTROLLER, bundle: bundle)
        presentationVC.managedObjectContext = managedObjectContext
        presentationVC.fundId = fundId
        presentationVC.fundName = fundName
        return presentationVC
    }
    
    func performanceViewControllerObject(managedObjectContext:NSManagedObjectContext, fundId:String,fundName:String?) -> PerformanceViewController? {
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else { return nil }
        let performanceVC = PerformanceViewController(nibName: PERFORMANCE_VIEW_CONTROLLER, bundle: bundle)
        performanceVC.managedObjectContext = managedObjectContext
        performanceVC.fundId = fundId
        performanceVC.fundName = fundName
        return performanceVC
    }
    
    func fundComaprisonViewControllerObject(managedObjectContext:NSManagedObjectContext, fundId:String,fundName:String?) -> FundComaprisonViewController? {
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else { return nil }
        let fundComaprisonVC = FundComaprisonViewController(nibName: FUNDCOMPARISON_VIEW_CONTROLLER, bundle: bundle)
        fundComaprisonVC.managedObjectContext = managedObjectContext
        fundComaprisonVC.fundId = fundId
        fundComaprisonVC.fundName = fundName
        return fundComaprisonVC
    }
    
    func swpCalculatorViewControllerObject(managedObjectContext:NSManagedObjectContext, fundId:String,fundName:String?) -> SWPCalViewController? {
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else { return nil }
        let swpCalculatorVC = SWPCalViewController(nibName: SWPCALCULATOR_VIEW_CONTROLLER, bundle: bundle)
        swpCalculatorVC.managedObjectContext = managedObjectContext
        swpCalculatorVC.fundId = fundId
        swpCalculatorVC.fundName = fundName
        return swpCalculatorVC
    }
    
    func sipCalculatorViewControllerObject(managedObjectContext:NSManagedObjectContext, fundId:String,fundName:String?) -> SIPCalViewController? {
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else { return nil }
        let sipCalculatorVC = SIPCalViewController(nibName: SIPCALCULATOR_VIEW_CONTROLLER, bundle: bundle)
        sipCalculatorVC.managedObjectContext = managedObjectContext
        sipCalculatorVC.fundId = fundId
        sipCalculatorVC.fundName = fundName
        return sipCalculatorVC
    }
    
}
