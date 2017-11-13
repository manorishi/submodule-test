//
//  StringExtensions.swift
//  smartsell
//
//  Created by Anurag Dake on 21/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

///StringExtensions contains extensions of String and AttributedString

import Foundation
import UIKit

/**
 Extension for string class.
 */

extension String {
    /**
     Used to get localized string.
     */
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localizedStringWithVariables(vars: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: ""), arguments: vars)
    }
}

///Extension to make attributed text bold/normal
extension NSMutableAttributedString {
    /**
     Used to create bold string.
     */
    func bold(_ text:String,font:UIFont) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : font]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    /**
     Used to get plain attributed string.
     */
    func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}
