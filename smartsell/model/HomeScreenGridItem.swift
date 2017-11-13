//
//  HomeScreenGridItem.swift
//  smartsell
//
//  Created by kunal singh on 11/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import CoreData

class HomeScreenGridItem: ListItemTypeProtocol, UIModelParserProtocol {
    var title: String = ""
    var backImage: String = ""
    
    func homeScreenItemType() -> HomeScreenItemType {
        return HomeScreenItemType.grid
    }
    
    func uiModelByParsingData(response: NSManagedObject) -> AnyObject {
        return self
    }
    
    func uiModelByParsingData(backImage: String, title: String) -> AnyObject {
        let homeGridItem = HomeScreenGridItem()
        homeGridItem.title = title
        homeGridItem.backImage = backImage
        return homeGridItem
    }
    
}
