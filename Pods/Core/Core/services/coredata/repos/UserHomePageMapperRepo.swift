//
//  UserHomePageMapperRepo.swift
//  Core
//
//  Created by kunal singh on 07/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import CoreData

public class UserHomePageMapperRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "UserHomePageMapper"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func userHomePageMapperObjectFromDictionary(input: Dictionary<String, Any>,  userTypeId: Int16) -> UserHomePageMapper? {
        guard let userTypeIdObject = input["user_type_id"] as? Int16  else {
            return nil
        }
            if userTypeIdObject != userTypeId{
                return nil
            }
        
        let managedObject = UserHomePageMapper(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let inputId = input["id"] {
            managedObject.id =  inputId as? Int32 ?? 0
        }
        
        
        if let itemType = input["item_type"] {
            managedObject.item_type =  itemType as? Int16 ?? 0
        }
        if let itemId = input["item_id"] {
            managedObject.item_id =  itemId as? Int32 ?? 0
        }
        if let sequence = input["sequence"] {
            managedObject.sequence =  sequence as? Int16 ?? 0
        }
        managedObject.user_type_id = userTypeIdObject
        return managedObject
    }
    
    func createUserHomePage(inputArray: [Dictionary<String, Any>], userTypeId: Int16) -> Bool{
        for input:Dictionary in inputArray {
            let data = userHomePageMapperObjectFromDictionary(input: input, userTypeId: userTypeId)
            if let object = data {
                if !createEntry(object: object){
                    return false
                }
            }
        }
        return true
    }
    
    public func allUserHomePageOrderedBySequence(userTypeId: Int16) -> [UserHomePageMapper]{
        return readAllEntriesOrderedBy(key: "sequence", isAscending: true, entity: entityName, condition:  NSPredicate(format: "user_type_id == %d", userTypeId), context: managedContext) as? [UserHomePageMapper] ?? []
    }
    
    @discardableResult
    func deleteUserHomePage() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }


}


