//
//  Calculator.swift
//  mfadvisor
//
//  Created by Sunil Sharma on 04/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

class Calculator {
    
    func getWithdrawTotal(calculations:[SipSwpCalculation], status:Bool) -> Double {
        var withdrawTotal: Double = 0
        for (index, calculation) in calculations.enumerated(){
            if index == 0 || index == (calculations.count - 1){
                continue
            }
            withdrawTotal = withdrawTotal + (status ? calculation.indexCashflow : calculation.cashflow)
        }
        return withdrawTotal
    }
    
    func getInvestmentTotal(calculations:[SipSwpCalculation], status:Bool) -> Double {
        var investmentTotal: Double = 0
        for calculation in calculations{
            investmentTotal = investmentTotal + calculation.cashflow
        }
        investmentTotal = investmentTotal - calculations.last!.cashflow
        return investmentTotal
    }

    func getAnnualIrrSwp(calculations:[SipSwpCalculation], swpOutput:SWPOutput, forIndexCashflow:Bool) -> Double {
        var total:Double = 0.0
        if forIndexCashflow {
            total = getWithdrawTotal(calculations: calculations, status: true) + swpOutput.indexVaoFundValue
        } else {
            total = Double(swpOutput.withdrawTotal) + swpOutput.vaoFundValue
        }
        
        if abs(total) >= Double(abs(swpOutput.startCapital)) {
            return calculateIrrRecursively(start: 0.0, end: 100.0, precision: 1.0, calculations: calculations, finalCalc: getFinalCalculationObjectsForIrr(calculations: calculations, forIndexCashflow: forIndexCashflow), useAbsoluteValue: true, forIndexCashflow: forIndexCashflow)
        } else {
            return calculateNegativeIrrRecursively(start: 0.0, end: -99.0, precision: 1.0, calculations: calculations, finalCalc: getFinalCalculationObjectsForIrr(calculations: calculations, forIndexCashflow: forIndexCashflow), useAbsoluteValue: true, forIndexCashflow: forIndexCashflow)
        }
    }
    
    func getFinalCalculationObjectsForIrr(calculations:[SipSwpCalculation], forIndexCashflow:Bool) -> SipSwpCalculation? {
        for (index, _) in (0...(calculations.count - 1)).enumerated().reversed() {
//            print("index:\(index)")
            let condition:Bool = forIndexCashflow ? calculations[index].indexCashflow != 0 : calculations[index].cashflow != 0
            if condition {
                return calculations[index]
            }
        }
        return nil
    }
    
    func getAnnualIrrSip(calcutions:[SipSwpCalculation], sipOutput:SIPOutput, forIndexCashflow:Bool) -> Double {
        var total:Double = 0.0
        if forIndexCashflow {
            total = getInvestmentTotal(calculations: calcutions, status: true)
        } else {
            total = Double(sipOutput.investTotal)
        }
        
        if forIndexCashflow && abs(sipOutput.indexVaoFundValue) >= abs(total) {
            return calculateIrrRecursively(start: 0.0, end: 100.0, precision: 1.0, calculations: calcutions, finalCalc: getFinalCalculationObjectsForIrr(calculations: calcutions, forIndexCashflow: forIndexCashflow), useAbsoluteValue: true, forIndexCashflow: forIndexCashflow)
        } else if !forIndexCashflow && abs(sipOutput.vaoFundValue) >= abs(total) {
            return calculateIrrRecursively(start: 0.0, end: 100.0, precision: 1.0, calculations: calcutions, finalCalc: getFinalCalculationObjectsForIrr(calculations: calcutions, forIndexCashflow: forIndexCashflow), useAbsoluteValue: true, forIndexCashflow: forIndexCashflow)
        }else {
            return calculateNegativeIrrRecursively(start: 0.0, end: -99.0, precision: 1.0, calculations: calcutions, finalCalc: getFinalCalculationObjectsForIrr(calculations: calcutions, forIndexCashflow: forIndexCashflow), useAbsoluteValue: true, forIndexCashflow: forIndexCashflow)
        }
    }
    
    /**
     * Pick the rate that gives difference closer to 0
     * @param precision
     * @param test_rate
     * @param previous_diff
     * @param difference
     * @return
     */
    func returnCorrectTestRate(precision:Double, testRate:Double, previousDiff:Double, difference:Double) -> Double {
        if abs(difference) < abs(previousDiff){
            return testRate
        } else{
            return testRate - precision
        }
    }
    
    /**
     * Finds number of days in between 2 calendar objects
     * @param start_day
     * @param start_month
     * @param start_year
     * @param end_day
     * @param end_month
     * @param end_year
     * @return
     */
    func getDaysInbetween(startDay:Int, startMonth:Int, startYear:Int, endDay:Int, endMonth:Int, endYear:Int) -> Int {
        let currentCalendar = Calendar.current
        
        var startDateComponents = DateComponents()
        startDateComponents.year = startYear
        startDateComponents.month = startMonth - 1
        startDateComponents.day = startDay
        let startDate = currentCalendar.date(from: startDateComponents) ?? Date()
        
        var endDateComponents = DateComponents()
        endDateComponents.year = endYear
        endDateComponents.month = endMonth - 1
        endDateComponents.day = endDay
        let endDate = currentCalendar.date(from: endDateComponents) ?? Date()
        
        return (currentCalendar as NSCalendar).components(.day, from: startDate, to: endDate, options: []).day ?? 0
    }
    
    /**
     * Single adjusted value to compare dates
     * @param month
     * @param year
     * @return
     */
    func getAdjustedDate(month:Int, year:Int) -> Int {
        return year * 100 + month
    }
    
    func calculateIrrRecursively(start:Double, end:Double, precision:Double, calculations:[SipSwpCalculation], finalCalc:SipSwpCalculation?, useAbsoluteValue:Bool, forIndexCashflow:Bool) -> Double {
        var testRate:Double = start
        var sum:Double = 0
        var previousDiff:Double?
        var eligibleForRestart = false
        
        if (finalCalc == nil){
            return 0
        }
        
        while testRate.roundToDecimal(2) <= end.roundToDecimal(2) {
            sum = 0
            for index in 0..<calculations.count - 1 {
                let calculation = calculations[index]
                if calculation === finalCalc! {
                    break
                }
                let daysInBetween = getDaysInbetween(startDay: calculation.day, startMonth: calculation.month, startYear: calculation.year, endDay: (finalCalc?.day)!, endMonth: (finalCalc?.month)!, endYear: (finalCalc?.year)!)
                let cashflow:Double = forIndexCashflow ? calculation.indexCashflow : calculation.cashflow
                let calcValue:Double = (testRate / 100) + 1
                sum = sum + (cashflow * (pow(calcValue, Double(daysInBetween) / 365.0)))
            }
            
            let finalCashflow:Double = (forIndexCashflow ? finalCalc?.indexCashflow : finalCalc?.cashflow)!
            var difference:Double = 0
//            print("final cashflow: \(finalCashflow)")
            if (useAbsoluteValue){
                difference = abs(finalCashflow) - abs(sum)
            } else {
                difference = finalCashflow - sum
            }
            
            if previousDiff == nil{
                previousDiff = difference
                if difference < 0 {
                    eligibleForRestart = true
                }
            }
            
//            print("IRR \(testRate) \(sum) : \(difference) : \(previousDiff ?? 0)")
            if difference < 0.5 && difference > -0.5 && testRate != 0 {
                return returnCorrectTestRate(precision: precision, testRate: testRate, previousDiff: previousDiff!, difference: difference)
            }
            else if (previousDiff! < 0 && difference > 0) || (previousDiff! > 0 && difference < 0){
                if (precision / 10)  < 0.001 {
                    return returnCorrectTestRate(precision: precision, testRate: testRate, previousDiff: previousDiff!, difference: difference)
                } else {
                    return calculateIrrRecursively(start: testRate - precision,end: testRate ,precision: precision / 10.0, calculations: calculations, finalCalc:finalCalc, useAbsoluteValue:useAbsoluteValue, forIndexCashflow:forIndexCashflow)
                }
            }
            else if (eligibleForRestart && useAbsoluteValue && abs(previousDiff!) < abs(difference)) {
//                print("IRR \(testRate) Restart")
                return calculateIrrRecursively(start: start, end: end ,precision: precision, calculations: calculations, finalCalc:finalCalc, useAbsoluteValue:!useAbsoluteValue, forIndexCashflow:forIndexCashflow)
            } else {
                previousDiff = difference
                testRate = testRate + precision
            }
        }
        return 0
    }
    
    
    func calculateNegativeIrrRecursively(start:Double, end:Double, precision:Double, calculations:[SipSwpCalculation], finalCalc:SipSwpCalculation?, useAbsoluteValue:Bool, forIndexCashflow:Bool) -> Double {
        var testRate:Double = start
        var sum:Double = 0
        var previousDiff:Double?
        var eligibleForRestart = false
        
        if (finalCalc == nil){
            return 0
        }
        
        while testRate.roundToDecimal(2) >= end.roundToDecimal(2) {
            sum = 0
            for index in 0..<calculations.count - 1 {
                let calculation = calculations[index]
                if calculation === finalCalc! {
                    break
                }
                let daysInBetween = getDaysInbetween(startDay: calculation.day, startMonth: calculation.month, startYear: calculation.year, endDay: (finalCalc?.day)!, endMonth: (finalCalc?.month)!, endYear: (finalCalc?.year)!)
                let cashflow:Double = forIndexCashflow ? calculation.indexCashflow : calculation.cashflow
                let calcValue:Double = (testRate / 100) + 1
                sum = sum + (cashflow * (pow(calcValue, Double(daysInBetween) / 365.0)))
            }
            
            let finalCashflow:Double = (forIndexCashflow ? finalCalc?.indexCashflow : finalCalc?.cashflow)!
            var difference:Double = 0
            if (useAbsoluteValue){
                difference = abs(finalCashflow) - abs(sum)
            } else {
                difference = finalCashflow - sum
            }
            
            if previousDiff == nil{
                previousDiff = difference
                if difference < 0 {
                    eligibleForRestart = true
                }
            }
            
//            print("IRR \(testRate) \(sum) : \(difference) : \(String(describing: previousDiff))")
            if difference < 0.5 && difference > -0.5 && testRate != 0 {
                return returnCorrectTestRate(precision: precision, testRate: testRate, previousDiff: previousDiff!, difference: difference)
            }
            else if (previousDiff! < 0 && difference > 0) || (previousDiff! > 0 && difference < 0){
                if (precision / 10)  < 0.001 {
                    return returnCorrectTestRate(precision: precision, testRate: testRate, previousDiff: previousDiff!, difference: difference)
                } else {
                    return calculateNegativeIrrRecursively(start: testRate + precision,end: testRate, precision: precision / 10.0, calculations: calculations, finalCalc:finalCalc, useAbsoluteValue:useAbsoluteValue, forIndexCashflow:forIndexCashflow)
                }
            }
            else if (eligibleForRestart && useAbsoluteValue && abs(previousDiff!) < abs(difference)) {
//                print("IRR \(testRate) Restart")
                return calculateNegativeIrrRecursively(start: start, end: end ,precision: precision, calculations: calculations, finalCalc:finalCalc, useAbsoluteValue:!useAbsoluteValue, forIndexCashflow:forIndexCashflow)
            } else {
                previousDiff = difference
                testRate = testRate - precision
            }
        }
        return 0
    }
}
