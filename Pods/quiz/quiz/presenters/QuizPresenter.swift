//
//  QuizPresenter.swift
//  quiz
//
//  Created by Sunil Sharma on 9/6/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit
import Core

protocol QuizDelegate:class {
    func onSuccess(quizArray:[Quiz], quizEndTime:String, isChallengeCompleted:Bool)
    func onError(errorStatus:ResponseStatus, errorTitle:String, errorMessage:String)
    func onAnswerUpdateSuccess()
}

class QuizPresenter:NSObject {
    public weak var delegate:QuizDelegate?
    private weak var quizViewController:QuizViewController?
    private var quizInteractor:QuizInteractor!
    
    init(quizViewController:QuizViewController) {
        self.quizViewController = quizViewController
        quizInteractor = QuizInteractor()
    }
    
    public func updateAnswerOnServer(quizId:Int,score:Int, duration:Float, completedAt:Double){
        quizInteractor.updateAnswerOnServer(quizId: quizId, score: score, duration: duration, completedAt: completedAt, onSuccess: {[weak self] in
            self?.delegate?.onAnswerUpdateSuccess()
        }) {[weak self] (status, errorTitle, errorMsg) in
            self?.delegate?.onError(errorStatus: status, errorTitle: errorTitle, errorMessage: errorMsg)
        }
    }
    
    public func getDataFromServer(quizId:Int){
        quizInteractor.getQuestionFromServer(quizId: quizId, onSuccess: {[weak self] (quizArray, quizEndTime, isChallengeCompleted) in
            DispatchQueue.main.async {
                self?.quizInteractor.saveQuizAnswers(self?.getQuizAnswers(quizs: quizArray) ?? "")
                self?.delegate?.onSuccess(quizArray:quizArray, quizEndTime: quizEndTime, isChallengeCompleted: isChallengeCompleted)
            }
        }) {[weak self] (status, errorTitle, errorMessage) in
            DispatchQueue.main.async {
                self?.delegate?.onError(errorStatus: status, errorTitle: errorTitle, errorMessage: errorMessage)
            }
        }
    }
    
    private func clearViews(contentView:UIView){
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
    }
    
    public func addOptions(contentView:UIView, optionArray:[Option]){
        clearViews(contentView: contentView)
        var frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.875, height: 0)
        for option in optionArray {
            let optionLabel = configureOptionLabel(frame: &frame, title: option.title)
            optionLabel.tag = option.id
            frame.origin.y = 2 + frame.origin.y + frame.height
            contentView.addSubview(optionLabel)
        }
        contentView.isUserInteractionEnabled = true
        contentView.frame.size.height = frame.height <= 4 ? frame.height : (frame.origin.y + frame.height - 4)
    }
    
    private func configureOptionLabel(frame:inout CGRect, title:String) -> UILabel {
        let optionLabel:CustomLabel = CustomLabel()
        optionLabel.textColor = .black
        optionLabel.backgroundColor = .white
        optionLabel.clipsToBounds = true
        optionLabel.layer.cornerRadius = 2
        optionLabel.numberOfLines = 0
        optionLabel.text = title
        optionLabel.textAlignment = .center
        optionLabel.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let font = UIFont.systemFont(ofSize: 14)
        optionLabel.font = font
        var height = ((optionLabel.text?.heightWithConstrainedWidth(frame.width - 20, font: font)) ?? 0) + 20
        height = height < 45 ? 45 : height
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: height)
        optionLabel.frame = frame
        
        optionLabel.isUserInteractionEnabled = true
        optionLabel.addGestureRecognizer(UITapGestureRecognizer(target: quizViewController, action: #selector(QuizViewController.clickedOnOption(sender:))))
        return optionLabel
    }
    
    func getQuizSummaryViewController() -> QuizSummaryViewController? {
        var quizVC:QuizSummaryViewController?
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            quizVC = QuizSummaryViewController(nibName: "QuizSummaryViewController", bundle: bundle)
        }
        return quizVC
    }
    
    func timeInMiliseconds(date:Date = Date()) -> UInt64 {
        let currentDate = date
        let since1970 = currentDate.timeIntervalSince1970
        return UInt64(since1970 * 1000)
    }
    
    public func saveQuizSummaryData(totalQuestionCount:Int, correctAnswerCount:Int,submissionTime:Double, quizEndTime:String){
        quizInteractor.saveQuizSummaryData(totalQuestionCount: totalQuestionCount, correctAnswerCount: correctAnswerCount, submissionTime: submissionTime, quizEndTime: quizEndTime)
    }
    
    public func getQuizAnswers(quizs:[Quiz]) -> String {
        var answers = ""
        for (index, quiz) in quizs.enumerated(){
            answers += index == 0 ? "\n" : "\n\n"
            answers += "Q\(index + 1). \(quiz.question ?? "")\nA. \(String(describing: quiz.answerLine ?? ""))"
        }
        return answers
    }
    
}
