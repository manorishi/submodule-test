//
//  UserHomeBannerMapperRepo.swift
//  Core
//
//  Created by kunal singh on 07/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import CoreData

public class UserHomeBannerMapperRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "UserHomeBannerMapper"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func userHomeBannerObjectFromDictionary(input: Dictionary<String, Any>, userTypeId: Int16) -> UserHomeBannerMapper? {
        guard let userTypeIdObject = input["user_type_id"] as? Int16  else {
            return nil
        }
        if userTypeIdObject != userTypeId{
            return nil
        }
        
        let managedObject = UserHomeBannerMapper(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        
        if let inputId = input["item_id"] {
            managedObject.item_id =  inputId as? Int32 ?? 0
        }
        if let actionTarget = input["action_target"] {
            managedObject.action_target =  actionTarget as? String ?? ""
        }
        if let actionText = input["action_text"] {
            managedObject.action_text =  actionText as? String ?? ""
        }
        if let bannerDescription = input["banner_description"] {
            managedObject.banner_description =  bannerDescription as? String ?? ""
        }
        if let caroselType = input["carosel_type"] {
            managedObject.carosel_type =  caroselType as? String ?? ""
        }
        if let extraData = input["extra_data"] {
            managedObject.extra_data =  extraData as? String ?? ""
        }
        if let imageUrl = input["image_url"] {
            managedObject.image_url =  imageUrl as? String ?? ""
        }
        if let itemType = input["item_type"] {
            managedObject.item_type =  itemType as? Int16 ?? 0
        }
        if let title = input["title"] {
            managedObject.title =  title as? String ?? ""
        }
        managedObject.user_type_id = userTypeIdObject
        return managedObject
    }
    
    func createUserHomeBanner(inputArray: [Dictionary<String, Any>], userTypeId: Int16) -> Bool{
        for input:Dictionary in inputArray {
            let data = userHomeBannerObjectFromDictionary(input: input, userTypeId: userTypeId)
            if let object = data {
                if !createEntry(object: object){
                    return false
                }
            }
        }
        return true
    }
    
    public func userHomeBanner(userTypeId: Int16, itemId: Int32) -> UserHomeBannerMapper?{
        return readEntry(condition: NSPredicate(format: "user_type_id == %d AND item_id == %d", userTypeId, itemId), entity: entityName, context: managedContext) as? UserHomeBannerMapper ?? nil
    }
    
    public func userHomeBanners(userTypeId: Int16, itemType: Int16) -> [UserHomeBannerMapper]{
        return readEntries(condition: NSPredicate(format: "user_type_id == %d AND item_type == %d", userTypeId, itemType), entity: entityName, context: managedContext) as? [UserHomeBannerMapper] ?? []
    }
    
    @discardableResult
    func deleteUserHomeBanner() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }

    
    
}
