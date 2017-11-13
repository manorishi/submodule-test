//
//  PerformancePresenter.swift
//  mfadvisor
//
//  Created by Apple on 07/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

/**
 PerformancePresenter handle UI logic for PerformanceViewController 
 */
class PerformancePresenter: NSObject {

    weak var performanceViewController:PerformanceViewController!
    
    private let RETURN_AND_RATIO_VC = "ReturnAndRatioViewController"
    
    init(performanceViewController:PerformanceViewController) {
        self.performanceViewController = performanceViewController
    }
    
    func updateCreatePerformanceButton() {
        if performanceViewController.selectedYears.first == true || performanceViewController.selectedYears.third == true || performanceViewController.selectedYears.fifth == true || performanceViewController.selectedYears.threeMonth == true || performanceViewController.selectedYears.sixMonth == true{
            
            performanceViewController.performanceButton.backgroundColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
            performanceViewController.performanceButton.isEnabled = true
        }
        else {
            performanceViewController.performanceButton.backgroundColor = UIColor.lightGray
            performanceViewController.performanceButton.isEnabled = false
            
        }
    }
    
    func returnAndRatioViewController() -> ReturnAndRatioViewController? {
        var returnAndRatioVC:ReturnAndRatioViewController?
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            returnAndRatioVC = ReturnAndRatioViewController(nibName: RETURN_AND_RATIO_VC, bundle: bundle)
            returnAndRatioVC?.managedObjectContext = performanceViewController.managedObjectContext
        }
        return returnAndRatioVC
    }
    
}

