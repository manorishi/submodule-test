//
//  MarketDataParser.swift
//  mfadvisor
//
//  Created by Anurag Dake on 11/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import Kanna

public class MarketDataParser{
    
    func parseMarketData(response: [String:AnyObject]?) -> (index: String?, daysChange: String?, open: String?, close: String?, date: String?){
        var index: String?, daysChange: String?, open: String?, close: String?, date: String?
        guard let jsonResponse = response, let indices = jsonResponse["indices"] else {
            return (index, daysChange, open, close, date)
        }
        index = indices["lastprice"] as? String
        daysChange = indices["change"] as? String
        open = indices["open"] as? String
        close = indices["prevclose"] as? String
        date = indices["lastupdated"] as? String
        return (index, daysChange, open, close, date)
    }
}
