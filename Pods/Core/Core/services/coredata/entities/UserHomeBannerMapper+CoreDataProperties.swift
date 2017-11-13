//
//  UserHomeBannerMapper+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension UserHomeBannerMapper {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserHomeBannerMapper> {
        return NSFetchRequest<UserHomeBannerMapper>(entityName: "UserHomeBannerMapper")
    }

    @NSManaged public var action_target: String?
    @NSManaged public var action_text: String?
    @NSManaged public var banner_description: String?
    @NSManaged public var carosel_type: String?
    @NSManaged public var extra_data: String?
    @NSManaged public var image_url: String?
    @NSManaged public var item_id: Int32
    @NSManaged public var item_type: Int16
    @NSManaged public var title: String?
    @NSManaged public var user_type_id: Int16

}
