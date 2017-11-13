//
//  StringExtension.swift
//  Core
//
//  Created by kunal singh on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 Extension for String class.
 */

import Foundation
import UIKit

extension String {
    /**
     Calculate height of string with constraint width.
     */
    public func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont, options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: options, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
}
