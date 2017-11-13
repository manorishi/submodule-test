//
//  QuizLeaderboard.swift
//  quiz
//
//  Created by Sunil Sharma on 9/11/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit

struct User {
    var name:String
    var score:Int
    var rank:Int = 0
    var completedAt:String
    
    init(name:String, score:Int, rank:Int = 0, completedAt:String) {
        self.name = name
        self.score = score
        self.rank = rank
        self.completedAt = completedAt
    }
    
}

class QuizLeaderboard {
    var quizId:Int!
    var title:String!
    var startTime:String!
    var totalQuestion:Int = 0
    var users:[User] = []
    
    init?(jsonData:[String:Any]) {
        if let title = jsonData["title"] as? String,
            let startTime = jsonData["start_time"] as? String {
            if let id = jsonData["id_quiz"] as? Int {
                self.quizId = id
            } else {
                self.quizId = 0
            }
            if let totalQuestion = jsonData["total_questions"] as? Int {
                self.totalQuestion = totalQuestion
            }
            self.title = title
            self.startTime = startTime
            
            if let optionArray = jsonData["users"] as? [[String:Any]] {
                for (index,content) in optionArray.enumerated() {
                    if let name = content["name"] as? String,
                        let score = content["score"] as? Int{
                        let completedAt = (content["completed_at"] as? String) ?? ""
                        var user = User(name: name, score: score, completedAt: completedAt)
                        if let rank = content["rank"] as? Int {
                            user.rank = rank
                        } else{
                            user.rank = index + 1
                        }
                        self.users.append(user)
                    }
                }
            }
        } else {
            return nil
        }
    }
}
