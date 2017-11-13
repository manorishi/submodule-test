//
//  MFUrlConstants.swift
//  mfadvisor
//
//  Created by Anurag Dake on 09/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import Core

/**
 MFUrlConstants contains all urls used in Video module
 */
public struct MFUrlConstants {
    static let UPDATE_PRESENTATION_SHARE_COUNT_URL = URLConstants.BASE_URL + "/addPresentationsShared/";
    
//    static let sensexDataUrl = "http://www.moneycontrol.com/sensex/bse/sensex-live"
//    static let niftyDataUrl = "http://www.moneycontrol.com/nifty/nse/nifty-live"
    
    static let sensexDataUrl = "http://appfeeds.moneycontrol.com/jsonapi/market/indices&ind_id=4"
    static let niftyDataUrl = "http://appfeeds.moneycontrol.com/jsonapi/market/indices&ind_id=9"
    static let navDataUrl = URLConstants.BASE_URL + "/getLookupNavData";
}

