//
//  QuizSummaryViewController.swift
//  quiz
//
//  Created by Sunil Sharma on 9/7/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit

class QuizSummaryViewController: UIViewController {

    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var resultTimeLabel: UILabel!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var answersView: UIButton!
    
    private var quizSummaryPresenter:QuizSummaryPresenter!
    
    public var totalQuestionCount:Int!
    public var correctAnswerCount:Int!
    public var answers:String!
    public var submissionTime:Double!
    public var quizEndTime:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup(){
        quizSummaryPresenter = QuizSummaryPresenter(quizSummaryViewController: self)
        homeView.clipsToBounds = true
        homeView.layer.cornerRadius = homeView.frame.height / 2
        
        answersView.clipsToBounds = true
        answersView.layer.cornerRadius = answersView.frame.height / 2
        
        self.modalPresentationStyle = .popover
        
        quizSummaryPresenter.configureViews()
        suggestionLabel.text = quizSummaryPresenter.getPerformanceRemark()
        scoreLabel.text = quizSummaryPresenter.getScoreAndQuizEndTime()
        resultTimeLabel.text = quizSummaryPresenter.getResultTime()
        addGestureOnHomeView()
    }
    
    private func addGestureOnHomeView(){
        homeView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gotoHomeController(sender:)))
        gesture.numberOfTapsRequired = 1
        homeView.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickedOnViewAnswers(_ sender: Any) {
        
        let alertViewController = UIAlertController(title: "answer".localized, message: answers, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "ok".localized, style: .default) { (alertAction) in
            UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
            alertViewController.dismiss(animated: true, completion: nil)
        }
        alertViewController.addAction(cancel)
        alertViewController.setValue(quizSummaryPresenter.getAnswersAttributedString(answers), forKey: "attributedMessage")
        alertViewController.view.frame = UIScreen.main.bounds
        alertViewController.view.frame.size.height -= 100
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelStatusBar
        present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func gotoHomeController(sender:UIGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }

}
