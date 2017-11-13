//
//  SIPCalculatorPresenter.swift
//  mfadvisor
//
//  Created by Anurag Dake on 15/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit


class SIPCalculatorPresenter: CalculatorBasePresenter{
    
    func getMonthlyAmount(sipBasedType: SIPBasedType, amountText: String?) -> Double{
        switch sipBasedType {
        case .monthlyInvestment:
            return Double(amountText ?? "0") ?? 0
        case .targetAmount:
            return 0
        }
    }
    
    func expectedReturns(expectedReturnText: String?) -> Int{
        guard let expReturnsText = expectedReturnText else {
            return 0
        }
        let expReturns = expReturnsText.substring(to: expReturnsText.index(before: expReturnsText.endIndex))
        return Int(expReturns) ?? 0
    }
    
    func tenureText(yearText: String?, monthText: String?) -> String{
        let tenureYear = Int(yearText ?? "0") ?? 0
        let tenureMonth = Int(monthText ?? "0") ?? 0
        return "\(tenureYear) yr \(tenureMonth) month"
    }
    
    func isInvestmentAmountValid(text: String?, for sipBasedOn: SIPBasedType) -> (isValid: Bool, errorStringKey: String?){
        switch sipBasedOn {
        case .monthlyInvestment:
            guard let amountString = text, let amount = Int(amountString), amount >= 500 && amount <= 1000000 else {
                return (false, "monthly_investment_error")
            }
            return (amount % 100 == 0 ? (true, nil) : (false, "monthly_investment_multiple_error"))
            
        case .targetAmount:
            guard let amountString = text, let amount = Int(amountString), amount >= 100000 && amount <= 10000000 else {
                return (false, "target_amount_error")
            }
            return (amount % 1000 == 0 ? (true, nil) : (false, "target_amount_multiple_error"))
        }
    }
    
    func isYearsValid(text: String?) -> (isValid: Bool, errorStringKey: String?){
        guard let yearsString = text, let years = Int(yearsString), years >= 0 && years <= 30 else {
            return (false, "valid_years_error")
        }
        return (true, nil)
    }
    
    func isMonthValid(yearsText: String?, monthtext: String?) -> (isValid: Bool, errorStringKey: String?){
        guard let yearsString = yearsText, let years = Int(yearsString), let monthsString = monthtext, let months = Int(monthsString) else {
            return (false, "valid_months_error")
        }
        if years > 0{
            let condition = months >= 0 && months <= 11
            return (condition ? true : false, condition ? nil : "valid_months_error")
        }else{
            let condition = months >= 2 && months <= 11
            return (condition ? true : false, condition ? nil : "valid_months_for_0_years_error")
        }
    }
    
    func localised(string: String, bundle: Bundle) -> String{
        return NSLocalizedString(string, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    func getFormattedNumberText(number: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:number)) ?? ""
    }
    
}
