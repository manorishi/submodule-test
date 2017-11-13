//
//  FundSelectionPresentor.swift
//  mfadvisor
//
//  Created by Anurag Dake on 26/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core
import CoreData

/**
 FundSelectionPresentor handle UI logic for FundSelectionViewController such as updating button states and navigating to another controller
 */
class FundSelectionPresentor: NSObject{
    
    weak var fundSelectionViewController: FundSelectionViewController!
    var fundSelectionInteractor: FundSelectionInteractor!
    
    private let FUND_SELECTION_DETAILS_VIEW_CONTROLLER = "FundSelectionDetailsViewController"
    
    init(fundSelectionViewController: FundSelectionViewController) {
        self.fundSelectionViewController = fundSelectionViewController
        fundSelectionInteractor = FundSelectionInteractor()
    }
    
    func getBackgroundGradient() -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        let color1 = hexStringToUIColor(hex: "C44B7E").cgColor
        let color2 = hexStringToUIColor(hex: "70193D").cgColor
        let color3 = hexStringToUIColor(hex: "AE275F").cgColor
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        gradientLayer.colors = [color1, color3,color2]
        return gradientLayer
    }
    
    func clearRiskManagerButtons(){
        fundSelectionViewController.riskButtonManager.unselectAllButtons()
    }
    
    func enable(button: UIButton){
        button.isEnabled = true
        button.backgroundColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
    }
    
    func disable(button: UIButton){
        button.isEnabled = false
        button.backgroundColor = UIColor.lightGray
    }
    
    func isSelectFundEnable() -> Bool{
        return fundSelectionViewController.investmentPeriodButtonManager.selectedButton() != nil && fundSelectionViewController.riskButtonManager.selectedButton() != nil && fundSelectionViewController.customerAgeButtonManager.selectedButton() != nil  && fundSelectionViewController.lockInPeriodButtonManager.selectedButton() != nil
    }
    
    func updateFundSelectButtonState(button: UIButton){
        isSelectFundEnable() ? enable(button: button) : disable(button: button)
    }
    
    func fundsWithSlot(managedObjectContext:NSManagedObjectContext, minAge: Int, maxAge: Int?, minDuration: Int, maxDuration: Int?, riskAppetite: String, lockInFlag: String) -> [String:Float]{
        return fundSelectionInteractor.fundsWithSlots(managedObjectContext: managedObjectContext, minAge: minAge, maxAge: maxAge, minDuration: minDuration, maxDuration: maxDuration, riskAppetite: riskAppetite, lockInFlag: lockInFlag)
    }
    
    func gotoFundSelectionDetails(managedObjectContext:NSManagedObjectContext?, fundsWithAllocation: [String:Float], maxDuration: Int, riskAppetite: String, mFSelectionItem: MFSelectionItem?){
        var fundSelectionDetailsViewController: FundSelectionDetailsViewController?
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            fundSelectionDetailsViewController = FundSelectionDetailsViewController(nibName:FUND_SELECTION_DETAILS_VIEW_CONTROLLER, bundle: bundle)
            fundSelectionDetailsViewController?.managedObjectContext = managedObjectContext
            fundSelectionDetailsViewController?.fundsWithAllocation = fundsWithAllocation
            fundSelectionDetailsViewController?.maxDuration = maxDuration
            fundSelectionDetailsViewController?.riskAppetite = riskAppetite
            fundSelectionDetailsViewController?.mFSelectionItem = mFSelectionItem
            fundSelectionViewController.navigationController?.pushViewController(fundSelectionDetailsViewController!, animated: true)
        }
        
    }
    
    func fundSelectionData(managedObjectContext:NSManagedObjectContext, fundsWithAllocation: [String : Float], maxDuration: Int, riskAppetite: String) -> MFSelectionItem{
        return FundSelectionDetailsInteractor().getFundData(managedObjectContext: managedObjectContext, fundsWithAllocation: fundsWithAllocation, maxDuration: maxDuration, riskAppetite: riskAppetite)
    }
}
