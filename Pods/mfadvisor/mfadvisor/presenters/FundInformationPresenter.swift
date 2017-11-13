//
//  FundInformationPresenter.swift
//  mfadvisor
//
//  Created by Anurag Dake on 28/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

class FundInformationPresenter: NSObject{
    
    var fundDetailInteractor: FundDetailInteractor!
    
    let SALESPITCH_VIEW_CONTROLLER = "SalesPitchViewController"
    let PERFORMANCE_VIEW_CONTROLLER = "PerformanceViewController"
    
    override init() {
        fundDetailInteractor = FundDetailInteractor()
    }
    
    func fundNameFrom(fundId:String, managedObjectContext: NSManagedObjectContext) -> String? {
        return fundDetailInteractor.fundNameFrom(fundId: fundId, managedObjectContext: managedObjectContext)
    }
    
    func salesPitchViewControllerObject(managedObjectContext:NSManagedObjectContext, fundId:String,fundName:String?) -> SalesPitchViewController? {
        
        var salesPitchVC:SalesPitchViewController?
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            salesPitchVC = SalesPitchViewController(nibName: SALESPITCH_VIEW_CONTROLLER, bundle: bundle)
            salesPitchVC?.managedObjectContext = managedObjectContext
            salesPitchVC?.fundId = fundId
            salesPitchVC?.fundName = fundName
            salesPitchVC?.loadView()
            salesPitchVC?.viewDidLoad()
        }
        return salesPitchVC
    }
    
    func performanceViewControllerObject(managedObjectContext:NSManagedObjectContext, fundId:String,fundName:String?) -> PerformanceViewController? {
        
        var performanceVC:PerformanceViewController?
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            performanceVC = PerformanceViewController(nibName: PERFORMANCE_VIEW_CONTROLLER, bundle: bundle)
            performanceVC?.managedObjectContext = managedObjectContext
            performanceVC?.fundId = fundId
            performanceVC?.fundName = fundName
        }
        return performanceVC
    }
}
