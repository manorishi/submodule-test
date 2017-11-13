//
//  QuizSummaryPresenter.swift
//  quiz
//
//  Created by Sunil Sharma on 9/7/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit

class QuizSummaryPresenter: NSObject {
    
    weak var quizSummaryVC:QuizSummaryViewController?
    
    init(quizSummaryViewController:QuizSummaryViewController) {
        self.quizSummaryVC = quizSummaryViewController
    }

    func configureViews() {
        setStars()
    }
    
    public func getScoreAndQuizEndTime() -> String {
        
        let dateFormattter = DateFormatter()
        let submissionDate = Date(timeIntervalSince1970: TimeInterval(quizSummaryVC?.submissionTime ?? 0)/1000)
        
        dateFormattter.dateFormat = "dd MMM yyyy HH:mm:ss"
        let quizEndDate = dateFormattter.string(from: submissionDate)
        return "You got \(String(describing: quizSummaryVC?.correctAnswerCount ?? 0)) of \(String(describing: quizSummaryVC?.totalQuestionCount ?? 0)) correct. Your submission time is \(quizEndDate)"
    }
    
    public func getResultTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let quizEndDate = dateFormatter.date(from: quizSummaryVC?.quizEndTime ?? "") ?? Date()
        dateFormatter.dateFormat = "hh:mm a"
        let time = dateFormatter.string(from: quizEndDate)
        dateFormatter.dateFormat = "dd MMM yyyy"
        return "Results will be out after \(time) on \(dateFormatter.string(from: quizEndDate))"
    }
    
    public func getPerformanceRemark() -> String {
        let percent = getCorrectAnswerPercentage()
        if percent >= 100 {
            return "great_job".localized
        } else if (percent >= 50){
            return "good_job".localized
        } else {
            return "you_can_do_better".localized
        }
    }
    
    private func setStars(){
        for index in 0..<getNumberOfStars() {
            let starImage = UIImage(named: "star", in: BundleManager().loadResourceBundle(), compatibleWith: nil)
            switch index {
            case 0:
                quizSummaryVC?.firstStar.image = starImage
            case 1:
                quizSummaryVC?.secondStar.image = starImage
            case 2:
                quizSummaryVC?.thirdStar.image = starImage
            case 3:
                quizSummaryVC?.fourthStar.image = starImage
            case 4:
                quizSummaryVC?.fifthStar.image = starImage
            default:
                break
            }
        }
    }
    
    private func getCorrectAnswerPercentage() -> Int {
        var totalQuestion = Float(quizSummaryVC?.totalQuestionCount ?? 1)
        totalQuestion = totalQuestion <= 0 ? 1 : totalQuestion
        let correctAnswer = Float(quizSummaryVC?.correctAnswerCount ?? 0)
        return Int(ceil((correctAnswer / totalQuestion) * 100))
    }
    
    private func getNumberOfStars() -> Int {
        let percent = getCorrectAnswerPercentage()
        if percent > 80 {
            return 5
        } else if percent > 60 {
            return 4
        } else if percent > 30 {
            return 3
        } else if percent > 20 {
            return 2
        } else if percent > 5 {
            return 1
        } else {
            return 0
        }
    }
    
    func getAnswersAttributedString(_ answers:String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let messageText = NSMutableAttributedString(
            string: answers,
            attributes: [NSParagraphStyleAttributeName: paragraphStyle,
                         NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)]
        )
        return messageText
    }
    
}
