//
//  SalesPitchData.swift
//  mfadvisor
//
//  Created by Apple on 06/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

/**
 AnswerData is UI model to store data to display answer data with html string(attributed string)
 */
struct AnswerData {
    var icon:String!
    var answer:NSAttributedString!
    
    init(icon:String, answer:NSAttributedString) {
        self.icon = icon
        self.answer = answer
    }
}

/**
 SalesPitchData contains question answer data along with images and collapse/expand state
 */
class SalesPitchData: NSObject {
    let questionIcon: String!
    let question: String!
    // Maintain total count of non nil variable. Helpful to display cell in tableview.
    private(set) var answerCount:Int = 7
    var answerImage:String? = nil
    
    var answer1:AnswerData? = nil
    var answer2:AnswerData? = nil
    var answer3:AnswerData? = nil
    var answer4:AnswerData? = nil
    var answerTopline:String? = nil
    var answerBottomline:String? = nil
    
    var collapsed: Bool = true
    var isExpandable: Bool = true
    
    init(questionIcon: String, question: String) {
        self.questionIcon = questionIcon
        self.question = question
    }
}
