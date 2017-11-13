//
//  AccountViewController.swift
//  smartsell
//
//  Created by Anurag Dake on 22/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

protocol AccountProtocol {
    func gotoEditProfilePage()
}

/**
 AccountViewController displays user account details, user achievemnets
 */
class AccountViewController: UIViewController {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMobileNumberLabel: UILabel!
    @IBOutlet weak var favouritesView: UIView!
    @IBOutlet weak var leaderBoardView: UIView!
    @IBOutlet weak var notificationsView: UIView!
    @IBOutlet weak var marketingMaterialAchievementView: UIView!
    @IBOutlet weak var fundSelectorAchievementView: UIView!
    
    //Achievement Outlets
    @IBOutlet weak var marketimgMaterialView: UIView!
    @IBOutlet weak var mmAchievementIconImageView: UIImageView!
    @IBOutlet weak var mmAchievementNameLabel: UILabel!
    @IBOutlet weak var mmLevelLabel: UILabel!
    @IBOutlet weak var mmShareCountLabel: UILabel!
    @IBOutlet weak var mmAchievementDateLabel: UILabel!
    @IBOutlet weak var mmNextLevelLabel: UILabel!
    
    @IBOutlet weak var fundSelectorView: UIView!
    @IBOutlet weak var fsAchievementIconImageView: UIImageView!
    @IBOutlet weak var fsAchievementNameLabel: UILabel!
    @IBOutlet weak var fsLevelLabel: UILabel!
    @IBOutlet weak var fsSelectCountLabel: UILabel!
    @IBOutlet weak var fsAchievementDateLabel: UILabel!
    @IBOutlet weak var fsNextLevelLabel: UILabel!
    
    var eventHandler : AccountProtocol!
    var accountPresenter : AccountPresenter!
    let achievementManager = AchievementManager()
    var marketingMaterialAchievements: [AchievementItem]?
    var fundSelectorAchievements: [AchievementItem]?
    var marketingMaterialCurrentAchievement: AchievementItem?
    var fundSelectorCurrentAchievement: AchievementItem?
    var totalShareCount = 0
    var fundSelectorShareCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountPresenter = AccountPresenter(accountViewController: self)
        self.eventHandler = accountPresenter
        initialiseUI()
        addNotificationObservers()
        updateAchievementsViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accountPresenter.updateProfileData()
    }
    
    /**
     Adding notification for share count, presentation share, achievement level increase, achievement data update.
     */
    private func addNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.onShareCountUpdate(notification:)), name: AppNotificationConstants.SHARE_COUNT_UPDATE_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.onPresentationShareCountUpdate(notification:)), name: AppNotificationConstants.PRESENTATION_SHARE_COUNT_UPDATE_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.onAchievementLevelIncrease(notification:)), name: AppNotificationConstants.ACHIEVEMENT_LEVEL_INCREASE_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.onAchievementDataUpdate(notification:)), name: AppNotificationConstants.ACHIEVEMENT_DATA_UPDATE_NOTIFICATION, object: nil)
    }
    
    @objc private func onShareCountUpdate(notification: NSNotification){
        updateAchievementsViews()
    }
    
    @objc private func onPresentationShareCountUpdate(notification: NSNotification){
        updateAchievementsViews()
    }
    
    func onAchievementLevelIncrease(notification: NSNotification) {
        updateAchievementsViews()
    }
    
    @objc private func onAchievementDataUpdate(notification: NSNotification){
        updateAchievementsViews()
    }
    
    func initialiseUI(){
        accountPresenter.addTapListenersToViews()
        accountPresenter.makeViewCircular(view: profilePicImageView)
        accountPresenter.makeViewCircular(view: editButton)
    }
    
    func updateAchievementsViews(){
        accountPresenter.achievements()
        totalShareCount = accountPresenter.totalShareCount()
        fundSelectorShareCount = accountPresenter.fundSelectorShareCount()
        marketingMaterialCurrentAchievement = accountPresenter.currentAchievement(achievementType: .marketingMaterial)
        fundSelectorCurrentAchievement = accountPresenter.currentAchievement(achievementType: .fundSelector)
        showMarketimgMaterialAchievementData()
        showFundSelectorAchievementData()
    }
    
    func showMarketimgMaterialAchievementData(){
        guard let mmAchievement = marketingMaterialCurrentAchievement else{
            return
        }
        marketimgMaterialView.backgroundColor = accountPresenter.achievementColor(achievementType: .marketingMaterial)
        mmAchievementIconImageView.image = mmAchievement.achievedIcon
        mmAchievementNameLabel.text = mmAchievement.name
        mmAchievementNameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        mmLevelLabel.text = accountPresenter.levelText(level: mmAchievement.level)
        mmShareCountLabel.text = "\(totalShareCount) \("shared".localized)"
        mmAchievementDateLabel.text = accountPresenter.date(from: mmAchievement.achievementDate)
        mmNextLevelLabel.text = accountPresenter.nextLevelText(levelName: mmAchievement.nextLevelName)
    }
    
    func showFundSelectorAchievementData(){
        guard let fsAchievement = fundSelectorCurrentAchievement else{
            return
        }
        fundSelectorView.backgroundColor = accountPresenter.achievementColor(achievementType: .fundSelector)
        fsAchievementIconImageView.image = fsAchievement.achievedIcon
        fsAchievementNameLabel.text = fsAchievement.name
        fsAchievementNameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        fsLevelLabel.text = accountPresenter.levelText(level: fsAchievement.level)
        fsSelectCountLabel.text = "\(fundSelectorShareCount) \("shared".localized)"
        fsAchievementDateLabel.text = accountPresenter.date(from: fsAchievement.achievementDate)
        fsNextLevelLabel.text =  accountPresenter.nextLevelText(levelName: fsAchievement.nextLevelName) 
    }
    
    @IBAction func onEditTap(_ sender: UIButton) {
        eventHandler.gotoEditProfilePage()
    }
    
    deinit{
        ///Remove notifcation observers
        NotificationCenter.default.removeObserver(self, name: AppNotificationConstants.SHARE_COUNT_UPDATE_NOTIFICATION, object: nil)
        NotificationCenter.default.removeObserver(self, name: AppNotificationConstants.PRESENTATION_SHARE_COUNT_UPDATE_NOTIFICATION, object: nil)
        NotificationCenter.default.removeObserver(self, name: AppNotificationConstants.ACHIEVEMENT_LEVEL_INCREASE_NOTIFICATION, object: nil)
        NotificationCenter.default.removeObserver(self, name: AppNotificationConstants.ACHIEVEMENT_DATA_UPDATE_NOTIFICATION, object: nil)
    }
}
