//
//  MFAExtensions.swift
//  mfadvisor
//
//  Created by Apple on 05/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

///MFAExtensions contains extensions used in mfadvisor

import Foundation
import UIKit

///Extension to apply html attributed text to UILabel
extension UILabel {
    func htmlFromString(htmlText: String) {
        
        let modifiedString = "<span style=\"font-family:'\(font.fontName)'; font-size: \(font.pointSize)px;\">\(htmlText)</span>"
        
        do {
            let attrString = try NSMutableAttributedString(data: modifiedString.data(using: String.Encoding.unicode, allowLossyConversion: true)! , options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue, NSForegroundColorAttributeName:self.textColor], documentAttributes: nil)
            self.attributedText = attrString
        }
        catch let error as NSError {
            print(error.debugDescription)
        }
        
    }
}

///Extension to calculate height of lable to fit in given width
extension NSAttributedString {
    public func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont, options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: options, context: nil)
        return boundingBox.height
    }
}

extension Date
{
    init(dateString:String, format: String = "dd/MM/yyyy") {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = format
        let date = dateStringFormatter.date(from: dateString)
        self.init(timeInterval: 0, since: date ?? Date())
    }
}


extension String {
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont, options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: options, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }
    
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
}
