//
//  PdfRepo.swift
//  Core
//
//  Created by kunal singh on 21/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 PdfRepo perform CRUD operation on Pdf entity.
 */

import Foundation
import CoreData

public class PdfRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "Pdf"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func pdfObjectFromDictionary(pdf: Dictionary<String, Any>) -> Pdf{
        let pdfManagedObject = Pdf(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let pdfId = pdf["id"] {
            pdfManagedObject.id =  pdfId as? Int32 ?? 0
        }
        if let name = pdf["name"] {
            pdfManagedObject.name =  name as? String ?? ""
        }
        if let description = pdf["description"]{
            pdfManagedObject.pdf_description = description as? String ?? ""
        }
        if let shareText = pdf["shareText"]{
            pdfManagedObject.share_text = shareText as? String ?? ""
        }
        if let thumbnailUrl = pdf["thumbnailUrl"]{
            pdfManagedObject.thumbnail_url = thumbnailUrl as? String ?? ""
        }
        if let imageVersion = pdf["imageVersion"]{
            pdfManagedObject.image_version = imageVersion as? Int32 ?? 0
        }
        if let pdfUrl = pdf["pdfUrl"]{
            pdfManagedObject.pdf_url = pdfUrl as? String ?? ""
        }
        if let pdfVersion = pdf["pdfVersion"]{
            pdfManagedObject.pdf_version = pdfVersion as? Int32 ?? 0
        }
        return pdfManagedObject
    }
    
    
    func createPdfs(pdfsArray: [Dictionary<String, Any>]) -> Bool{
        for pdf:Dictionary in pdfsArray {
            if !createEntry(object: pdfObjectFromDictionary(pdf: pdf)){
                return false
            }
        }
        return true
    }
    
    func deletePdfs() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func pdfHavingId(pdfId: Int32) -> Pdf?{
        return readEntry(condition: NSPredicate(format: "id == %d", pdfId), entity: entityName, context: managedContext) as? Pdf ?? nil
    }
    
    func allPdfs() -> [Pdf]{
        return readAllEntries(entity: entityName, context: managedContext) as? [Pdf] ?? []
    }
    
}

