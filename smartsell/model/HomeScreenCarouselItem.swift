//
//  HomeScreenCarouselItem.swift
//  smartsell
//
//  Created by kunal singh on 11/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import CoreData
import Core

class HomeScreenCarouselItem:BaseHomeScreenItem, ListItemTypeProtocol, UIModelParserProtocol{
    var carouselType: String = ""
    
    func homeScreenItemType() -> HomeScreenItemType {
        return HomeScreenItemType.carousel
    }
    
    func uiModelByParsingData(response: NSManagedObject) -> AnyObject {
        let homeScreenCarouselItem = HomeScreenCarouselItem()
        if let bannerItem = response as? UserHomeBannerMapper {
            homeScreenCarouselItem.actionTarget = bannerItem.action_target ?? ""
            homeScreenCarouselItem.carouselType = bannerItem.carosel_type ?? ""
            homeScreenCarouselItem.actionText = bannerItem.action_text ?? ""
            homeScreenCarouselItem.imageUrl = bannerItem.image_url ?? ""
            homeScreenCarouselItem.title = bannerItem.title ?? ""
            homeScreenCarouselItem.description = bannerItem.banner_description ?? ""
            homeScreenCarouselItem.extraData = bannerItem.extra_data ?? ""
            homeScreenCarouselItem.itemId = bannerItem.item_id 
        }
        return homeScreenCarouselItem
    }
    
}
