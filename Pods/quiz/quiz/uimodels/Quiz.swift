//
//  Quiz.swift
//  quiz
//
//  Created by Sunil Sharma on 9/7/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit

public struct Option{
    var id:Int
    var title:String
}

public class Quiz {
    var id:Int!
    var question:String!
    var options:[Option] = []
    var correctOptionId:Int!
    var answerLine:String?
    var currentTime:String!
    
    public init?(jsonData:[String:Any], currentTime:String){
        if let id = jsonData["idQuestion"] as? Int,
            let question = jsonData["question"] as? String,
            let correctOptionId = jsonData["answer"] as? Int{
            self.id = id
            self.question = question
            self.correctOptionId = correctOptionId
            self.currentTime = currentTime
            self.answerLine = jsonData["answerLine"] as? String
            if let optionArray = jsonData["options"] as? [[String:Any]] {
                for content:Dictionary in optionArray {
                    if let optionId = content["id"] as? Int,
                        let optionTitle = content["option"] as? String {
                        self.options.append(Option(id: optionId, title: optionTitle))
                    }
                }
            }
        } else {
            return nil
        }
    }
}
