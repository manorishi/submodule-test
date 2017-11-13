//
//  AccountInteractor.swift
//  smartsell
//
//  Created by Anurag Dake on 22/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Core

/**
 AccountInteractor fetches user data, achievemnets from keychain
 */
class AccountInteractor : SmartSellBaseInteractor{
    
    /**
     Get user data from keychain
     */
    func userData() -> UserData?{
        guard let userData = KeyChainService.sharedInstance.getData(key: ConfigKeys.USER_DATA_KEY),let userDataObj =  NSKeyedUnarchiver.unarchiveObject(with: userData) as? UserData else{
                return nil
        }
        return userDataObj
    }
    
    /**
     Retrive image from local cache
     */
    func retrieveImage(fileName: String) -> UIImage?{
        return AssetDownloaderService.sharedInstance.coreImageDownloader.retrieveImageFromDisk(filename: fileName)
    }
    
    /**
     Get all achievements
     */
    func achievements(achievementManager : AchievementManager) -> (marketingMaterialAchievements: [AchievementItem], fundSelectorAchievements: [AchievementItem]){
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            let userAchievementRepo = CoreDataService.sharedInstance.userAchievementRepo(context: managedObjectContext)
            let userAchievements: [UserAchievement] = userAchievementRepo.allUserAchievement()
            
            let achievementRepo = CoreDataService.sharedInstance.achievementRepo(context: managedObjectContext)
            let mmUserAchievemnets: [Achievement] = achievementRepo.allAchievements(type: .marketingMaterial)
            let fsUserAchievemnets: [Achievement] = achievementRepo.allAchievements(type: .fundSelector)
            
            
            let allAchievements = achievementManager.allAchievements(userAchievements: userAchievements, mmUserAchievemnets: mmUserAchievemnets, fsUserAchievemnets: fsUserAchievemnets)
            return (allAchievements.marketingMaterialAchievements, allAchievements.fundSelectorAchievements)
        }
        return ([], [])
    }
    
    
}
