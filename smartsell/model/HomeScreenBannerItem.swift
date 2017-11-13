//
//  HomeScreenBannerItem.swift
//  smartsell
//
//  Created by kunal singh on 11/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import CoreData
import Core

class HomeScreenBannerItem: BaseHomeScreenItem, ListItemTypeProtocol, UIModelParserProtocol {
    
    
    func homeScreenItemType() -> HomeScreenItemType {
        return HomeScreenItemType.banner
    }
    
    func uiModelByParsingData(response: NSManagedObject) -> AnyObject {
        let homeScreenBannerlItem = HomeScreenBannerItem()
        if let bannerItem = response as? UserHomeBannerMapper {
            homeScreenBannerlItem.actionTarget = bannerItem.action_target ?? ""
            homeScreenBannerlItem.actionText = bannerItem.action_text ?? ""
            homeScreenBannerlItem.imageUrl = bannerItem.image_url ?? ""
            homeScreenBannerlItem.title = bannerItem.title ?? ""
            homeScreenBannerlItem.description = bannerItem.banner_description ?? ""
            homeScreenBannerlItem.itemId = bannerItem.item_id
            homeScreenBannerlItem.extraData = bannerItem.extra_data ?? ""
        }
        return homeScreenBannerlItem
    }
    
}
