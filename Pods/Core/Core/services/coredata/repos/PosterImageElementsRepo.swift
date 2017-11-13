//
//  PosterImageElementsRepo.swift
//  Core
//
//  Created by Anurag Dake on 24/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 PosterImageElementsRepo perform CRUD operation on PosterImageElement entity.
 */

import Foundation
import CoreData

public class PosterImageElementsRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "PosterImageElement"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func posterImageElementObjectFromDictionary(posterImageElement: Dictionary<String, Any>) -> PosterImageElement{
        let posterImageElementManagedObject = PosterImageElement(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let posterImageElementId = posterImageElement["id"] {
            posterImageElementManagedObject.id =  posterImageElementId as? Int32 ?? 0
        }
        if let posterId = posterImageElement["posterId"] {
            posterImageElementManagedObject.poster_id =  posterId as? Int32 ?? 0
        }
        if let onByDefault = posterImageElement["onByDefault"] {
            let defaultValue = onByDefault as? Int ?? 1
            posterImageElementManagedObject.on_by_default =  defaultValue == 0 ? false : true
        }
        if let topMargin = posterImageElement["topMargin"] {
            posterImageElementManagedObject.top_margin =  topMargin as? Int16 ?? 0
        }
        if let leftMargin = posterImageElement["leftMargin"] {
            posterImageElementManagedObject.left_margin =  leftMargin as? Int16 ?? 0
        }
        if let width = posterImageElement["width"] {
            posterImageElementManagedObject.width =  width as? Int16 ?? 0
        }
        if let height = posterImageElement["height"] {
            posterImageElementManagedObject.height =  height as? Int16 ?? 0
        }
        if let shape = posterImageElement["shape"] {
            posterImageElementManagedObject.shape =  shape as? String ?? ""
        }
        if let keepAspectRatio = posterImageElement["keepAspectRatio"] {
            let aspectRatio = keepAspectRatio as? Int ?? 1
            posterImageElementManagedObject.keep_aspect_ratio =  aspectRatio == 0 ? false : true
        }
        return posterImageElementManagedObject
    }
    
    
    func createPosterImageElements(posterTextElementArray: [Dictionary<String, Any>]) -> Bool{
        for posterTextElement:Dictionary in posterTextElementArray {
            if !createEntry(object: posterImageElementObjectFromDictionary(posterImageElement: posterTextElement)){
                return false
            }
        }
        return true
    }
    
    @discardableResult
    func deletePosterImageElements() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func posterImageElementHavingId(posterImageElementId: Int32) -> PosterImageElement?{
        return readEntry(condition: NSPredicate(format: "id == %d", posterImageElementId), entity: entityName, context: managedContext) as? PosterImageElement ?? nil
    }
    
    public func posterImageElementsHavingPosterId(posterId: Int32) -> [PosterImageElement]{
        return readEntries(condition: NSPredicate(format: "poster_id == %d", posterId), entity: entityName, context: managedContext) as? [PosterImageElement] ?? []
    }

}
