//
//  PresentationPresenter.swift
//  mfadvisor
//
//  Created by Apple on 07/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import DropDown
import CoreData
import Core

/**
 PresentationPresenter handle UI logic for PresentationViewController such as configuring values, initialising dropdown, textfield validations
 */
class PresentationPresenter: NSObject {

    weak var presentationViewController:PresentationViewController!
    var presentationInteractor:PresentationInteractor!
    
    private let FUND_PRESENTATION_VIEW_CONTROLLER = "FundPresentationViewController"
    
    let ENTER_AMOUNT_ERROR = "Enter atleast one amount"
    let INVALID_RANGE_ERROR = "Valid range"
    let INVALID_MULTIPLE_ERROR = "Amount should be multiple of"
    
    init(presentationViewController:PresentationViewController) {
        self.presentationViewController = presentationViewController
        presentationInteractor = PresentationInteractor()
    }
    
    func getMFSelectionItemDataWith(fundId:String, managedObjectContext: NSManagedObjectContext, bundle:Bundle) -> MFSelectionItem {
        return presentationInteractor.getMFSelectionItemDataWith(fundId: fundId, managedObjectContext: managedObjectContext, bundle: bundle)
    }
    
    func getMutualFundMinInvestmentData(fundId:String, managedObjectContext:NSManagedObjectContext) -> MetaMutualFundMinInvestment? {
        return presentationInteractor.getMutualFundMinInvestmentData(fundId: fundId, managedObjectContext: managedObjectContext)
    }
    
    func configView() {
        presentationViewController.customerNameTextField.autocorrectionType = .no
        presentationViewController.investmentAmountTextField.autocorrectionType = .no
        presentationViewController.investmentTypeTextField.autocorrectionType = .no
        
        underlineTextFields(textfields: [presentationViewController.investmentTypeTextField, presentationViewController.investmentAmountTextField, presentationViewController.customerNameTextField])
        addDropDownIconToInvestmentType()
    }
    
    func addDropDownIconToInvestmentType() {
        let imageView = UIImageView(frame: CGRect(x: 5, y: 15, width: 20, height: 20))
        imageView.contentMode = .scaleToFill
        let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder)
        let image = UIImage(named: "ic_drop_down", in: bundle, compatibleWith: nil)
        imageView.image = image
        presentationViewController.investmentTypeTextField.rightView = imageView
        presentationViewController.investmentTypeTextField.rightViewMode = .always
    }
    
    func underlineTextFields(textfields: [UITextField], color: UIColor = UIColor.darkGray){
        for textField in textfields{
            underLineTextField(textfield: textField, color: color)
        }
    }
    
    func underLineTextField(textfield: UITextField, color: UIColor = UIColor.darkGray){
        textfield.underlined(underlineColor: color)
    }
    
    /**
     Initialise overflow menu
     */
    func initialiseDropDown(dropDown: DropDown){
        dropDown.dataSource = []
        dropDown.direction = .bottom
        dropDown.dismissMode = .onTap
        dropDown.backgroundColor = UIColor.black
        dropDown.textColor = UIColor.white
        dropDown.selectionBackgroundColor = dropDown.backgroundColor ?? UIColor.black
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder){
            dropDown.cellNib = UINib(nibName: "DropDownError", bundle: bundle)
        }
    }
    
    /**
     Set anchor view for dropdown
     */
    func setDropDownAnchor(dropDown: DropDown, anchorView: UIView){
        dropDown.anchorView = anchorView
        dropDown.bottomOffset = CGPoint(x: -120, y:(dropDown.anchorView?.plainView.bounds.height)! + 4)
        dropDown.topOffset = CGPoint(x: -1200, y:-(dropDown.anchorView?.plainView.bounds.height)!)
    }
    
    /**
     Defines dropdown actions
     */
    func setDropDownSelectionActions(dropDown: DropDown){
        dropDown.cancelAction = { [] in
            dropDown.hide()
        }
    }
    
    func rangeErrorString(minValue: Float?, maxValue: Double?) -> String{
        return "\(INVALID_RANGE_ERROR) \(String(format: "%d", Int(minValue ?? 0))) - \(String(format: "%d", Int(maxValue ?? 0)))"
    }
    
    func multipleErrorString(multiple: Float?) -> String{
        return "\(INVALID_MULTIPLE_ERROR) \(String(format: "%d", Int(multiple ?? 0)))"
    }

    func isValidLumpsumAmount(lumpsumAmount:Double, fundMinInvestmentData:MetaMutualFundMinInvestment?) -> Bool {
        if let maxLumpSum = fundMinInvestmentData?.lumpsum_maximum, let minLumpSum = fundMinInvestmentData?.lumpsum_minimum,  lumpsumAmount < Double(minLumpSum) || lumpsumAmount > maxLumpSum {
            presentationViewController.displayError(anchorView: presentationViewController.investmentAmountTextField, errorMessage: rangeErrorString(minValue: fundMinInvestmentData?.lumpsum_minimum, maxValue: fundMinInvestmentData?.lumpsum_maximum))
            return false
        }
        else {
            if let multiple = fundMinInvestmentData?.lumpsum_min_multiple, lumpsumAmount.truncatingRemainder(dividingBy: Double(multiple)) != 0 {
                presentationViewController.displayError(anchorView: presentationViewController.investmentAmountTextField, errorMessage: multipleErrorString(multiple: fundMinInvestmentData?.lumpsum_min_multiple))
                return false
            }
        }
        
        return true
    }
    
    func isValidSIPAmount(sipAmount:Double,fundMinInvestmentData:MetaMutualFundMinInvestment?) -> Bool{
        if let maxSip = fundMinInvestmentData?.sip_maximum, let minSip = fundMinInvestmentData?.sip_minimum, sipAmount < Double(minSip) || sipAmount > maxSip {
            presentationViewController.displayError(anchorView: presentationViewController.investmentAmountTextField, errorMessage: rangeErrorString(minValue: fundMinInvestmentData?.sip_minimum, maxValue: fundMinInvestmentData?.sip_maximum))
            return false
        }
        else {
            if let multiple = fundMinInvestmentData?.sip_min_multiple, sipAmount.truncatingRemainder(dividingBy: Double(multiple)) != 0 {
                presentationViewController.displayError(anchorView: presentationViewController.investmentAmountTextField, errorMessage: multipleErrorString(multiple: fundMinInvestmentData?.sip_min_multiple))
                return false
            }
        }
        return true
    }
    
    func isValidAmount(fundMinInvestmentData:MetaMutualFundMinInvestment?) -> Bool{
        if fundMinInvestmentData != nil {
            let investmentAmount = presentationViewController.investmentAmountTextField.text ?? ""
            let selectedInvestmentType = presentationViewController.investmentTypeTextField.text ?? ""
            if investmentAmount.isEmpty {
                presentationViewController.displayError(anchorView: presentationViewController.investmentAmountTextField, errorMessage: ENTER_AMOUNT_ERROR)
                return false
            }
            let lumpsumSipAmount = Double(investmentAmount) ?? 0
            
            if selectedInvestmentType == presentationViewController.LUMPSUM_INVESTMENT {
                return isValidLumpsumAmount(lumpsumAmount: lumpsumSipAmount, fundMinInvestmentData: fundMinInvestmentData)
            }
            else if selectedInvestmentType == presentationViewController.SIP_INVESTMENT {
                return isValidSIPAmount(sipAmount: lumpsumSipAmount, fundMinInvestmentData: fundMinInvestmentData)
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    func updateCreatePresentationButton(investmentAmountTextField:UITextField) {
        if investmentAmountTextField.text?.isEmpty ?? true {
            presentationViewController.createPresentationButton.backgroundColor = UIColor.lightGray
            presentationViewController.createPresentationButton.isEnabled = false
        }
        else {
            presentationViewController.createPresentationButton.backgroundColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
            presentationViewController.createPresentationButton.isEnabled = true
        }
    }
    
    func gotoFundPresentation(managedObjectContext:NSManagedObjectContext?, mFSelectionItem: MFSelectionItem?, customerName: String?){
        var fundPresentationViewController: FundPresentationViewController?
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            fundPresentationViewController = FundPresentationViewController(nibName:FUND_PRESENTATION_VIEW_CONTROLLER, bundle: bundle)
            fundPresentationViewController?.mFSelectionItem = mFSelectionItem
            fundPresentationViewController?.managedObjectContext = managedObjectContext
            fundPresentationViewController?.isFromPagerView = true
            fundPresentationViewController?.customerName = customerName
            presentationViewController.navigationController?.pushViewController(fundPresentationViewController!, animated: true)
        }
    }
    
}
