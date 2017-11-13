//
//  NumberExtensions.swift
//  mfadvisor
//
//  Created by Anurag Dake on 12/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
