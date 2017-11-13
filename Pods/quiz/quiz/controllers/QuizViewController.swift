//
//  QuizViewController.swift
//  quiz
//
//  Created by Sunil Sharma on 9/6/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit
import Core

public extension UIView {
    
    func shake(duration:TimeInterval? = nil) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration ?? 0.3
        animation.values = [-12.0, 12.0, -8.0, 8.0, -6.0, 6.0, -3.0, 3.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }    
}

class QuizViewController: QuizBaseViewController, QuizDelegate {

    @IBOutlet weak var questionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var quizScrollView: UIScrollView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var currentQuestionNoLabel: UILabel!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionsScrollContentView: UIView!
    
    private var loadingController:UIAlertController?
    private var quizPresenter:QuizPresenter!
    private var currentQuizNumber:Int = 0
    private var quizs:[Quiz] = []
    
    public var quizId:Int!
    private var correctAnswerCount = 0
    private var quizStartTime:UInt64!
    private var quizSubmissionTime:Double?
    private var quizEndTime:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        quizPresenter = QuizPresenter(quizViewController: self)
        quizPresenter.delegate = self
        quizStartTime = quizPresenter.timeInMiliseconds()
        hideQuestionView()
        getDataFromServer()
    }
    
    func getDataFromServer() {
        loadingController = AlertViewHelper(alertViewCallbackProtocol: nil).loadingAlertViewController(title: "Loading...", message: "\n\n")
        present(loadingController!, animated: true) { [weak self] in
            self?.quizPresenter.getDataFromServer(quizId: self?.quizId ?? -1)
        }
    }

    @IBAction func clickedOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onSuccess(quizArray: [Quiz], quizEndTime:String, isChallengeCompleted:Bool) {
        loadingController?.dismiss(animated: true, completion: nil)
        quizs.append(contentsOf: quizArray)
        self.quizEndTime = quizEndTime
        updateQuizView()
    }
    
    override func onError(errorStatus: ResponseStatus, errorTitle: String, errorMessage: String) {
        loadingController?.dismiss(animated: true, completion: nil)
        super.onError(errorStatus: errorStatus, errorTitle: errorTitle, errorMessage: errorMessage)
    }
    
    
    private func hideQuestionView(){
        quizScrollView.isHidden = true
        questionLabel.isHidden = true
    }
    
    private func showQuestionView(){
        quizScrollView.isHidden = false
        questionLabel.isHidden = false
    }
    
    private func updateQuizView(){
        if currentQuizNumber < quizs.count {
            presentQuestionViewWithAnimation()
        } else if ((currentQuizNumber) == quizs.count){
            updateAnswersOnServer()
        }
    }
    
    private func presentQuestionViewWithAnimation(){
        hideQuestionView()
        
        let quiz = quizs[currentQuizNumber]
        questionLabel.text = quiz.question
        quizPresenter.addOptions(contentView: optionsScrollContentView, optionArray: quiz.options)
        contentViewHeightConstraint.constant = optionsScrollContentView.frame.height
        
        let actualLabelFrame = questionLabel.frame
        let actualScrollViewFrame = quizScrollView.frame
        questionLabel.frame.origin.y = self.view.frame.origin.y + self.view.frame.height
        quizScrollView.frame.origin.y = questionLabel.frame.origin.y + questionLabel.frame.height
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {[weak self] in
            self?.showQuestionView()
            self?.questionLabel.frame = actualLabelFrame
            self?.quizScrollView.frame = actualScrollViewFrame
            }, completion: {[weak self] (isFinished) in
                self?.currentQuestionNoLabel.text = "\((self?.currentQuizNumber ?? 0) + 1) of \(quiz.options.count)"
        })
    }
    
    public func clickedOnOption(sender:UIGestureRecognizer){
        optionsScrollContentView.isUserInteractionEnabled = false
        if let optionLabel = sender.view as? UILabel{
            let quiz = quizs[currentQuizNumber]
            if quiz.correctOptionId == optionLabel.tag {
                optionLabel.backgroundColor = QuizColors.optionCorrect
                correctAnswerCount += 1
            } else {
                optionLabel.backgroundColor = QuizColors.optionIncorrect
                optionLabel.shake()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.31, execute: {
                    self.highlightCorrectOption()
                })
            }
            moveToNextQuestion()
        }
    }
    
    private func highlightCorrectOption(){
        let quiz = quizs[currentQuizNumber]
        if let optionalLabel = optionsScrollContentView.viewWithTag(quiz.correctOptionId){
            optionalLabel.backgroundColor = QuizColors.optionCorrect
        }
    }
    
    private func moveToNextQuestion(){
        if currentQuizNumber < quizs.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.currentQuizNumber += 1
                self.updateQuizView()
            }
        }
    }
    
    func onAnswerUpdateSuccess() {
        quizPresenter.saveQuizSummaryData(totalQuestionCount: quizs.count, correctAnswerCount: correctAnswerCount, submissionTime: quizSubmissionTime ?? 0, quizEndTime: quizEndTime ?? "")
        loadingController?.dismiss(animated: true, completion: {[weak self] in
            self?.gotoSummaryViewController()
        })
    }
    
    private func gotoSummaryViewController(){
        if let quizSummaryVC = self.quizPresenter.getQuizSummaryViewController() {
            quizSummaryVC.totalQuestionCount = self.quizs.count
            quizSummaryVC.correctAnswerCount = self.correctAnswerCount
            quizSummaryVC.submissionTime = self.quizSubmissionTime ?? 0
            quizSummaryVC.quizEndTime = self.quizEndTime
            quizSummaryVC.answers = quizPresenter.getQuizAnswers(quizs: quizs)
            self.navigationController?.pushViewController(quizSummaryVC, animated: true)
        }
    }
    
    private func updateAnswersOnServer(){
        if loadingController == nil {
        loadingController = AlertViewHelper(alertViewCallbackProtocol: nil).loadingAlertViewController(title: "Loading...", message: "\n\n")
        }
        present(loadingController!, animated: true, completion: nil)
        let duration = Double(quizPresenter.timeInMiliseconds() - quizStartTime) / 1000.0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        quizSubmissionTime = Double(quizPresenter.timeInMiliseconds(date: dateFormatter.date(from: quizs[0].currentTime) ?? Date())) + duration
        quizPresenter.updateAnswerOnServer(quizId: quizId, score: correctAnswerCount, duration: Float(duration), completedAt: quizSubmissionTime ?? 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
