//
//  SIPCalPresenter.swift
//  mfadvisor
//
//  Created by Anurag Dake on 04/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

class SIPCalPresenter: CalculatorBasePresenter{
    
    func pickerViewData(fundNavData: [MFNavData]?, dates: (startNav: MFNavData?, endNav: MFNavData?)?) -> (months: [Int], years: [Int]){
        var months = [Int]()
        var startYear = 0, endYear = 0
        if let startDate = dates?.startNav{
            months = Array(Int(startDate.month)...12)
            startYear = Int(startDate.year)
        }
        if let endDate = dates?.endNav{
            endYear = Int(endDate.year)
        }
        return (months, Array(startYear...endYear))
    }
    
    func sipOutputData(fundName: String?, sipAmount: Int?, startDate: String?, endDate: String?, vaoDate: String?, fundNavData: [MFNavData], completionHandler:@escaping (_ sipOutput:SIPOutput) -> ()){
        guard startDate != nil && endDate != nil && vaoDate != nil else{
            completionHandler(SIPOutput())
            return
        }
        
        let startDateComponents = dateComponents(dateString: startDate!)
        let endDateComponents = dateComponents(dateString: endDate!)
        let vaoDateComponents = dateComponents(dateString: vaoDate!)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            let sipOutput = SIPOutput()
            sipOutput.fundName = fundName ?? ""
            sipOutput.investmentPeriod = self?.investmentPeriodText(startMonth: startDateComponents.month, startYear: startDateComponents.year, endMonth: endDateComponents.month, endYear: endDateComponents.year)
            sipOutput.investAmount = sipAmount ?? 0
            sipOutput.investTotal = self?.totalInvestment(sipAmount: sipAmount ?? 0, startMonth: startDateComponents.month, startYear: startDateComponents.year, endMonth: endDateComponents.month, endYear: endDateComponents.year)
           
            var sipCalculations = self?.sipCalculations(fundNavData: fundNavData, sipAmount: sipAmount ?? 0, startMonth: startDateComponents.month, startYear: startDateComponents.year, endMonth: endDateComponents.month, endYear: endDateComponents.year) ?? []
            
            if let lastRow = self?.calculateLastRow(fundNavData: fundNavData, lastRowUnits: sipCalculations.last?.units ?? 0, indexLastRowUnits: sipCalculations.last?.indexUnits ?? 0, vaoDateComponents: vaoDateComponents){
                sipCalculations.append(lastRow)
                sipOutput.vaoFundValue = lastRow.fundValue
                sipOutput.indexVaoFundValue = lastRow.indexFundValue
            }
            sipOutput.calculations = sipCalculations

            let calculatorUtil = Calculator()
            sipOutput.annualIRR = calculatorUtil.getAnnualIrrSip(calcutions: sipCalculations, sipOutput: sipOutput, forIndexCashflow: false)
            sipOutput.indexAnnualIRR = calculatorUtil.getAnnualIrrSip(calcutions: sipCalculations, sipOutput: sipOutput, forIndexCashflow: true)
            
            DispatchQueue.main.async {
                completionHandler(sipOutput)
            }
        }
    }
    
    func sipCalculations(fundNavData: [MFNavData], sipAmount: Int, startMonth: Int, startYear: Int, endMonth: Int, endYear: Int) -> [SipSwpCalculation]{
        var calculationValues = [SipSwpCalculation]()
        
        var totalUnits: Double = 0
        var totalIndexUnits: Double = 0
        for navData in getMonthlyNavValues(fundNavData: fundNavData, startMonth: startMonth, startYear: startYear, endMonth: endMonth, endYear: endYear){
            if navData.fund_nav_value == 0 || navData.benchmark_nav_value == 0{
                continue
            }
            let sipCalculation = SipSwpCalculation()
            sipCalculation.day = Int(navData.day)
            sipCalculation.month = Int(navData.month)
            sipCalculation.year = Int(navData.year)
            sipCalculation.navValue = navData.fund_nav_value
            
            let units = (Double(sipAmount)/navData.fund_nav_value) + totalUnits
            totalUnits = units
            sipCalculation.units = units
            sipCalculation.cashflow = Double(-sipAmount)
            sipCalculation.fundValue = sipCalculation.navValue * sipCalculation.units
            
            //benchmark
            sipCalculation.indexNavValue = navData.benchmark_nav_value
            let indexUnits = (Double(sipAmount)/navData.benchmark_nav_value) + totalIndexUnits
            totalIndexUnits = indexUnits
            sipCalculation.indexUnits = indexUnits
            sipCalculation.indexCashflow = Double(-sipAmount)
            sipCalculation.indexFundValue = sipCalculation.indexNavValue * sipCalculation.indexUnits
            calculationValues.append(sipCalculation)
        }
        return calculationValues
    }
    
    ///Get first available nav value for that month
    func getMonthlyNavValues(fundNavData: [MFNavData], startMonth: Int, startYear: Int, endMonth: Int, endYear: Int) -> [MFNavData]{
        print("count:\(fundNavData.count)")
        var consideredMonths = Set<Int>()
        var monthlyNavs = [MFNavData]()
        for navData in fundNavData {
            let navAdjustedDate = adjustedDate(year: Int(navData.year), month: Int(navData.month))
            let startAdjustedDate = adjustedDate(year: startYear, month: startMonth)
            if navAdjustedDate < startAdjustedDate{
                continue
            }
            if !consideredMonths.contains(navAdjustedDate) {
                monthlyNavs.append(navData)
                consideredMonths.insert(navAdjustedDate)
                if adjustedDate(year: Int(navData.year), month: Int(navData.month)) >= adjustedDate(year: endYear, month: endMonth){
                    break
                }
        
            }
        }
        print(monthlyNavs.count)
        return monthlyNavs
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
    
    func totalInvestment(sipAmount: Int, startMonth: Int, startYear: Int, endMonth: Int, endYear: Int) -> Int{
        let yearDiff = endYear - startYear
        let monthDiff = endMonth - startMonth + 1
        return (sipAmount * ((yearDiff * 12) + monthDiff))
    }
    
    func isSipAmountValid(amountText: String?) -> Bool{
        guard let sipAmountText = amountText, let amount = Int(sipAmountText) else{
            return false
        }
        return (amount >= 1000 && amount <= 200000000) ? true : false
    }
}
