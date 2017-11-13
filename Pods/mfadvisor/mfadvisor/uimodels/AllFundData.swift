//
//  AllFundData.swift
//  mfadvisor
//
//  Created by Apple on 03/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

/**
 FundData contains fund name with collapsed/expanded status
 */
public struct FundData {
    let fundId:String!
    var name: String!    /// Fund Name
    var items: [String]!  /// Fund option items
    var collapsed: Bool = true
    let fundInitial: String!
    var fundNav: Float?
    
    init(fundId:String, name: String, fundInitial: String, items: [String], collapsed: Bool = true) {
        self.fundId = fundId
        self.name = name
        self.items = items
        self.collapsed = collapsed
        self.fundInitial = fundInitial
    }
}

/**
 AllFundData item holds all funds basic data with categories
 */
class AllFundData: NSObject {

    let categoryId: String!
    let categoryName: String!
    var fundData:[FundData] = [FundData]()
    var isExpandable: Bool = true
    
    init(categoryId: String, categoryName: String, fundData:[FundData],isExpandable: Bool = true) {
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.fundData = fundData
        self.isExpandable = isExpandable
    }
    
}
