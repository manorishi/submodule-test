//
//  MFAEnumUtils.swift
//  mfadvisor
//
//  Created by Apple on 05/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 MFAEnumUtils contanis enums used in mfadvisor
 */

import Foundation

///Enum to decide fund option
public enum FundOptionsType: Int {
    case salesPitch = 1
    case presentation = 2
    case performance = 3
    case fundComparison = 4
    case swpCalculator = 5
    case sipCalculator = 6
}

///Enum to decide category of fund
public enum FundType:String {
    case equity
    case debt
    case balanced
}

//Enum to decide whether swp is monthly or quarterly
public enum SWPType{
    case monthly
    case quarterly
}

//Enum to decide whether picker is to select start or end date
public enum PickerDateType{
    case start
    case end
}
