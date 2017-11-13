//
//  AchievementsPresenter.swift
//  smartsell
//
//  Created by Anurag Dake on 13/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

/**
 AchievementsPresenter handle UI logic for AchievementsViewController
 */
class AchievementsPresenter: AchievementsProtocol{
    weak var achievementsViewController: AchievementsViewController!
    
    init(achievementsViewController: AchievementsViewController) {
        self.achievementsViewController = achievementsViewController
    }
    
    func achievementTypeName(achievementType: AchievementType) -> String{
        switch achievementType {
        case .marketingMaterial: return "marketing_materials".localized
        case .fundSelector: return "fund_selector".localized
        }
    }
    
    func achievementLevelWithName() -> String{
        if let currentAchievement = achievementsViewController.currentAchievement{
            return "\("level".localized) \(currentAchievement.level!) : \(currentAchievement.name!)"
        }
        return "no_achievement_message".localized
    }
    
    func nextLevelText(achievementType: AchievementType) -> String{
        guard let currentAchievement = achievementsViewController.currentAchievement else {
            var requiredActionCount = 0
            
            if let achievements = achievementsViewController.achievements, achievements.count > 0{
                switch achievementType {
                case .marketingMaterial: requiredActionCount = Int(achievements[0].requiredActionCount ?? 5)
                case .fundSelector: requiredActionCount = Int(achievements[0].requiredActionCount ?? 2)
                    
                }
            }
            return "\("next_level".localized) : \(requiredActionCount)"
        }
        
        if currentAchievement.level == 5{
            return ""
        }else{
            return "\("next_level".localized) : \(currentAchievement.nextLevelRequiredActionCount!)"
        }
    }
    
    func date(from: Date?) -> String?{
        guard let date = from else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func onbackButtonPress(){
        _ = achievementsViewController.navigationController?.popViewController(animated: true)
    }
}
