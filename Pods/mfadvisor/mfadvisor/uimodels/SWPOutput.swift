//
//  SWPOutput.swift
//  mfadvisor
//
//  Created by Sunil Sharma on 04/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

class SWPOutput {

    var fundName:String!
    var investmentPeriod:String!
    var startCapital:Int!
    var withdrawAmount:Int!
    var withdrawTotal:Int!
    var vaoFundValue:Double!
    var indexVaoFundValue:Double!
    var annualIRR:Double!
    var indexAnnualIRR:Double!
    var calculations:[SipSwpCalculation] = []
    
}
