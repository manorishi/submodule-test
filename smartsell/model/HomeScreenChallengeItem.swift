//
//  HomeScreenChallengeItem.swift
//  smartsell
//
//  Created by kunal singh on 11/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import CoreData
import Core

class HomeScreenChallengeItem: BaseHomeScreenItem, ListItemTypeProtocol, UIModelParserProtocol {
    
    func homeScreenItemType() -> HomeScreenItemType {
        return HomeScreenItemType.challenge
    }
    
    func uiModelByParsingData(response: NSManagedObject) -> AnyObject {
        let homeScreenChallengeItem = HomeScreenChallengeItem()
        if let bannerItem = response as? UserHomeBannerMapper {
            homeScreenChallengeItem.actionTarget = bannerItem.action_target ?? ""
            homeScreenChallengeItem.actionText = bannerItem.action_text ?? ""
            homeScreenChallengeItem.title = bannerItem.title ?? ""
            homeScreenChallengeItem.description = bannerItem.banner_description ?? ""
            homeScreenChallengeItem.itemId = bannerItem.item_id
        }
        return homeScreenChallengeItem
    }
    
}
