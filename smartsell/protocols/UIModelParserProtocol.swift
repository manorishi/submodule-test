//
//  UIModelParserProtocol.swift
//  smartsell
//
//  Created by kunal singh on 11/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import CoreData

protocol UIModelParserProtocol {
    func uiModelByParsingData(response: NSManagedObject) -> AnyObject
}

