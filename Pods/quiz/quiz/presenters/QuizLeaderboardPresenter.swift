//
//  LeaderboardPresenter.swift
//  quiz
//
//  Created by Sunil Sharma on 9/11/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit
import Core

protocol QuizLeaderboardPresenterDelegate:class {
    func onSuccess(dailyDatas:[QuizLeaderboard], weeklyDatas:[QuizLeaderboard],  monthlyDatas:[QuizLeaderboard])
    func onError(errorStatus:ResponseStatus, errorTitle:String, errorMessage:String)
}

class QuizLeaderboardPresenter:NSObject {
    
    weak var leaderboardVC:QuizLeaderboardViewController?
    weak var delegate:QuizLeaderboardPresenterDelegate?
    private var interactor:QuizLeaderboardInteractor!
    
    init(leaderboardViewController:QuizLeaderboardViewController) {
        self.leaderboardVC = leaderboardViewController
        interactor = QuizLeaderboardInteractor()
    }
    
    func getLeaderboardDataFromServer(userId:Int) {
        interactor.getLeaderboardDataFromServer(userId: userId , onSuccess: { (dailyDatas, weeklyDatas, monthlyDatas) in
            self.delegate?.onSuccess(dailyDatas: dailyDatas, weeklyDatas: weeklyDatas, monthlyDatas: monthlyDatas)
        }) {[weak self] (status, errorTitle, errorMessage) in
            self?.delegate?.onError(errorStatus: status, errorTitle: errorTitle, errorMessage: errorMessage)
        }
    }
    
    private func createChallengeScrollView(frame:CGRect, challengeType:ChallengeType) -> UIScrollView {
        let scrollView = UIScrollView(frame: frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }
    
    func getLastViewFrame(view:UIView) -> CGRect{
        var frame:CGRect = CGRect.zero
        let innerSubViews = view.subviews
        if innerSubViews.count > 0 {
            let innerView = innerSubViews[innerSubViews.count - 1]
            frame = innerView.frame
        }
        return frame
    }
    
    private func getDailyChallengeTitle(title:String, startTime:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: startTime)
        dateFormatter.dateFormat = "dd MMM"
        return title + ", \(dateFormatter.string(from: date ?? Date()))"
    }
    
    private func getChallengeHeaderView(challengeType:ChallengeType, bundle:Bundle,title:String) ->  LeaderboardHeader{
        let header = bundle.loadNibNamed("LeaderboardHeader", owner: self, options: nil)?[0] as! LeaderboardHeader
        header.titleLabel.text = title
        switch challengeType {
        case .daily:
            header.backgroundColor = .white
            header.bottomRightLabel.text = "completed_at".localized
        case .weekly:
            header.backgroundColor = QuizColors.leaderboardWeeklyBg
            header.bottomRightLabel.text = "score".localized
        case .monthly:
            header.backgroundColor = QuizColors.leaderboardMonthlyBg
            header.bottomRightLabel.text = "score".localized
        }
        
        return header
    }
    
    func getChallengeScrollView(challengeDatas:[QuizLeaderboard], frame:CGRect, challengeType:ChallengeType) -> UIScrollView {
        let scrollView = createChallengeScrollView(frame: frame, challengeType: challengeType)
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder){
            let columnWidth = scrollView.frame.width * 0.8
            var headerX:CGFloat = 8
            var maxHeight:CGFloat = 62
            for (index, quizLeaderboard) in challengeDatas.enumerated() {
                let header = getChallengeHeaderView(challengeType: challengeType, bundle: bundle, title: quizLeaderboard.title)
                header.frame = CGRect(x: headerX, y: 0, width: columnWidth - 16, height: header.frame.height)
                scrollView.addSubview(header)
                var previousRowFrame = CGRect.zero
                for (index, user) in quizLeaderboard.users.enumerated() {
                    let userRow = getChallengeUserRow(bundle: bundle, user: user)
                    if index == 0 {
                        updateUserFirstRow(leaderboardRow: userRow)
                        userRow.frame = CGRect(x: headerX - 4, y: header.frame.origin.y + header.frame.height, width: columnWidth - 8, height: userRow.frame.height)
                    } else {
                        updateUserOtherRow(leaderboardRow: userRow, challengeType: challengeType)
                        userRow.frame = CGRect(x: headerX, y: previousRowFrame.origin.y + previousRowFrame.height, width: columnWidth - 16, height: userRow.frame.height)
                    }
                    scrollView.addSubview(userRow)
                    previousRowFrame = userRow.frame
                }
                let currentColumnHeight = previousRowFrame.origin.y + previousRowFrame.height
                maxHeight = currentColumnHeight > maxHeight ? currentColumnHeight : maxHeight
                headerX = (columnWidth * CGFloat(index + 1)) + 8
            }
            scrollView.frame.size.height = maxHeight
            scrollView.contentSize = CGSize(width: headerX - 8, height: maxHeight)
        }
        return scrollView
    }
    
    func getDailyChallenge(dailyDatas:[QuizLeaderboard], frame:CGRect) -> UIScrollView {
        let scrollView = createChallengeScrollView(frame: frame, challengeType: .daily)
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder){
            let columnWidth = scrollView.frame.width * 0.8
            var headerX:CGFloat = 8
            var maxHeight:CGFloat = 62
            for (index, quizLeaderboard) in dailyDatas.enumerated() {
                let header = getChallengeHeaderView(challengeType: .daily, bundle: bundle, title: getDailyChallengeTitle(title: quizLeaderboard.title, startTime: quizLeaderboard.startTime))
                header.frame = CGRect(x: headerX, y: 0, width: columnWidth - 16, height: header.frame.height)
                scrollView.addSubview(header)
                var previousRowFrame = CGRect.zero
                for (index, user) in quizLeaderboard.users.enumerated() {
                    let userRow = getDailyUserRow(bundle: bundle, totalQuestion: quizLeaderboard.totalQuestion, user: user)
                    if index == 0 {
                        updateDailyUserFirstRow(dailyChallengeRow: userRow)
                        userRow.frame = CGRect(x: headerX - 4, y: header.frame.origin.y + header.frame.height, width: columnWidth - 8, height: userRow.frame.height)
                    } else {
                        updateDailyUserOtherRow(dailyChallengeRow: userRow)
                        userRow.frame = CGRect(x: headerX, y: previousRowFrame.origin.y + previousRowFrame.height, width: columnWidth - 16, height: userRow.frame.height)
                    }
                    scrollView.addSubview(userRow)
                    previousRowFrame = userRow.frame
                }
                let currentColumnHeight = previousRowFrame.origin.y + previousRowFrame.height
                maxHeight = currentColumnHeight > maxHeight ? currentColumnHeight : maxHeight
                headerX = (columnWidth * CGFloat(index + 1)) + 8
            }
            scrollView.frame.size.height = maxHeight
            scrollView.contentSize = CGSize(width: headerX - 8, height: maxHeight)
        }
        return scrollView
    }
    
    func getDailyUserRow(bundle:Bundle,totalQuestion:Int, user:User) -> DailyChallengeRow {
        let dateFormatter = DateFormatter()
        let timeFormat = "HH:mm:ss"
        let timeDateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = timeDateFormat
        let userRow = bundle.loadNibNamed("DailyChallengeRow", owner: self, options: nil)?[0] as! DailyChallengeRow
        userRow.titleLabel.text = user.name
        userRow.scoreLabel.text = "\(user.score) of \(totalQuestion)"
        dateFormatter.dateFormat = timeDateFormat
        let date = dateFormatter.date(from: user.completedAt)
        dateFormatter.dateFormat = timeFormat
        userRow.completedAt.text = dateFormatter.string(from: date ?? Date())
        userRow.rankLabel.text = "\(user.rank)"
        return userRow
    }
    
    func getChallengeUserRow(bundle:Bundle, user:User) -> LeaderboardRow {
        let userRow = bundle.loadNibNamed("LeaderboardRow", owner: self, options: nil)?[0] as! LeaderboardRow
        userRow.titleLabel.text = user.name
        userRow.scoreLabel.text = "\(user.score)"
        userRow.rankLabel.text = "\(user.rank)"
        return userRow
    }
    
    func updateUserFirstRow(leaderboardRow:LeaderboardRow) {
        leaderboardRow.backgroundColor = QuizColors.topRankBackground
        leaderboardRow.titleLabel.textColor = .white
        leaderboardRow.scoreLabel.textColor = .white
        leaderboardRow.winnerCupImageView.isHidden = false
        leaderboardRow.leftIconView.backgroundColor = hexStringToUIColor(hex: "71203D")
        leaderboardRow.rankLabel.isHidden = true
    }
    
    func updateUserOtherRow(leaderboardRow:LeaderboardRow , challengeType:ChallengeType) {
        leaderboardRow.titleLabel.textColor = .black
        leaderboardRow.scoreLabel.textColor = .black
        leaderboardRow.winnerCupImageView.isHidden = true
        leaderboardRow.rankLabel.isHidden = false
        switch challengeType {
        case .weekly:
            leaderboardRow.backgroundColor = QuizColors.leaderboardWeeklyBg
            leaderboardRow.leftIconView.backgroundColor = .clear
        case .monthly:
            leaderboardRow.backgroundColor = QuizColors.leaderboardMonthlyBg
            leaderboardRow.leftIconView.backgroundColor = .clear
        default:
            leaderboardRow.backgroundColor = .white
            leaderboardRow.leftIconView.backgroundColor = .white
        }
    }
    
    func updateDailyUserFirstRow(dailyChallengeRow:DailyChallengeRow) {
        dailyChallengeRow.backgroundColor = QuizColors.topRankBackground
        dailyChallengeRow.titleLabel.textColor = .white
        dailyChallengeRow.scoreLabel.textColor = .white
        dailyChallengeRow.completedAt.textColor = .white
        dailyChallengeRow.winnerCupImageView.isHidden = false
        dailyChallengeRow.leftIconView.backgroundColor = hexStringToUIColor(hex: "71203D")
        dailyChallengeRow.rankLabel.isHidden = true
    }
    
    func updateDailyUserOtherRow(dailyChallengeRow:DailyChallengeRow) {
        dailyChallengeRow.backgroundColor = .white
        dailyChallengeRow.titleLabel.textColor = .black
        dailyChallengeRow.scoreLabel.textColor = .black
        dailyChallengeRow.completedAt.textColor = .black
        dailyChallengeRow.winnerCupImageView.isHidden = true
        dailyChallengeRow.leftIconView.backgroundColor = .white
        dailyChallengeRow.rankLabel.isHidden = false
    }
    
    func getHeaderLabel(title:String, frame:CGRect) -> UILabel{
        let label = UILabel(frame: frame)
        label.text = title
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }
}
