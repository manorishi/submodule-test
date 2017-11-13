//
//  ValidationUtils.swift
//  licsuperagent
//
//  Created by Anurag Dake on 10/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

/**
 Used to validate mobile number and otp code.
 */

class ValidationUtils: NSObject {
    static let MOBILE_NUMBER_LENGTH = 10
    static let OTP_LENGTH = 4
    
    static func isValidMobileNumber(mobileNumber: String) -> Bool {
        if mobileNumber.characters.count == ValidationUtils.MOBILE_NUMBER_LENGTH {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: mobileNumber)
        return allowedCharacters.isSuperset(of: characterSet)
        }
        else {
            return false
        }
    }
    
    static func isValidOTP(otp: String) -> Bool {
        if otp.characters.count == ValidationUtils.OTP_LENGTH {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: otp)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        else {
            return false
        }
    }
    
    static func mobileTextfield(mobileNumber: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard mobileNumber != nil else { return true }
        let newLength = (mobileNumber?.characters.count ?? 0) + string.characters.count - range.length
        return newLength <= ValidationUtils.MOBILE_NUMBER_LENGTH
    }
    
    static func otpTextfield(otp: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard otp != nil else { return true }
        let newLength = (otp?.characters.count ?? 0) + string.characters.count - range.length
        return newLength <= ValidationUtils.OTP_LENGTH
    }
}
