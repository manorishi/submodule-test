//
//  QuizWelcomeViewController.swift
//  quiz
//
//  Created by Sunil Sharma on 9/5/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit
import Core

public class QuizWelcomeViewController: QuizBaseViewController, QuizWelcomeDelegate, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var quizInfoLabel: UILabel!
    @IBOutlet weak var timeInfoLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var aboutQuizView: UIView!
    @IBOutlet weak var nextQuizView: UIView!
    @IBOutlet weak var startQuizLabel: UILabel!
    
    private var quizWelcomePresenter:QuizWelcomePresenter!
    private var loadingController:UIAlertController?
    private var quizId:Int!
    private var isChallengeCompleted = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        self.edgesForExtendedLayout = []
        quizWelcomePresenter = QuizWelcomePresenter(quizWelcomeController: self)
        quizWelcomePresenter.delegate = self
        quizWelcomePresenter.configureView(quizView: aboutQuizView, nextQuizView: nextQuizView)
        aboutQuizView.isHidden = true
        startQuizLabel.adjustsFontSizeToFitWidth = true
        addGestureOnStartQuizView()
        getDataFromServer()
    }
    
    private func addGestureOnStartQuizView(){
        nextQuizView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickedOnStartQuiz(sender:)))
        gesture.numberOfTapsRequired = 1
        nextQuizView.addGestureRecognizer(gesture)
    }
    
    private func gotoSummaryViewController(){
        if let quizSummaryVC = self.quizWelcomePresenter.getQuizSummaryViewController() {
            quizSummaryVC.correctAnswerCount = quizWelcomePresenter.getCorrectAnswerCount()
            quizSummaryVC.submissionTime = quizWelcomePresenter.getQuizSubmissionTime()
            quizSummaryVC.quizEndTime = quizWelcomePresenter.getQuizEndTime()
            quizSummaryVC.totalQuestionCount = quizWelcomePresenter.getTotalQuestionCount()
            quizSummaryVC.answers = quizWelcomePresenter.getQuizAnswers()
            self.navigationController?.pushViewController(quizSummaryVC, animated: true)
        }
    }
    
    @objc private func clickedOnStartQuiz(sender:UIGestureRecognizer){
        if isChallengeCompleted {
            gotoSummaryViewController()
        } else {
            if let targetVC = quizWelcomePresenter.getQuizViewController(),
                let _ = quizId {
                targetVC.quizId = quizId
                self.navigationController?.pushViewController(targetVC, animated: true)
            }
        }
    }
    
    private func getDataFromServer() {
        loadingController = AlertViewHelper(alertViewCallbackProtocol: nil).loadingAlertViewController(title: "Loading...", message: "\n\n")
        present(loadingController!, animated: true) { [weak self] in
            self?.quizWelcomePresenter.getDataFromServer()
        }
    }
    
    internal func onSuccess(isChallengeCompleted:Bool, aboutQuiz: AboutQuiz?) {
        loadingController?.dismiss(animated: false, completion: nil)
        aboutQuizView.isHidden = false
        self.isChallengeCompleted = isChallengeCompleted
        quizInfoLabel.text = aboutQuiz?.info ?? ""
        rewardLabel.text = aboutQuiz?.reward ?? ""
        if aboutQuiz != nil {
            timeInfoLabel.text = quizWelcomePresenter.getTimeInfoText(aboutQuiz: aboutQuiz!)
            quizId = aboutQuiz?.quizId
        } else {
            timeInfoLabel.text = ""
        }
        startQuizLabel.text = isChallengeCompleted ? "review_result".localizedStringWithVariables(vars: []) : "take_challenge".localizedStringWithVariables(vars: [])
    }
    
    internal override func onError(errorStatus: ResponseStatus, errorTitle: String, errorMessage: String) {
        loadingController?.dismiss(animated: false, completion: nil)
        super.onError(errorStatus: errorStatus, errorTitle: errorTitle, errorMessage: errorMessage)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
