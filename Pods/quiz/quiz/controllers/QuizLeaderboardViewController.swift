//
//  LeaderboardViewController.swift
//  quiz
//
//  Created by Sunil Sharma on 9/11/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit
import Core

public class QuizLeaderboardViewController: QuizBaseViewController, QuizLeaderboardPresenterDelegate {

    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollContentView: UIView!
    
    private var presenter:QuizLeaderboardPresenter!
    private var loadingController:UIAlertController?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup(){
        self.edgesForExtendedLayout = []
        presenter = QuizLeaderboardPresenter(leaderboardViewController: self)
        presenter.delegate = self
        getDataFromServer()
    }
    
    func getDataFromServer() {
        let userData = KeyChainService.sharedInstance.getData(key: ConfigKeys.USER_DATA_KEY)
        if let userDataObj = NSKeyedUnarchiver.unarchiveObject(with: userData ?? Data()) as? UserData {
            loadingController = AlertViewHelper(alertViewCallbackProtocol: nil).loadingAlertViewController(title: "Loading...", message: "\n\n")
            present(loadingController!, animated: true) { [weak self] in
                self?.presenter.getLeaderboardDataFromServer(userId: userDataObj.userTypeId ?? -1)
            }
        }
    }
    
    func onSuccess(dailyDatas: [QuizLeaderboard], weeklyDatas: [QuizLeaderboard], monthlyDatas: [QuizLeaderboard]) {
        loadingController?.dismiss(animated: true, completion: nil)
        addDailyChallenge(dailyDatas: dailyDatas)
        addWeeklyChallenge(weeklyDatas: weeklyDatas)
        addMontlyChallenge(monthlyDatas: monthlyDatas)
    }
    
    func addDailyChallenge(dailyDatas: [QuizLeaderboard]) {
        if dailyDatas.count > 0 {
            let header = presenter.getHeaderLabel(title: "daily_challenge".localized, frame: CGRect(x: 8, y: 4, width: self.view.frame.width, height: 25))
            scrollContentView.addSubview(header)
            let scrollview = presenter.getDailyChallenge(dailyDatas: dailyDatas, frame: CGRect(x: 0, y: header.frame.origin.y + header.frame.height + 5, width: self.view.frame.width, height: 0))
            scrollContentView.addSubview(scrollview)
            contentViewHeightConstraint.constant = scrollview.frame.origin.y + scrollview.frame.height
        }
    }
    
    func addWeeklyChallenge(weeklyDatas: [QuizLeaderboard]) {
        if weeklyDatas.count > 0 {
            var frame = presenter.getLastViewFrame(view: scrollContentView)
            let header = presenter.getHeaderLabel(title: "weekly_challenge".localized, frame: CGRect(x: 8, y: frame.origin.y + frame.height + 16, width: self.view.frame.width, height: 25))
            scrollContentView.addSubview(header)
            frame = CGRect(x: 0, y: header.frame.origin.y + header.frame.height + 5, width: self.view.frame.width, height: 0)
            let scrollview = presenter.getChallengeScrollView(challengeDatas: weeklyDatas, frame: frame, challengeType: .weekly)
            scrollContentView.addSubview(scrollview)
            contentViewHeightConstraint.constant = scrollview.frame.origin.y + scrollview.frame.height
        }
    }
    
    func addMontlyChallenge(monthlyDatas: [QuizLeaderboard]) {
        if monthlyDatas.count > 0 {
            var frame = presenter.getLastViewFrame(view: scrollContentView)
            let header = presenter.getHeaderLabel(title: "monthly_challenge".localized, frame: CGRect(x: 8, y: frame.origin.y + frame.height + 16, width: self.view.frame.width, height: 25))
            scrollContentView.addSubview(header)
            frame = CGRect(x: 0, y: header.frame.origin.y + header.frame.height + 5, width: self.view.frame.width, height: 0)
            let scrollview = presenter.getChallengeScrollView(challengeDatas: monthlyDatas, frame: frame, challengeType: .monthly)
            scrollContentView.addSubview(scrollview)
            contentViewHeightConstraint.constant = scrollview.frame.origin.y + scrollview.frame.height
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func onError(errorStatus: ResponseStatus, errorTitle: String, errorMessage: String) {
        loadingController?.dismiss(animated: true, completion: nil)
        super.onError(errorStatus: errorStatus, errorTitle: errorTitle, errorMessage: errorMessage)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
