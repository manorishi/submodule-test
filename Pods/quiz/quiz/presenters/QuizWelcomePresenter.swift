//
//  QuizWelcomePresenter.swift
//  quiz
//
//  Created by Sunil Sharma on 9/5/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit
import Core

protocol QuizWelcomeDelegate: class {
    func onSuccess(isChallengeCompleted:Bool, aboutQuiz:AboutQuiz?)
    func onError(errorStatus:ResponseStatus, errorTitle:String, errorMessage:String)
}

class QuizWelcomePresenter:NSObject {
    
    weak var quizWelcomeVC:QuizWelcomeViewController!
    weak var delegate:QuizWelcomeDelegate?
    let quizWelcomeInteractor:QuizWelcomeInteractor!
    
    init(quizWelcomeController:QuizWelcomeViewController) {
        self.quizWelcomeVC = quizWelcomeController
        quizWelcomeInteractor = QuizWelcomeInteractor()
    }
    
    public func configureView(quizView:UIView, nextQuizView:UIView) {
        nextQuizView.clipsToBounds = true
        nextQuizView.layer.cornerRadius = nextQuizView.frame.size.height / 2
        quizView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func getQuizViewController() -> QuizViewController? {
        var quizVC:QuizViewController?
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            quizVC = QuizViewController(nibName: "QuizViewController", bundle: bundle)
        }
        return quizVC
    }

    public func getDataFromServer(){
        quizWelcomeInteractor.getDataAboutQuiz(onSuccess: {[weak self] (isChallengeCompleted, aboutQuiz) in
            DispatchQueue.main.async {
                self?.delegate?.onSuccess(isChallengeCompleted: isChallengeCompleted, aboutQuiz: aboutQuiz)
            }
        }) {[weak self] (status, errorTitle, errorMessage) in
            DispatchQueue.main.async {
                self?.delegate?.onError(errorStatus: status, errorTitle: errorTitle, errorMessage: errorMessage)
            }
        }
    }
    
    public func getTimeInfoText(aboutQuiz:AboutQuiz) -> String {
        return isChallengeExpired(aboutQuiz: aboutQuiz) ? aboutQuiz.timeTextLater ?? "" : aboutQuiz.timeTextNormal ?? ""
    }
    
    public func isChallengeExpired(aboutQuiz:AboutQuiz) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let startDate = dateFormatter.date(from: aboutQuiz.startTime ?? ""),
            let endDate = dateFormatter.date(from: aboutQuiz.endTime ?? ""){
            let currentDate = Date()
            return (startDate <= currentDate && currentDate <= endDate)
        } else {
            return false
        }
    }
    
    func stringWidthWithConstrainedHeight(string:String, _ height: CGFloat, font: UIFont, options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let boundingBox = string.boundingRect(with: constraintRect, options: options, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }
    
    func getQuizSummaryViewController() -> QuizSummaryViewController? {
        var quizVC:QuizSummaryViewController?
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            quizVC = QuizSummaryViewController(nibName: "QuizSummaryViewController", bundle: bundle)
        }
        return quizVC
    }
    
    func getTotalQuestionCount() -> Int {
        return quizWelcomeInteractor.getTotalQuestionCount()
    }
    
    func getCorrectAnswerCount() -> Int {
        return quizWelcomeInteractor.getCorrectAnswerCount()
    }
    
    func getQuizEndTime() -> String {
        return quizWelcomeInteractor.getQuizEndTime()
    }
    
    func getQuizSubmissionTime() -> Double {
        return quizWelcomeInteractor.getQuizSubmissionTime()
    }
    
    func getQuizAnswers() -> String {
        return quizWelcomeInteractor.getQuizAnswers()
    }
}
