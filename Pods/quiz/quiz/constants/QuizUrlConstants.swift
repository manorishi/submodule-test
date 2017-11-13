//
//  QuizUrlConstants.swift
//  quiz
//
//  Created by Sunil Sharma on 9/5/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import Foundation
import Core

/**
 QuizUrlConstants class contains all urls used in Quiz module
 */
public struct QuizUrlConstants {
    static let ABOUT_QUIZ = URLConstants.BASE_URL + "/getQuiz"
    static let QUIZ_DETAILS = URLConstants.BASE_URL + "/getQuizDetails"
    static let QUIZ_ANSWER = URLConstants.BASE_URL + "/setQuizScore"
    static let LEADERBOARD_DATA = URLConstants.BASE_URL +  "/getQuizLeaderBoard"
    static let QUIZ_HOMESCREEN_DATA = URLConstants.BASE_URL +  "/getQuizWeeklyDailyWinnerDetails"
}
