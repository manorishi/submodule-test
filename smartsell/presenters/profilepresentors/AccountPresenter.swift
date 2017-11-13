//
//  AccountPresenter.swift
//  smartsell
//
//  Created by Anurag Dake on 22/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

/**
 AccountPresenter handle UI logic for AccountViewController such as displaying user data
 */
class AccountPresenter: AccountProtocol{
    
    weak var accountViewController: AccountViewController!
    var accountInteractor: AccountInteractor!
    var userData: UserData?
    
    private let profileImagePlaceholder = "ic_profile_picutre_placeholder.png"
    private let EDIT_PROFILE_VIEWCONTROLLER = "EditProfileViewController"
    private let ACHIEVEMENTS_VIEWCONTROLLER = "AchievementsViewController"
    private let LEADERBOARD_VIEWCONTROLLER = "LeaderBoardViewController"
    private let NOTIFICATIONS_VIEWCONTROLLER = "NotificationsViewController"
    
    init(accountViewController: AccountViewController) {
        self.accountViewController = accountViewController
        accountInteractor = AccountInteractor()
    }
    
    func makeViewCircular(view: UIView) {
        accountViewController.view.layoutIfNeeded()
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
    }
    
    /**
     Set User data on ui elements
     */
    func updateProfileData(){
        guard let userData = accountInteractor.userData() else{
            return
        }
        self.userData = userData
        accountViewController.userNameLabel.text = userData.name ?? ""
        accountViewController.userMobileNumberLabel.text = userData.mobileNumber ?? ""
        if let profileImage = accountInteractor.retrieveImage(fileName: userData.profileImageName()){
            accountViewController.profilePicImageView.image = profileImage
        }else{
            accountViewController.profilePicImageView.image = UIImage(named: profileImagePlaceholder)
        }
    }
    
    func achievements(){
        let achievements = accountInteractor.achievements(achievementManager: accountViewController.achievementManager)
        accountViewController.marketingMaterialAchievements = achievements.marketingMaterialAchievements
        accountViewController.fundSelectorAchievements = achievements.fundSelectorAchievements
    }
    
    func currentAchievement(achievementType: AchievementType) -> AchievementItem?{
        var achievements: [AchievementItem]?
        switch achievementType {
        case .marketingMaterial: achievements = accountViewController.marketingMaterialAchievements
        case .fundSelector: achievements = accountViewController.fundSelectorAchievements
        }
        
        for achievement in (achievements ?? []){
            if achievement.isCurrentAchievement{
                return achievement
            }
        }
        return nil
    }
    
    func levelText(level: Int16) -> String{
        return "\("level".localized) \(level) of 5"
    }
    
    func nextLevelText(levelName: String) -> String{
        return "\("next_level".localized) : \(levelName)"
    }
    
    func totalShareCount() -> Int{
        return accountInteractor.totalShareCount()
    }
    
    func fundSelectorShareCount() -> Int{
        return accountInteractor.fundSelectorShareCount()
    }
    
    func date(from: Date?) -> String?{
        guard let date = from else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func achievementColor(achievementType: AchievementType) -> UIColor{
        switch achievementType {
        case .marketingMaterial: return hexStringToUIColor(hex: Colors.MARKETINGMATERIAL_ACHIEVEMENT_COLOR)
        case .fundSelector: return hexStringToUIColor(hex: Colors.FUNDSELECTOR_ACHIEVEMENT_COLOR)
        }
    }
    
    /**
     Add tap listernes on views in profile page
     */
    func addTapListenersToViews(){
        accountViewController.favouritesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFavouritesTap)))
        accountViewController.leaderBoardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLeaderBoardTap)))
        accountViewController.notificationsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onNotificationsTap)))
        accountViewController.marketingMaterialAchievementView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMarketingMaterialAchievementViewTap)))
        accountViewController.fundSelectorAchievementView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFundSelectorAchievementViewTap)))
    }
        
    @objc func onFavouritesTap(){
        accountViewController.tabBarController?.selectedIndex = 2
    }
    
    @objc func onLeaderBoardTap(){
        if let leaderboardViewController = accountViewController.storyboard?.instantiateViewController(withIdentifier: LEADERBOARD_VIEWCONTROLLER) as? LeaderBoardViewController{
            accountViewController.navigationController?.pushViewController(leaderboardViewController, animated: true)
        }
    }
    
    @objc func onNotificationsTap(){
        if let notificationsViewController = accountViewController.storyboard?.instantiateViewController(withIdentifier: NOTIFICATIONS_VIEWCONTROLLER) as? NotificationsViewController{
            accountViewController.navigationController?.pushViewController(notificationsViewController, animated: true)
        }
    }
    
    @objc func onMarketingMaterialAchievementViewTap(){
       gotoAchievementsPage(achievementType: .marketingMaterial, achievements: accountViewController.marketingMaterialAchievements)
    }
    
    @objc func onFundSelectorAchievementViewTap(){
       gotoAchievementsPage(achievementType: .fundSelector, achievements: accountViewController.fundSelectorAchievements)
    }
    
    private func gotoAchievementsPage(achievementType: AchievementType, achievements: [AchievementItem]?){
        if let achievementsViewController = accountViewController.storyboard?.instantiateViewController(withIdentifier: ACHIEVEMENTS_VIEWCONTROLLER) as? AchievementsViewController{
            achievementsViewController.achievementType = achievementType
            achievementsViewController.achievements = achievements
            
            switch achievementType {
            case .marketingMaterial:
                achievementsViewController.totalShares = accountViewController.totalShareCount
                achievementsViewController.currentAchievement = accountViewController.marketingMaterialCurrentAchievement
            case .fundSelector:
                achievementsViewController.totalShares = accountViewController.fundSelectorShareCount
                achievementsViewController.currentAchievement = accountViewController.fundSelectorCurrentAchievement
            }
            accountViewController.navigationController?.pushViewController(achievementsViewController, animated: true)
        }
    }
    
    func gotoEditProfilePage(){
        if let editProfileViewController = accountViewController.storyboard?.instantiateViewController(withIdentifier: EDIT_PROFILE_VIEWCONTROLLER) as? EditProfileViewController{
            editProfileViewController.userData = self.userData
            accountViewController.navigationController?.pushViewController(editProfileViewController, animated: true)
        }
    }
}
