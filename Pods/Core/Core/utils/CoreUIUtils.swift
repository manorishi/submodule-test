//
//  CoreUIUtils.swift
//  Core
//
//  Created by kunal singh on 03/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import UIKit

/**
 Used to get UIColor from hex string.
 */
public func hexStringToUIColor (hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
    }
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    var rgbValue: UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
