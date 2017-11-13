//
//  MetaFundQuestionsRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaFundQuestionsRepo contains CRUD operations related to MetaFundQuestions table
 */
public class MetaFundQuestionsRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaFundQuestions"
    private let investmentStrategyQuestionNumber = 4
    private let portfolioAllocationQuestionNumber = 4
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func fundQuestionsFromDictionary(contentData: Dictionary<String, Any>) -> MetaFundQuestions {
        let contentManagedObject = MetaFundQuestions(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        
        if let id = contentData["fund_id"] {
            contentManagedObject.fund_id =  id as? String ?? ""
            
            if let questionNo = contentData["question_no"] {
                contentManagedObject.question_no = questionNo as? Int16 ?? 0
            }
            
            if let questionIcon = contentData["question_icon"] {
                contentManagedObject.question_icon = questionIcon as? String ?? ""
            }
            
            if let question = contentData["question"] {
                contentManagedObject.question = question as? String ?? ""
            }
            
            if let answerImage = contentData["answer_image"] {
                contentManagedObject.answer_image = answerImage as? String ?? ""
            }
            
            if let answerTopline = contentData["answer_topline"] {
                contentManagedObject.answer_topline = answerTopline as? String ?? ""
            }
            
            if let answer1Icon = contentData["answer1_icon"] {
                contentManagedObject.answer1_icon = answer1Icon as? String ?? ""
            }
            
            if let answer1 = contentData["answer1"] {
                contentManagedObject.answer1 = answer1 as? String ?? ""
            }
            
            if let answer2Icon = contentData["answer2_icon"] {
                contentManagedObject.answer2_icon = answer2Icon as? String ?? ""
            }
            
            if let answer2 = contentData["answer2"] {
                contentManagedObject.answer2 = answer2 as? String ?? ""
            }
            
            if let answer3Icon = contentData["answer3_icon"] {
                contentManagedObject.answer3_icon = answer3Icon as? String ?? ""
            }
            
            if let answer3 = contentData["answer3"] {
                contentManagedObject.answer3 = answer3 as? String ?? ""
            }
            
            if let answer4Icon = contentData["answer4_icon"] {
                contentManagedObject.answer4_icon = answer4Icon as? String ?? ""
            }
            
            if let answer4 = contentData["answer4"] {
                contentManagedObject.answer4 = answer4 as? String ?? ""
            }
            
            if let answerBottomLine = contentData["answer_bottomline"] {
                contentManagedObject.answer_bottomline = answerBottomLine as? String ?? ""
            }
            
        }
        return contentManagedObject
    }
    
    func createFundQuestions(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: fundQuestionsFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    func fundQuestionsHaving(fundId: String) -> [MetaFundQuestions] {
        return readEntries(condition: NSPredicate(format: "fund_id == %@", fundId) , entity: entityName, context: managedContext) as? [MetaFundQuestions] ?? []
    }
    
    func investmentStrategyQuestion(fundId: String) -> MetaFundQuestions?{
        return readEntry(condition: NSPredicate(format: "fund_id == %@ && question_no == %d", fundId, investmentStrategyQuestionNumber), entity: entityName, context: managedContext) as? MetaFundQuestions
    }
    
    func portfolioAllocationQuestion(fundId: String) -> MetaFundQuestions?{
        return readEntry(condition: NSPredicate(format: "fund_id == %@ && question_no == %d", fundId, portfolioAllocationQuestionNumber), entity: entityName, context: managedContext) as? MetaFundQuestions
    }
}
