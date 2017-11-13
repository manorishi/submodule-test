//
//  CalculationDetailsTableRowView.swift
//  mfadvisor
//
//  Created by Anurag Dake on 12/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

class CalculationDetailsTableRowView: UIView{
    
    @IBOutlet weak var column1Label: UILabel!
    @IBOutlet weak var column2Label: UILabel!
    @IBOutlet weak var column3Label: UILabel!
    @IBOutlet weak var column4Label: UILabel!
    @IBOutlet weak var column5Label: UILabel!
    @IBOutlet weak var column6Label: UILabel!
    
    func setCalculationData(calculation: SipSwpCalculation){
        addBorderToViews(borderWidth: 0.4, borderColor: UIColor.lightGray)
        
        let navValue = getTwoDecimalRoundedValue(number: calculation.navValue)
        let units = getTwoDecimalRoundedValue(number: calculation.units)
        let cashFlow = Int(calculation.cashflow.roundToDecimal(0))
        let sipswpvalue = Int(calculation.fundValue.roundToDecimal(0))
        let indexValue = Int(calculation.indexFundValue.roundToDecimal(0))
        
        if let day = calculation.day, let month = calculation.month, let year = calculation.year{
            column1Label.text = "\(day)-\(month)-\(year)"
        }else{
            column1Label.text = "-"
        }
        
        column2Label.text = String(navValue)
        column3Label.text = String(units)
        column4Label.text = getFormattedIntegerText(number: cashFlow)
        column5Label.text = getFormattedIntegerText(number: sipswpvalue)
        column6Label.text = getFormattedIntegerText(number: indexValue)
        updateTextFont()
    }
    
    func updateTextFont(){
        column1Label.adjustsFontSizeToFitWidth = true
        column2Label.adjustsFontSizeToFitWidth = true
        column3Label.adjustsFontSizeToFitWidth = true
        column4Label.adjustsFontSizeToFitWidth = true
        column5Label.adjustsFontSizeToFitWidth = true
        column6Label.adjustsFontSizeToFitWidth = true
    }
    
    func addBorderToViews(borderWidth:CGFloat, borderColor:UIColor) {
        for view in [column1Label, column2Label, column3Label, column4Label, column5Label, column6Label]{
            addViewBorder(view: view!, borderWidth: borderWidth, borderColor: borderColor)
        }
    }
    
}
