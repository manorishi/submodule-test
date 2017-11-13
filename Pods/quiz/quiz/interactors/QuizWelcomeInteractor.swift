//
//  QuizWelcomeInteractor.swift
//  quiz
//
//  Created by Sunil Sharma on 9/5/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit
import Core

public class QuizWelcomeInteractor {
    
    let quizKey = "quizs"
    let statusKey = "status"
    
    public init() {}
    
    func getDataAboutQuiz(onSuccess:@escaping (_ isChallengeCompleted:Bool, _ aboutQuiz:AboutQuiz?) -> Void, onError: @escaping (_ status:ResponseStatus, _ errorTitle:String, _ errorMessage:String) -> Void) {
        
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: QuizUrlConstants.ABOUT_QUIZ, params: nil, httpBody: nil, completionHandler: {[weak self] (status, response) in
            DispatchQueue.main.async {
                switch status {
                case .success:
                    onSuccess(self?.isChallengeCompleted(response: response) ?? false, self?.getQuizData(response: response))
                default:
                    onError(status,NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                }
            }
        })
    }
    
    public func getHomeScreenQuizData(userTypeId:Int, onSuccess:@escaping (_ dailyWinnerText:String, _ weeklyWinnerText:String) -> Void, onError: @escaping (_ status:ResponseStatus, _ errorTitle:String, _ errorMessage:String) -> Void) {
        
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: QuizUrlConstants.QUIZ_HOMESCREEN_DATA, params: nil, httpBody: ["user_type_id": userTypeId as AnyObject], completionHandler: {[weak self] (status, response) in
            DispatchQueue.main.async {
                switch status {
                case .success:
                    onSuccess(self?.getDailyWinnerText(response: response) ?? "", self?.getWeeklyWinnerText(response: response) ?? "")
                default:
                    onError(status,NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                }
            }
        })
    }

    private func getDailyWinnerText(response:[String:AnyObject]?) -> String {
        if let _ = response,
            let winnerText = response?["daily_winner_text"] as? String{
        return winnerText
        }
        return ""
    }
    
    private func getWeeklyWinnerText(response:[String:AnyObject]?) -> String {
        if let _ = response,
            let winnerText = response?["weekly_winner_text"] as? String{
            return winnerText
        }
        return ""
    }
    
    func isChallengeCompleted(response:[String:AnyObject]?) -> Bool {
        if let _ = response, let responseData = response?[quizKey] as? [String:Any],
            let currentQuizId = responseData["id_quiz"] as? Int{
            if currentQuizId == getQuizId() {
                return UserDefaults.standard.bool(forKey: QuizConstants.quizComppleteStatusKey)
            }
            saveQuizId(currentQuizId)
        }
        return false
    }
    
    private func saveQuizId(_ id: Int){
        UserDefaults.standard.set(id, forKey: QuizConstants.quizIdKey)
    }
    
    private func getQuizId() -> Int{
        let id = UserDefaults.standard.integer(forKey:QuizConstants.quizIdKey)
        return id <= 0 ? -1 : id
    }
    
    func getQuizData(response:[String:AnyObject]?) -> AboutQuiz? {
        if let _ = response, let responseData = response?[quizKey] as? [String:Any] {
            return AboutQuiz(jsonData: responseData)
        } else {
            return nil
        }
    }
    
    func getTotalQuestionCount() -> Int {
        return UserDefaults.standard.integer(forKey: QuizConstants.quizTotalQuestionKey)
    }
    
    func getCorrectAnswerCount() -> Int {
        return UserDefaults.standard.integer(forKey: QuizConstants.quizCorrectAnswerCountKey)
    }
    
    func getQuizEndTime() -> String {
        return UserDefaults.standard.string(forKey: QuizConstants.quizEndTimeKey) ?? ""
    }
    
    func getQuizSubmissionTime() -> Double {
        return UserDefaults.standard.double(forKey: QuizConstants.quizSubmissionTimeKey)
    }
    
    func getQuizAnswers() -> String {
        return UserDefaults.standard.string(forKey: QuizConstants.quizAnswersKey) ?? ""
    }
    
    
    
}
