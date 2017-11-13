//
//  FundSelectionItem.swift
//  mfadvisor
//
//  Created by Anurag Dake on 03/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 MFSelectionItem is UI model which include all the information related to displaying fund pages
 */
class MFSelectionItem{
    
    var page1TopImage: String?
    var page1Heroline: String?
    var fundItems = [SelectionFundItem]()
    var tenureHeading: String?
    var tenureInfo: String?
    var tenureIcon: String?
    var liquidityHeading: String?
    var liquidityInfo: String?
    var liquidityIcon: String?
    var presentationPage3Disclaimer: String?
}
