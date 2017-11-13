//
//  MFAUtils.swift
//  mfadvisor
//
//  Created by Apple on 08/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import UIKit

///get attributed string from html text
func htmlFromString(htmlText: String, fontColor:UIColor, font:UIFont) -> NSAttributedString? {
    
    let modifiedString = "<span style=\"font-family:'\(font.fontName)'; font-size: \(font.pointSize)px;\">\(htmlText)</span>"
    
    do {
        let attrString = try NSMutableAttributedString(data: modifiedString.data(using: String.Encoding.unicode, allowLossyConversion: true)! , options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue, NSForegroundColorAttributeName:fontColor], documentAttributes: nil)
        return attrString
    }
    catch let error as NSError {
        print(error.debugDescription)
    }
    return nil
}


func datefrom(day: Int, month: Int, year: Int) -> Date{
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    let calendar = Calendar.current
    return calendar.date(from: dateComponents) ?? Date()
}

func dateComponents(dateString: String) -> (day: Int, month: Int, year: Int){
    let components = dateString.components(separatedBy: "/")
    guard components.count >= 2 else{
        return(0, 0, 0)
    }
    if components.count == 2{
        return (1, Int(components.first ?? "0") ?? 0, Int(components.last ?? "0") ?? 0)
    }else{
        return (Int(components.first ?? "0") ?? 0, Int(components[1]) ?? 0, Int(components.last ?? "0") ?? 0)
    }
}

func addViewBorder(view: UIView, borderWidth:CGFloat, borderColor:UIColor){
    view.layer.borderWidth = borderWidth
    view.layer.borderColor = borderColor.cgColor
}

func getFormattedNumberText(number: Double) -> String{
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return numberFormatter.string(from: NSNumber(value:number)) ?? ""
}

func getFormattedIntegerText(number: Int) -> String{
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return numberFormatter.string(from: NSNumber(value:number)) ?? ""
}

func getTwoDecimalRoundedValue(number: Double?) -> Double{
    guard let value = number else {
        return 0
    }
    return value.roundToDecimal(2)
}
