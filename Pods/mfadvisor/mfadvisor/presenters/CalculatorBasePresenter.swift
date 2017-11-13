//
//  CalculatorBasePresenter.swift
//  mfadvisor
//
//  Created by Anurag Dake on 04/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import DropDown

class CalculatorBasePresenter: NSObject{
    
    var calculatorInteractor: CalculatorInteractor!
    
    override init() {
        calculatorInteractor = CalculatorInteractor()
    }
    
    /**
     Initialise overflow menu
     */
    func initialiseDropDown(dropDown: DropDown){
        dropDown.dataSource = []
        dropDown.direction = .top
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
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! + 4)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)! + 4)
    }
    
    /**
     Defines dropdown actions
     */
    func setDropDownSelectionActions(dropDown: DropDown){
        dropDown.cancelAction = { [] in
            dropDown.hide()
        }
    }

    
    func fundNAVData(fundId: String, managedObjectContext: NSManagedObjectContext) -> [MFNavData]{
        return calculatorInteractor.fundNAVData(fundId: fundId, managedObjectContext: managedObjectContext)
    }
    
    func startAndEndDate(navData: [MFNavData]) -> (startNav: MFNavData?, endNav: MFNavData?){
        return calculatorInteractor.startAndEndDate(navData: navData)
    }
    
    func underlineTextFields(textfields: [UITextField], color: UIColor = UIColor.darkGray){
        for textField in textfields{
            underLineTextField(textfield: textField, color: color)
        }
    }
    
    func underLineTextField(textfield: UITextField, color: UIColor = UIColor.darkGray){
        textfield.underlined(underlineColor: color)
    }
    
    func adjustedDate(year: Int, month: Int) -> Int{
        return (year * 100 + month)
    }
    
    func investmentPeriodText(startMonth: Int, startYear: Int, endMonth: Int, endYear: Int) -> String{
        let startDate = datefrom(day: 1, month: startMonth, year: startYear)
        let endDate = datefrom(day: 1, month: endMonth, year: endYear)
        let components = Calendar.current.dateComponents([.month, .year], from: startDate, to: endDate)
        
        var period = ""
        var yearDiff = components.year ?? 0
        var monthDiff = (components.month ?? 0) + 1
        
        if yearDiff > 0{
            period = "\(yearDiff) yrs"
        }
        if monthDiff > 0{
            if monthDiff == 12{
                yearDiff = yearDiff + 1
                monthDiff = 0
                period = "\(yearDiff) yrs"
            }else{
                period = "\(period) \(monthDiff) mts"
            }
        }
        
        return period
    }
    
    func isDateValid(dateText: String?) -> Bool{
        guard let date = dateText else{
            return false
        }
        return !date.isEmpty
    }
    
    func isEndDateGreaterThanStartDate(startDateText: String?, endDateText: String?) -> Bool{
        guard startDateText != nil && endDateText != nil else{
            return false
        }
        let startDateComponents = dateComponents(dateString: startDateText!)
        let endDateComponents = dateComponents(dateString: endDateText!)
        
        if endDateComponents.year > startDateComponents.year{
            return true
        }else if endDateComponents.year == startDateComponents.year{
            return endDateComponents.month > startDateComponents.month
        }else{
            return false
        }
    }
}
