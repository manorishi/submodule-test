//
//  QuizInteractor.swift
//  quiz
//
//  Created by Sunil Sharma on 9/6/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit
import Core

class QuizInteractor {
    
    let quizKey = "quizs"
    let statusKey = "status"
    
    public func getQuestionFromServer(quizId:Int, onSuccess:@escaping (_ quizs:[Quiz], _ quizEndTime:String, _ isChallengeCompleted:Bool) -> Void, onError: @escaping (_ status:ResponseStatus, _ errorTitle:String, _ errorMessage:String) -> Void){
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: QuizUrlConstants.QUIZ_DETAILS, params: nil, httpBody: ["id_quiz": quizId as AnyObject], completionHandler: {[weak self] (status, response) in
            DispatchQueue.main.async {
                switch status {
                case .success:
                    onSuccess((self?.getQuizsFromResponse(response: response)) ?? [], self?.getQuizEndTimeFromResponse(response: response) ?? "", self?.isChallengeCompleted(response: response) ?? false)
                default:
                    onError(status,NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                }
            }
        })
    }
    
    func isChallengeCompleted(response:[String:AnyObject]?) -> Bool {
        if let _ = response, let responseData = response?[quizKey] as? [String:Any] {
            let status = (responseData[statusKey] as? Int) ?? 0
            return status == 0 ? false : true
        } else {
            return false
        }
    }

    
    private func getQuizEndTimeFromResponse(response:[String:AnyObject]?) -> String {
        if let _ = response,
            let endTimeString = response?["quizs"]?["end_time"] as? String{
            return endTimeString
        } else {
            return ""
        }
    }
    
    private func getQuizsFromResponse(response:[String:AnyObject]?) -> [Quiz]{
        if let _ = response,
            let questions = response?["quizs"]?["questions"] as? [[String:Any]],
            let currentTime = response?["current_time"] as? String {
            var quizArray = [Quiz]()
            for content:Dictionary in questions {
                if let quiz = Quiz(jsonData: content, currentTime: currentTime){
                    quizArray.append(quiz)
                }
            }
            return quizArray
        } else {
            return []
        }
    }
    
    public func updateAnswerOnServer(quizId:Int,score:Int, duration:Float, completedAt:Double, onSuccess:@escaping () -> Void, onError: @escaping (_ status:ResponseStatus, _ errorTitle:String, _ errorMessage:String) -> Void) {
        let httpBody:[String:AnyObject] = ["id_quiz": quizId as AnyObject,
                                           "score": score as AnyObject,
                                           "duration": duration as AnyObject,
                                           "completed_at":completedAt as AnyObject]
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: QuizUrlConstants.QUIZ_ANSWER, params: nil, httpBody: httpBody, completionHandler: {[weak self](status, response) in
            DispatchQueue.main.async {
                switch status {
                case .success:
                    self?.saveUserQuizCompleteStatus(true)
                    onSuccess()
                default:
                    onError(status,NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                }
            }
        })
    }
    
    private func saveUserQuizCompleteStatus(_ status:Bool){
        UserDefaults.standard.set(status, forKey: QuizConstants.quizComppleteStatusKey)
    }
    
    public func saveQuizAnswers(_ answers:String){
        UserDefaults.standard.set(answers, forKey: QuizConstants.quizAnswersKey)
    }
    
    public func saveQuizSummaryData(totalQuestionCount:Int, correctAnswerCount:Int,submissionTime:Double, quizEndTime:String){
        UserDefaults.standard.set(totalQuestionCount, forKey: QuizConstants.quizTotalQuestionKey)
        UserDefaults.standard.set(correctAnswerCount, forKey: QuizConstants.quizCorrectAnswerCountKey)
        UserDefaults.standard.set(submissionTime, forKey: QuizConstants.quizSubmissionTimeKey)
        UserDefaults.standard.set(quizEndTime, forKey: QuizConstants.quizEndTimeKey)
        
    }
}
