//
//  SalesPitchInteractor.swift
//  mfadvisor
//
//  Created by Apple on 06/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core

/**
 SalesPitchInteractor fetches sales pitch QA data from db
 */
class SalesPitchInteractor {
    
    //Get Fund Questions data from local database.
    func getFundsQuestionsData(fundId:String, managedObjectContext: NSManagedObjectContext) -> [SalesPitchData] {
        
        let metaFundQuestionRepo = MFADataService.sharedInstance.metaFundQuestionsRepo(context: managedObjectContext)
        
        var fundQuestions = metaFundQuestionRepo.fundQuestionsHaving(fundId: fundId)
        fundQuestions = fundQuestions.sorted(by: { $0.question_no < $1.question_no})
        var salesPitchDataArray = [SalesPitchData]()
        for data in fundQuestions {
            let salesPitchData = SalesPitchData(questionIcon: data.question_icon ?? "", question: data.question ?? "")
            
            if data.answer_topline != nil && !(data.answer_topline?.isEmpty ?? true) {
                salesPitchData.answerTopline = data.answer_topline
            }
            else {
                salesPitchData.answerTopline = nil
            }
            
            if data.answer_bottomline != nil && !(data.answer_bottomline?.isEmpty ?? true) {
                salesPitchData.answerBottomline = data.answer_bottomline
            }
            else {
                salesPitchData.answerBottomline = nil
            }
            
            if data.answer_image != nil && !(data.answer_image?.isEmpty ?? true) {
                salesPitchData.answerImage = data.answer_image
            }
            else {
                salesPitchData.answerImage = nil
            }
            
            salesPitchData.answer1 = fundAnswerData(answerIcon: data.answer1_icon, answer: data.answer1)
            salesPitchData.answer2 = fundAnswerData(answerIcon: data.answer2_icon, answer: data.answer2)
            salesPitchData.answer3 = fundAnswerData(answerIcon: data.answer3_icon, answer: data.answer3)
            salesPitchData.answer4 = fundAnswerData(answerIcon: data.answer4_icon, answer: data.answer4)
            
            salesPitchDataArray.append(salesPitchData)
        }
        return salesPitchDataArray
    }
    
    func fundAnswerData(answerIcon:String?, answer:String?) -> AnswerData?{
        
        if let ansIcon = answerIcon, ansIcon.isEmpty == false, let ans = answer, ans.isEmpty == false {
            let attributedString = htmlFromString(htmlText: ans, fontColor: UIColor.black, font: UIFont.systemFont(ofSize: 15)) ?? NSAttributedString()
            let answerData = AnswerData(icon: ansIcon, answer: attributedString)
            return answerData
        }
        else {
            return nil
        }
    }
    
    func fundNameFrom(fundId:String, managedObjectContext: NSManagedObjectContext) -> String? {
        let metaFundMasterRepo = MFADataService.sharedInstance.metaFundMasterRepo(context: managedObjectContext)
        let fundData = metaFundMasterRepo.fundHavingId(fundId: fundId)
        return fundData?.fund_name
    }
}
