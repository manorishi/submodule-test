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
        if let bundle = BundleManager().loadResourceBundle(){
            return String(format: NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: ""), arguments: [])
        }else {
            return String(format: NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: ""), arguments: [])
        }
    }
    
    func localizedStringWithVariables(vars: CVarArg...) -> String {
        if let bundle = BundleManager().loadResourceBundle(){
            return String(format: NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: ""), arguments: vars)
        }else {
            return String(format: NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: ""), arguments: vars)
        }
    }
}
