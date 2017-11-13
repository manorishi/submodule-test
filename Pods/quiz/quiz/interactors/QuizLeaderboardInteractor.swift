//
//  Leaderboard.swift
//  quiz
//
//  Created by Sunil Sharma on 9/11/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit
import Core

class QuizLeaderboardInteractor {

    func getLeaderboardDataFromServer(userId:Int, onSuccess:@escaping (_ dailyDatas:[QuizLeaderboard], _ weeklyDatas:[QuizLeaderboard], _ monthly:[QuizLeaderboard]) -> Void, onError: @escaping (_ status:ResponseStatus, _ errorTitle:String, _ errorMessage:String) -> Void) {
        print(#function)
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: QuizUrlConstants.LEADERBOARD_DATA, params: nil, httpBody: ["user_type_id": userId as AnyObject], completionHandler: {[weak self] (status, response) in
            DispatchQueue.main.async {
                switch status {
                case .success:
                    onSuccess((self?.getDailyLeaderboardDataFromResponse(response: response)) ?? [], (self?.getWeeklyLeaderboardDataFromResponse(response: response)) ?? [], (self?.getMonthlyLeaderboardDataFromResponse(response: response)) ?? [])
                default:
                    onError(status,NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                }
            }
        })
    }
    
    private func getMonthlyLeaderboardDataFromResponse(response:[String:AnyObject]?) -> [QuizLeaderboard] {
        if let _ = response,
            let questions = response?["monthly_quizs"] as? [[String:Any]]{
            var quizLeaderboardArray = [QuizLeaderboard]()
            for content:Dictionary in questions {
                if let quiz = QuizLeaderboard(jsonData: content){
                    quizLeaderboardArray.append(quiz)
                }
            }
            return quizLeaderboardArray
        } else {
            return []
        }
    }
    
    private func getWeeklyLeaderboardDataFromResponse(response:[String:AnyObject]?) -> [QuizLeaderboard] {
        if let _ = response,
            let questions = response?["weekly_quizs"] as? [[String:Any]]{
            var quizLeaderboardArray = [QuizLeaderboard]()
            for content:Dictionary in questions {
                if let quiz = QuizLeaderboard(jsonData: content){
                    quizLeaderboardArray.append(quiz)
                }
            }
            return quizLeaderboardArray
        } else {
            return []
        }
    }
    
    private func getDailyLeaderboardDataFromResponse(response:[String:AnyObject]?) -> [QuizLeaderboard] {
        if let _ = response,
            let questions = response?["quizs"] as? [[String:Any]]{
            var quizLeaderboardArray = [QuizLeaderboard]()
            for content:Dictionary in questions {
                if let quiz = QuizLeaderboard(jsonData: content){
                    quizLeaderboardArray.append(quiz)
                }
            }
            return quizLeaderboardArray
        } else {
            return []
        }
    }
}
