//
//  CarousalType.swift
//  smartsell
//
//  Created by kunal singh on 13/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

enum CarouselType: String, CustomStringConvertible{
    case stock = "stock"
    case news = "news"
    case leaderboard = "leaderboard"
    case generic = "generic"
    
    var description: String {
        return self.rawValue
    }
    
}

