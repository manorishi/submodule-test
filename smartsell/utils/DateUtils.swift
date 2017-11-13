//
//  InternetUtils.swift
//  licsuperagent
//
//  Created by kunal singh on 10/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

/**
 Used to convert date from one format to another.
 */

class DateUtils: NSObject {
    
    static func convertDateToFormat(dateToConvert: String, fromFormat: String, toFormat: String) -> String {
        if dateToConvert.isEmpty || fromFormat.isEmpty || toFormat.isEmpty {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        let myDate = dateFormatter.date(from: dateToConvert)!
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: myDate)
    }
}
