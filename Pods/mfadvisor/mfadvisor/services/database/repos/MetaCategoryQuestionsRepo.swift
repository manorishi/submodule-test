//
//  MetaCategoryQuestionsRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaCategoryQuestionsRepo contains CRUD operations related to MetaCategoryQuestions table
 */
public class MetaCategoryQuestionsRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaCategoryQuestions"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func categoryQuestionsFromDictionary(contentData: Dictionary<String, Any>) -> MetaCategoryQuestions {
        let contentManagedObject = MetaCategoryQuestions(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let id = contentData["cat_id"] {
            contentManagedObject.cat_id =  id as? String ?? ""
            
            if let questionNo = contentData["question_no"] {
                contentManagedObject.question_no = questionNo as? Int32 ?? 0
            }
            
            if let question = contentData["question"] {
                contentManagedObject.question = question as? String ?? ""
            }
            
            if let answer = contentData["answer"] {
                contentManagedObject.answer = answer as? String ?? ""
            }
        }
        return contentManagedObject
    }
    
    
    func createCategoryQuestionsFromDictionary(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: categoryQuestionsFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func contentHavingId(categoryId: Int32) -> MetaCategoryQuestions?{
        return readEntry(condition: NSPredicate(format: "cat_id == %@", categoryId), entity: entityName, context: managedContext) as? MetaCategoryQuestions ?? nil
    }
    
}
