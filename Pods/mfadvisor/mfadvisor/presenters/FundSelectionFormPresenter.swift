//
//  FundSelectionFormPresenter.swift
//  mfadvisor
//
//  Created by Anurag Dake on 08/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import DropDown

/**
 FundSelectionFormPresenter handle UI logic for FundSelectionFormViewController
 It adds borders to buttons, underlines to textfields, initialise dropdown to show validation errors
 */
class FundSelectionFormPresenter: NSObject{
    
    weak var fundSelectionFormViewController: FundSelectionFormViewController!
    var fundSelectionFormInteractor: FundSelectionFormInteractor!
    
    private let FUND_PRESENTATION_VIEW_CONTROLLER = "FundPresentationViewController"
    
    init(fundSelectionFormViewController: FundSelectionFormViewController) {
        self.fundSelectionFormViewController = fundSelectionFormViewController
        fundSelectionFormInteractor = FundSelectionFormInteractor()
    }
    
    func addBorderToButtons(buttons: [UIButton]){
        for button in buttons{
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
        }
    }
    
    func underlineTextFields(textfields: [UITextField], color: UIColor = UIColor.darkGray){
        for textField in textfields{
            underLineTextField(textfield: textField, color: color)
        }
    }
    
    func underLineTextField(textfield: UITextField, color: UIColor = UIColor.darkGray){
        textfield.underlined(underlineColor: color)
    }
    
    func minMaxValuesForFunds(managedObjectContext: NSManagedObjectContext, selectionFundItems: [SelectionFundItem]){
        fundSelectionFormInteractor.minMaxValuesForFunds(managedObjectContext: managedObjectContext, selectionFundItems: selectionFundItems)
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
     Set anchoe view for dropdown
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
    
    func gotoFundPresentation(managedObjectContext:NSManagedObjectContext?, mFSelectionItem: MFSelectionItem?, customerName: String?){
        var fundPresentationViewController: FundPresentationViewController?
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            fundPresentationViewController = FundPresentationViewController(nibName:FUND_PRESENTATION_VIEW_CONTROLLER, bundle: bundle)
            fundPresentationViewController?.mFSelectionItem = mFSelectionItem
            fundPresentationViewController?.managedObjectContext = managedObjectContext
            fundPresentationViewController?.customerName = customerName
            fundSelectionFormViewController.navigationController?.pushViewController(fundPresentationViewController!, animated: true)
        }
    }
}
