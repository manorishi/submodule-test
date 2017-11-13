//
//  PosterTextElementsRepo.swift
//  Core
//
//  Created by Anurag Dake on 24/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 PosterTextElementsRepo perform CRUD operation on PosterTextElement entity.
 */

import Foundation
import CoreData

public class PosterTextElementsRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "PosterTextElement"
    private let defaultFontColor: String = "#000000"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func posterTextElementObjectFromDictionary(posterTextElement: Dictionary<String, Any>) -> PosterTextElement{
        let posterTextElementManagedObject = PosterTextElement(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let posterTextElementId = posterTextElement["id"] {
            posterTextElementManagedObject.id =  posterTextElementId as? Int32 ?? 0
        }
        if let posterId = posterTextElement["posterId"] {
            posterTextElementManagedObject.poster_id =  posterId as? Int32 ?? 0
        }
        if let defaultText = posterTextElement["defaultValue"] {
            posterTextElementManagedObject.default_text =  defaultText as? String ?? ""
        }
        if let onByDefault = posterTextElement["onByDefault"] {
            let defaultValue = onByDefault as? Int ?? 1
            posterTextElementManagedObject.on_by_default =  defaultValue == 0 ? false : true
        }
        if let topMargin = posterTextElement["topMargin"] {
            posterTextElementManagedObject.top_margin =  topMargin as? Int16 ?? 0
        }
        if let leftMargin = posterTextElement["leftMargin"] {
            posterTextElementManagedObject.left_margin =  leftMargin as? Int16 ?? 0
        }
        if let rightMargin = posterTextElement["rightMargin"] {
            posterTextElementManagedObject.right_margin =  rightMargin as? Int16 ?? 0
        }
        if let textAlignment = posterTextElement["textAlignment"] {
            posterTextElementManagedObject.text_alignment =  textAlignment as? String ?? ""
        }
        if let fontFamily = posterTextElement["fontFamily"] {
            posterTextElementManagedObject.font_family =  fontFamily as? String ?? ""
        }
        if let fontSize = posterTextElement["fontSize"] {
            posterTextElementManagedObject.font_size =  fontSize as? Int16 ?? 0
        }
        if let fontColor = posterTextElement["fontColor"] {
            posterTextElementManagedObject.font_color =  fontColor as? String ?? defaultFontColor
        }
        return posterTextElementManagedObject
    }
    
    
    func createPosterTextElements(posterTextElementArray: [Dictionary<String, Any>]) -> Bool{
        for posterTextElement:Dictionary in posterTextElementArray {
            if !createEntry(object: posterTextElementObjectFromDictionary(posterTextElement: posterTextElement)){
                return false
            }
        }
        return true
    }
    
    @discardableResult
    func deletePosterTextElements() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func posterTextElementHavingId(posterTextElementId: Int32) -> PosterTextElement?{
        return readEntry(condition: NSPredicate(format: "id == %d", posterTextElementId), entity: entityName, context: managedContext) as? PosterTextElement ?? nil
    }
    
    public func posterTextElementsHavingPosterId(posterId: Int32) -> [PosterTextElement]{
        return readEntries(condition: NSPredicate(format: "poster_id == %d", posterId), entity: entityName, context: managedContext) as? [PosterTextElement] ?? []
    }

}
