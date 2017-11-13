//
//  HomeScreenGrid.swift
//  smartsell
//
//  Created by kunal singh on 12/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

enum HomeScreenGrid: String, CustomStringConvertible{
    case Fund_Selector = "Fund Selector"
    case Sales_Pitch = "Sales Pitch and FAQs"
    case Fund_Comparison = "Fund Comparison"
    case Fund_Presentation = "Fund Presentation"
    case Detailed_performance = "Detailed Performance"
    case Sales_Content = "Sales Content"
    case Your_Favorite = "Your Favorites"
    case SWP_Calculator = "SWP Calculator"
    case SIP_Calculator = "SIP Calculator"
    
    var description: String {
        return self.rawValue
    }
    
}
