//
//  BannerType.swift
//  smartsell
//
//  Created by Anurag Dake on 14/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Foundation

enum BannerType: String, CustomStringConvertible{
    case all_items = "all_items"
    case favorites = "favorites"
    case leaderboard = "leaderboard"
    case notifications = "notifications"
    case edit_account = "edit_account"
    case directory = "directory"
    case poster = "poster"
    case video = "video"
    case pdf = "pdf"
    case quiz = "quiz"
    case live_data = "live_data"
    case news = "news"
    case sip_calculator = "sip_calculator"
    case fund_selector = "fund_selector"
    case fund_comparision = "fund_comparision"
    case sales_pitch = "sales_pitch"
    case fund_presentation = "fund_presentation"
    case detailed_performance = "detailed_performance"
    case none = ""
    
    var description: String {
        return self.rawValue
    }
}
