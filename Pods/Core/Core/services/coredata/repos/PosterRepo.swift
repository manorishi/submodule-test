//
//  PosterRepo.swift
//  Core
//
//  Created by kunal singh on 17/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 PosterRepo perform CRUD operation on Poster entity.
 */

import Foundation
import CoreData

public class PosterRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "Poster"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func posterObjectFromDictionary(poster: Dictionary<String, Any>) -> Poster{
        let posterManagedObject = Poster(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let posterId = poster["id"] {
            posterManagedObject.id =  posterId as? Int32 ?? 0
        }
        if let name = poster["name"] {
            posterManagedObject.name =  name as? String ?? ""
        }
        if let imageVersion = poster["imageVersion"] {
            posterManagedObject.image_version =  imageVersion as? Int32 ?? 0
        }
        if let shareText = poster["shareText"] {
            posterManagedObject.share_text =  shareText as? String ?? ""
        }
        if let thumbnailUrl = poster["thumbnailUrl"] {
            posterManagedObject.thumbnail_url =  thumbnailUrl as? String ?? ""
        }
        if let posterDescription = poster["description"] {
            posterManagedObject.poster_description =  posterDescription as? String ?? ""
        }
        return posterManagedObject
    }

    func createPosters(posterArray: [Dictionary<String, Any>]) -> Bool{
        for poster:Dictionary in posterArray {
            if !createEntry(object: posterObjectFromDictionary(poster: poster)){
                return false
            }
        }
        return true
    }
    
    @discardableResult
    func deletePosters() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func posterHavingId(posterId: Int32) -> Poster?{
        return readEntry(condition: NSPredicate(format: "id == %d", posterId), entity: entityName, context: managedContext) as? Poster ?? nil
    }
    
    func allPosters() -> [Poster]{
        return readAllEntries(entity: entityName, context: managedContext) as? [Poster] ?? []
    }



}
