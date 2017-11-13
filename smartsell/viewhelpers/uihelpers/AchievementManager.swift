//
//  AchievementManager.swift
//  smartsell
//
//  Created by Anurag Dake on 18/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

/**
 AchievementManager manages all achievemnets related data such as getting all achievemnets items, latest achievement etc
 */
class AchievementManager{
    
    var mmAchievements: [AchievementItem]!
    var fsAchievements: [AchievementItem]!
    
    private let achievementImages = ["achievement_1", "achievement_2", "achievement_3", "achievement_4", "achievement_5"]
    private let achievementGreyImages = ["achievement_1_grey", "achievement_2_grey", "achievement_3_grey", "achievement_4_grey", "achievement_5_grey"]
    
    @discardableResult
    func allAchievements(userAchievements: [UserAchievement], mmUserAchievemnets:[Achievement], fsUserAchievemnets: [Achievement]) -> (marketingMaterialAchievements: [AchievementItem], fundSelectorAchievements: [AchievementItem]){
        
        mmAchievements = achievementItems(achievements: mmUserAchievemnets, type: .marketingMaterial).sorted { $0.level < $1.level }
        fsAchievements = achievementItems(achievements: fsUserAchievemnets, type: .fundSelector).sorted { $0.level < $1.level }
        
        updateAchievementData(userAchievements: userAchievements)
        updateNextAchievemnetData()
        return (mmAchievements, fsAchievements)
    }
    
    func latestAchievement(userAchievements: [UserAchievement]) -> AchievementItem?{
        guard userAchievements.count > 0 else {
            return nil
        }
        let sortedUserAchievements = userAchievements.sorted { (userAchievement1, userAchievement2) -> Bool in
            let date1 = userAchievement1.achieved_at as Date? ?? Date()
            let date2 = userAchievement2.achieved_at as Date? ?? Date()
            return date1.compare(date2) == .orderedDescending
        }
        
        let latestUserAchievement = sortedUserAchievements[0]
        if let latestAchievement = achievementWithLevel(achievementType: .marketingMaterial, level: latestUserAchievement.achievement_level - 100){
            return latestAchievement
        }else if let latestAchievement = achievementWithLevel(achievementType: .fundSelector, level: latestUserAchievement.achievement_level - 200){
            return latestAchievement
        }
        return nil
    }
    
    /**
     Create and return all achievements according to type provided
     */
    private func achievementItems(achievements: [Achievement], type: AchievementType) -> [AchievementItem]{
        var typeAchievements = [AchievementItem]()
        
        for achievement in achievements{
            let achievemnetItem = AchievementItem()
            achievemnetItem.name = achievement.name ?? ""
            achievemnetItem.level = level(achievementType: type, level: achievement.level)
            achievemnetItem.requiredActionCount = achievement.item_count
            let icons = achievementIcons(achievementType: type, level: achievement.level)
            achievemnetItem.achievedIcon = icons.achievedIcon
            achievemnetItem.nonAchievedIcon = icons.unAchievedIcon
            achievemnetItem.type = type
            typeAchievements.append(achievemnetItem)
        }
        return typeAchievements
    }
    
    private func level(achievementType: AchievementType, level: Int16) -> Int16{
        if level < 100{
            return 0
        }
        switch achievementType {
        case .marketingMaterial: return level - 100
        case .fundSelector: return level - 200
        }
    }
    
    private func achievementIcons(achievementType: AchievementType, level: Int16) -> (achievedIcon: UIImage, unAchievedIcon: UIImage){
        var index = 0
        switch achievementType {
        case .marketingMaterial: index = Int(level) - 101
        case .fundSelector: index = Int(level) - 201
        }
        if index >= 0 && index < 5{
            return (UIImage(named: achievementImages[index]) ?? UIImage(), UIImage(named: achievementGreyImages[index]) ?? UIImage())
        }else{
            return (UIImage(), UIImage())
        }
    }
    
    private func achievementWithLevel(achievementType: AchievementType, level: Int16) -> AchievementItem?{
        var achievementsToSearch: [AchievementItem]?
        switch achievementType {
        case .marketingMaterial: achievementsToSearch = mmAchievements
        case .fundSelector: achievementsToSearch = fsAchievements
        }
        
        for achievementItem in (achievementsToSearch ?? []){
            if achievementItem.level == level{
                return achievementItem
            }
        }
        return nil
    }
    
    private func updateAchievementData(userAchievements: [UserAchievement]){
        var mmCurrentAchievement: AchievementItem?
        var fsCurrentAchievement: AchievementItem?
        for userAchievement in userAchievements.sorted(by: { (achievement1, achievement2) -> Bool in
            achievement1.achievement_level < achievement2.achievement_level
        }){
            
            let level = userAchievement.achievement_level
            if level > 100 && level < 200 && ((mmAchievements?.count ?? 0) >= (Int(level) - 100)){
                if let achievementItem = achievementWithLevel(achievementType: .marketingMaterial, level: level - 100){
                    achievementItem.achievementDate = userAchievement.achieved_at as Date?
                    achievementItem.isAchieved = true
                    mmCurrentAchievement = achievementItem
                }
            }
            
            if level > 200 && level < 300 && ((mmAchievements?.count ?? 0) >= (Int(level) - 200)){
                if let achievementItem = achievementWithLevel(achievementType: .fundSelector, level: level - 200){
                    achievementItem.achievementDate = userAchievement.achieved_at as Date?
                    achievementItem.isAchieved = true
                    fsCurrentAchievement = achievementItem
                }
            }
        }
        mmCurrentAchievement?.isCurrentAchievement = true
        fsCurrentAchievement?.isCurrentAchievement = true
    }
    
    private func updateNextAchievemnetData(){
        for achievementItem in mmAchievements{
            if let nextAchievement = achievementWithLevel(achievementType: .marketingMaterial, level: achievementItem.level + 1){
                achievementItem.nextLevelName = nextAchievement.name
                achievementItem.nextLevelRequiredActionCount = nextAchievement.requiredActionCount
            }
        }
        for achievementItem in fsAchievements{
            if let nextAchievement = achievementWithLevel(achievementType: .marketingMaterial, level: achievementItem.level + 1){
                achievementItem.nextLevelName = nextAchievement.name
                achievementItem.nextLevelRequiredActionCount = nextAchievement.requiredActionCount
            }
        }
    }
    
    func mmAchievementWithRequiredActionCount(count: Int32) -> AchievementItem?{
        for achievemnetItem in mmAchievements{
            if achievemnetItem.requiredActionCount == count{
                return achievemnetItem
            }
        }
        return nil
    }
    
    func fsAchievementWithRequiredActionCount(count: Int32) -> AchievementItem?{
        for achievemnetItem in fsAchievements{
            if achievemnetItem.requiredActionCount == count{
                return achievemnetItem
            }
        }
        return nil
    }
    
}
