//
//  FavouriteRepo.swift
//  Core
//
//  Created by Apple on 12/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 FavouriteRepo perform CRUD operation on Favourite entity.
 */

import Foundation
import CoreData

public class FavouriteRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "Favourite"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func favouriteObjectFromDictionary(favourite:Dictionary<String,Any>) -> Favourite {
        let favouriteManagedObject = Favourite(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        
        if let content_id = favourite["content_id"]{
            favouriteManagedObject.content_id = content_id as? Int32 ?? 0
        }
        if let content_type_id = favourite["content_type_id"]{
            favouriteManagedObject.content_type_id = content_type_id as? Int16 ?? 0
        }
        favouriteManagedObject.is_synced = true
        favouriteManagedObject.is_favourite = true
        return favouriteManagedObject
    }
    
    @discardableResult
    public func createFavourites(favouritesArray:[Dictionary<String,Any>]) -> Bool{
        for favourite:Dictionary in favouritesArray {
            if !createEntry(object: favouriteObjectFromDictionary(favourite: favourite)){
                return false
            }
        }
        return true
    }
    
    @discardableResult
    private func createFavourite(contentId:Int32, contentTypeId:Int16, syncStatus:Bool, isFavourite:Bool) -> Bool {
        let favouriteObj = Favourite(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        favouriteObj.content_id = contentId
        favouriteObj.content_type_id = contentTypeId
        favouriteObj.is_synced = syncStatus
        favouriteObj.is_favourite = isFavourite
        if createEntry(object: favouriteObj){
            return true
        }
        return false
    }
    
    @discardableResult
    public func updateFavouriteSyncStatus(contentId:Int32, contentTypeId:Int16,syncStatus:Bool,isFavourite:Bool) ->  Bool{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "content_id == %d AND content_type_id == %d", contentId,contentTypeId)
        do {
            let fetchedElements = try managedContext?.fetch(fetchRequest) as? [NSManagedObject] ?? []
            if fetchedElements.count > 0 {
                for content in fetchedElements {
                    content.setValue(syncStatus, forKey: "is_synced")
                    content.setValue(isFavourite, forKey: "is_favourite")
                }
                try managedContext?.save()
            }
            else{
                return createFavourite(contentId: contentId, contentTypeId: contentTypeId, syncStatus: syncStatus, isFavourite: isFavourite)
            }
        }
        catch {
            logToConsole(printObject: error as NSError)
            return false
        }
        return true
    }

    public func favouritesWith(syncStatus:Bool,isFavourite:Bool) -> [Favourite] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "is_synced == %@ AND is_favourite == %@", NSNumber(value: syncStatus),NSNumber(value: isFavourite))
        do {
            let fetchedElements = try managedContext?.fetch(fetchRequest) as? [NSManagedObject] ?? []
            return fetchedElements as? [Favourite] ?? []
        }
        catch {
            logToConsole(printObject: error as NSError)
            return []
        }
    }
    
    @discardableResult
    public func deleteFavourite(contentId:Int32, contentTypeId:Int16) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "content_id == %d AND content_type_id == %d", contentId,contentTypeId)
        do {
            let fetchedElements = try managedContext?.fetch(fetchRequest) as? [NSManagedObject] ?? []
            if fetchedElements.count > 0{
                for content in fetchedElements {
                    managedContext?.delete(content)
                }
                try managedContext?.save()
            }
        }
        catch {
            logToConsole(printObject: error as NSError)
            return false
        }
        return true
    }
    
    @discardableResult
    public func deleteAllFavourite() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func allFavourite() -> [Favourite] {
        return readEntries(condition: NSPredicate(format: "is_favourite == %@", NSNumber(value: true)), entity: entityName, context: managedContext) as? [Favourite] ?? []
    }
    
    public func favouriteWithContentTypeId(_ contentTypeId:Int16) -> [Favourite] {
        return readEntries(condition: NSPredicate(format: "is_favourite == %@ AND content_type_id == %d", NSNumber(value: true), contentTypeId), entity: entityName, context: managedContext) as? [Favourite] ?? []
    }
    
}
