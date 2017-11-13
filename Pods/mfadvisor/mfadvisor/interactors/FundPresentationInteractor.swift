//
//  FundPresentationInteractor.swift
//  mfadvisor
//
//  Created by Anurag Dake on 09/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import Core
import CoreData

/**
 FundPresentationInteractor fetches fund presentation required data and api calls to update presentation count
 */
class FundPresentationInteractor{
    
    /**
     Make api call to increment presentation share count
     */
    func incrementPresentationShareCount(completionHandler:@escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void){
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: MFUrlConstants.UPDATE_PRESENTATION_SHARE_COUNT_URL, params: nil, httpBody: ["presentations_shared": presentationCountToIncrement() as AnyObject], completionHandler: completionHandler)
    }
    
    /**
     Update presentation share count in keychain
     */
    func updatePresentationShareCount(count: Int){
        KeyChainService.sharedInstance.setValue(string: String(count), key: ConfigKeys.PRESENTATION_COUNT_KEY)
    }
    
    /**
     Update share count of presentations which is not synced with server - pending share count
     */
    func updatePresentationsToShareCount(){
        let count = presentationCountToIncrement()
        KeyChainService.sharedInstance.setValue(string: String(count), key: ConfigKeys.PRESENTATIONS_SHARE_COUNT_TO_UPDATE_KEY)
    }
    
    /**
     Delete pending share count once synced with server
     */
    func deletePendingShareCount(){
        KeyChainService.sharedInstance.setValue(string: String(0), key: ConfigKeys.PRESENTATIONS_SHARE_COUNT_TO_UPDATE_KEY)
    }
    
    /**
     Get presentation share count to update with server including pending share count
     */
    private func presentationCountToIncrement() -> Int{
        let shareCountToUpdate = KeyChainService.sharedInstance.getValue(key: ConfigKeys.PRESENTATIONS_SHARE_COUNT_TO_UPDATE_KEY)
        return ((Int(shareCountToUpdate ?? "0") ?? 0) + 1)
    }
    
    ///Fetch investment startegy data from QA repo
    func investmentStrategy(managedObjectContext: NSManagedObjectContext, fundId: String) -> (answers: [AnswerData], disclaimer: String){
        var investmentStrategies = [AnswerData]()
        
        let investmentStrategy = MFADataService.sharedInstance.metaFundQuestionsRepo(context: managedObjectContext).investmentStrategyQuestion(fundId: fundId)
        let answer1 = AnswerData(icon: investmentStrategy?.answer1_icon ?? "", answer: htmlFromString(htmlText: investmentStrategy?.answer1 ?? "", fontColor: UIColor.black, font: UIFont.systemFont(ofSize: 10))!)
        let answer2 = AnswerData(icon: investmentStrategy?.answer2_icon ?? "", answer: htmlFromString(htmlText: investmentStrategy?.answer2 ?? "", fontColor: UIColor.black, font: UIFont.systemFont(ofSize: 10))!)
        let answer3 = AnswerData(icon: investmentStrategy?.answer3_icon ?? "", answer: htmlFromString(htmlText: investmentStrategy?.answer3 ?? "", fontColor: UIColor.black, font: UIFont.systemFont(ofSize: 10))!)
        investmentStrategies.append(answer1)
        investmentStrategies.append(answer2)
        investmentStrategies.append(answer3)
        
        let disclaimerText = investmentStrategy?.answer_bottomline ?? ""
        return (investmentStrategies, disclaimerText)
    }
    
    ///Fetch portfolio allocation data from QA repo
    func portfolioAllocation(managedObjectContext: NSManagedObjectContext, fundId: String) -> (answers: [AnswerData], disclaimer: String){
        var portfolioAllocations = [AnswerData]()
        
        let portfolioAllocation = MFADataService.sharedInstance.metaFundQuestionsRepo(context: managedObjectContext).portfolioAllocationQuestion(fundId: fundId)
        let answer1 = AnswerData(icon: portfolioAllocation?.answer1_icon ?? "", answer: htmlFromString(htmlText: portfolioAllocation?.answer1 ?? "", fontColor: UIColor.black, font: UIFont.systemFont(ofSize: 10))!)
        let answer2 = AnswerData(icon: portfolioAllocation?.answer2_icon ?? "", answer: htmlFromString(htmlText: portfolioAllocation?.answer2 ?? "", fontColor: UIColor.black, font: UIFont.systemFont(ofSize: 10))!)
        let answer3 = AnswerData(icon: portfolioAllocation?.answer3_icon ?? "", answer: htmlFromString(htmlText: portfolioAllocation?.answer3 ?? "", fontColor: UIColor.black, font: UIFont.systemFont(ofSize: 10))!)
        portfolioAllocations.append(answer1)
        portfolioAllocations.append(answer2)
        portfolioAllocations.append(answer3)
        
        let disclaimerText = portfolioAllocation?.answer_bottomline ?? ""
        return (portfolioAllocations, disclaimerText)
    }
    
}
