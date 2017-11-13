//
//  SWPCalPresenter.swift
//  mfadvisor
//
//  Created by Anurag Dake on 04/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

class SWPCalPresenter: CalculatorBasePresenter{
    
    func swpOutputData(fundName: String?, withDrawAmount: Int?, startingCapital: Int?, startDate: String?, endDate: String?, vaoDate: String?, fundNavData: [MFNavData], swpType: SWPType, completionHandler:@escaping (_ swpOutput:SWPOutput) -> ()){
        guard startDate != nil && endDate != nil && vaoDate != nil else{
            completionHandler(SWPOutput())
            return
        }
        
        let startDateComponents = dateComponents(dateString: startDate!)
        let endDateComponents = dateComponents(dateString: endDate!)
        let vaoDateComponents = dateComponents(dateString: vaoDate!)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            let swpOutput = SWPOutput()
            swpOutput.fundName = fundName ?? ""
            swpOutput.startCapital = startingCapital ?? 0
            swpOutput.withdrawAmount = withDrawAmount ?? 0
            
            var swpCalculations = self?.swpCalculations(fundNavData: fundNavData, initialAmount: startingCapital ?? 0, withDrawAmount: withDrawAmount ?? 0, startMonth: startDateComponents.month, startYear: startDateComponents.year, endMonth: endDateComponents.month, endYear: endDateComponents.year, swpType: swpType)
            if let lastRow = swpCalculations?.last{
                swpOutput.investmentPeriod = self?.investmentPeriodText(startMonth: startDateComponents.month, startYear: startDateComponents.year, endMonth: lastRow.month, endYear: lastRow.year)
            }else{
                swpOutput.investmentPeriod = "-"
            }
            
            
            if let lastRow = self?.calculateLastRow(fundNavData: fundNavData, lastRowUnits: swpCalculations?.last?.units ?? 0, indexLastRowUnits: swpCalculations?.last?.indexUnits ?? 0, vaoDateComponents: vaoDateComponents){
                swpCalculations?.append(lastRow)
                
                swpOutput.vaoFundValue = lastRow.fundValue
                swpOutput.indexVaoFundValue = lastRow.indexFundValue
            }
            swpOutput.calculations = swpCalculations ?? []
            
            let calculatorUtil = Calculator()
            swpOutput.withdrawTotal = Int(calculatorUtil.getWithdrawTotal(calculations: swpCalculations ?? [], status: false))
            swpOutput.annualIRR = calculatorUtil.getAnnualIrrSwp(calculations: swpCalculations ?? [], swpOutput: swpOutput, forIndexCashflow: false)
            swpOutput.indexAnnualIRR = calculatorUtil.getAnnualIrrSwp(calculations: swpCalculations ?? [], swpOutput: swpOutput, forIndexCashflow: true)
            
            DispatchQueue.main.async {
                completionHandler(swpOutput)
            }
        }
    }
    
    func swpCalculations(fundNavData: [MFNavData], initialAmount: Int, withDrawAmount: Int, startMonth: Int, startYear: Int, endMonth: Int, endYear: Int, swpType: SWPType) -> [SipSwpCalculation]{
        var calculationValues = [SipSwpCalculation]()
        
        var totalUnits: Double = 0
        var totalIndexUnits: Double = 0
        var unitsRanOut = false
        for (index, navData) in getNavValues(fundNavData: fundNavData, startMonth: startMonth, startYear: startYear, endMonth: endMonth, endYear: endYear, swpType: swpType).enumerated(){
            if navData.fund_nav_value == 0 || navData.benchmark_nav_value == 0{
                continue
            }
            let swpCalculation = SipSwpCalculation()
            swpCalculation.day = Int(navData.day)
            swpCalculation.month = Int(navData.month)
            swpCalculation.year = Int(navData.year)
            swpCalculation.navValue = navData.fund_nav_value
            swpCalculation.indexNavValue = navData.benchmark_nav_value
            
            if index == 0{
                swpCalculation.cashflow = Double(-initialAmount)
                swpCalculation.indexCashflow = Double(-initialAmount)
                
                let units = (Double(initialAmount)/navData.fund_nav_value) + totalUnits
                totalUnits = units
                swpCalculation.units = units
                
                let indexUnits = (Double(initialAmount)/navData.benchmark_nav_value) + totalIndexUnits
                totalIndexUnits = indexUnits
                swpCalculation.indexUnits = indexUnits
                
            }else{
                
                var units = (Double(withDrawAmount)/navData.fund_nav_value)
                if units > totalUnits{
                    unitsRanOut = true
                    units = totalUnits
                    totalUnits = 0
                }else{
                    totalUnits = totalUnits - units
                }
                swpCalculation.units = totalUnits
                swpCalculation.cashflow = units * navData.fund_nav_value
                
                var indexUnits = (Double(withDrawAmount)/navData.benchmark_nav_value)
                if indexUnits > totalIndexUnits{
                    indexUnits = totalIndexUnits
                    totalIndexUnits = 0
                }else{
                    totalIndexUnits = totalIndexUnits - indexUnits
                }
                swpCalculation.indexUnits = totalIndexUnits
                swpCalculation.indexCashflow = indexUnits * navData.benchmark_nav_value
            }
            
            swpCalculation.fundValue = swpCalculation.navValue * swpCalculation.units
            swpCalculation.indexFundValue = swpCalculation.indexNavValue * swpCalculation.indexUnits
            
            calculationValues.append(swpCalculation)
            if unitsRanOut {
                break
            }
        }
        return calculationValues
    }
    
    func getNavValues(fundNavData: [MFNavData], startMonth: Int, startYear: Int, endMonth: Int, endYear: Int, swpType: SWPType) -> [MFNavData]{
        var consideredMonths = Set<Int>()
        var selectedNavs = [MFNavData]()
        for navData in fundNavData {
            let navAdjustedDate = adjustedDate(year: Int(navData.year), month: Int(navData.month))
            let startAdjustedDate = adjustedDate(year: startYear, month: startMonth)
            if navAdjustedDate < startAdjustedDate{
                continue
            }
            if !consideredMonths.contains(navAdjustedDate) {
                if navData.day != 1{
                    selectedNavs.append(navData)
                    consideredMonths.insert(navAdjustedDate)
                    if adjustedDate(year: Int(navData.year), month: Int(navData.month)) >= adjustedDate(year: endYear, month: endMonth){
                        break
                    }
                }
            }
        }
        switch swpType {
        case .monthly:
            return selectedNavs
            
        case .quarterly:
            var quarterlyNavs = [MFNavData]()
            for (index, navData) in selectedNavs.enumerated(){
                if index % 3 == 0{
                    quarterlyNavs.append(navData)
                }
            }
            return quarterlyNavs
        }
    }
    
    func calculateLastRow(fundNavData: [MFNavData], lastRowUnits: Double, indexLastRowUnits:Double, vaoDateComponents: (day: Int, month: Int, year: Int)) -> SipSwpCalculation?{
        guard let navData = navDataForDate(fundNavData: fundNavData, day: Int16(vaoDateComponents.day), month: Int16(vaoDateComponents.month), year: Int16(vaoDateComponents.year)) else{
            return nil
        }
        
        let sipCalculation = SipSwpCalculation()
        sipCalculation.day = vaoDateComponents.day
        sipCalculation.month = vaoDateComponents.month
        sipCalculation.year = vaoDateComponents.year
        sipCalculation.navValue = navData.fund_nav_value
        sipCalculation.units = lastRowUnits
        sipCalculation.fundValue = sipCalculation.navValue * sipCalculation.units
        sipCalculation.cashflow = sipCalculation.fundValue
        sipCalculation.indexNavValue = navData.benchmark_nav_value
        sipCalculation.indexUnits = indexLastRowUnits
        sipCalculation.indexFundValue = sipCalculation.indexNavValue * sipCalculation.indexUnits
        sipCalculation.indexCashflow = sipCalculation.indexFundValue
        return sipCalculation
    }
    
    func navDataForDate(fundNavData: [MFNavData], day: Int16, month: Int16, year: Int16) -> MFNavData?{
        let filteredNavs = fundNavData.filter { $0.day == day && $0.month == month && $0.year == year }
        if filteredNavs.count > 0{
            return filteredNavs.first
        }
        return nil
    }
    
    func isStartingCapitalValid(amountText: String?) -> Bool{
        guard let sipAmountText = amountText, let amount = Int(sipAmountText) else{
            return false
        }
        return (amount >= 5000 && amount <= 200000000) ? true : false
    }
    
    func isWithdrawAmountValid(withDrawAmountText: String?, startingCapitalText: String?) -> Bool{
        guard let withDrawAmount = withDrawAmountText, let wdAmount = Int(withDrawAmount), let startingCapital = startingCapitalText, let capital = Int(startingCapital) else{
            return false
        }
        return wdAmount <= capital
    }
    
}
