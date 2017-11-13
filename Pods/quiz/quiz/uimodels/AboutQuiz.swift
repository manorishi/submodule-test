//
//  AboutQuiz.swift
//  quiz
//
//  Created by Sunil Sharma on 9/5/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import Foundation

public class AboutQuiz {
    var quizId:Int!
    var info:String?
    var reward:String?
    var timeTextNormal:String?
    var timeTextLater:String?
    var startTime:String?
    var endTime:String?
    
    public init(){}
    
    public init?(jsonData:[String:Any]){
        if let id = jsonData["id_quiz"] as? Int {
            quizId = id
            info = jsonData["info"] as? String
            reward = jsonData["reward"] as? String
            timeTextNormal = jsonData["time_text_normal"] as? String
            timeTextLater = jsonData["time_text_later"] as? String
            startTime = jsonData["start_time"] as? String
            endTime = jsonData["end_time"] as? String
        } else {
            return nil
        }
    }
}
