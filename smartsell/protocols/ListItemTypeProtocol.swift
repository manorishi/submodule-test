//
//  ListItemTypeProtocol.swift
//  smartsell
//
//  Created by kunal singh on 11/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Foundation

@objc
protocol ListItemTypeProtocol{
    @objc optional func homeScreenItemType() -> HomeScreenItemType
    
}
