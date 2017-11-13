//
//  FundSelectionItem.swift
//  mfadvisor
//
//  Created by Anurag Dake on 03/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 SelectionFundItem is UI model which include all data related to fund after fund selection screen
 */
class SelectionFundItem: FundItem{
    
    var fundAllocation: Float?
    var fundTopImage1: String?
    var fundTopImage2: String?
    var specialityIcon1: String?
    var specialityIcon2: String?
    var specialityIcon3: String?
    var specialityLine1: String?
    var specialityLine2: String?
    var specialityLine3: String?
    var specialityDisclaimer: String?
    var tenureLine: String?
    var liquidityLine: String?
    var productLabel: String?
    var productLabelDisclaimer: String?
    var riskometerImage: String?
    
    var lumpsumMaximum: Double?
    var lumpsumMultiple: Float?
    var lumpsumMinimum: Float?
    var sipMaximum: Double?
    var sipMultiple: Float?
    var sipMinimum: Float?
    var lumpSum: Double?
    var sip: Float?
}
