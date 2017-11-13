//
//  BaseInteractor.swift
//  smartsell
//
//  Created by Anurag Dake on 21/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

/**
 SmartSellBaseInteractor is base interactor to implement common functionality such as saving achievemnets, getting share count 
 */
class SmartSellBaseInteractor{
    
    func saveUserAchievemnet(level: Int16, isSynced: Bool){
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            let userAchievementRepo = CoreDataService.sharedInstance.userAchievementRepo(context: managedObjectContext)
            var userAchievemnet = [String:Any]()
            userAchievemnet["achievement_level"] = level
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            userAchievemnet["achieved_at"] = dateFormatter.string(from: Date())
            userAchievementRepo.addUserAchievement(userAchievement: userAchievemnet, isSynced: isSynced)
        }
        
    }
    
    /**
     Get total share count
     */
    func totalShareCount() -> Int{
        let posterShareCount = Int(KeyChainService.sharedInstance.getValue(key: ConfigKeys.POSTER_COUNT_KEY) ?? "0") ?? 0
        let videoShareCount = Int(KeyChainService.sharedInstance.getValue(key: ConfigKeys.VIDEO_COUNT_KEY) ?? "0") ?? 0
        let pdfShareCount = Int(KeyChainService.sharedInstance.getValue(key: ConfigKeys.PDF_COUNT_KEY) ?? "0") ?? 0
        return (posterShareCount + videoShareCount + pdfShareCount)
    }
    
    func fundSelectorShareCount() -> Int{
        return Int(KeyChainService.sharedInstance.getValue(key: ConfigKeys.PRESENTATION_COUNT_KEY) ?? "0") ?? 0
    }
    
    func saveFavouriteData(response:[String:AnyObject]) {
        guard let favouriteData = response["user_favorites"] as? [[String : AnyObject]]
            else {
                return
        }
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            let favouriteRepo = CoreDataService.sharedInstance.favouriteRepo(context: managedObjectContext)
            favouriteRepo.createFavourites(favouritesArray: favouriteData)
        }
    }
    
    func saveAchievementData(response:[String:AnyObject]) {
        guard let achievementData = response["user_achievements"] as? [[String : AnyObject]] else {
            return
        }
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            let achievementRepo = CoreDataService.sharedInstance.userAchievementRepo(context: managedObjectContext)
            achievementRepo.createUserAchievement(userAchievementsArray: achievementData)
        }
    }
    
    func saveShareCountData(response:[String:AnyObject]){
        guard let userShareData = response["user_share_data"] as? [String : AnyObject] else {
            return
        }
        let postersShareCount = String(userShareData["posters_shared"] as? Int ?? 0)
        let videosShareCount = String(userShareData["videos_shared"] as? Int ?? 0)
        let pdfsShareCount = String(userShareData["pdfs_shared"] as? Int ?? 0)
        let presentationsShareCount = String(userShareData["presentations_shared"] as? Int ?? 0)
        KeyChainService.sharedInstance.setValue(string: postersShareCount, key: ConfigKeys.POSTER_COUNT_KEY)
        KeyChainService.sharedInstance.setValue(string: videosShareCount, key: ConfigKeys.VIDEO_COUNT_KEY)
        KeyChainService.sharedInstance.setValue(string: pdfsShareCount, key: ConfigKeys.PDF_COUNT_KEY)
        KeyChainService.sharedInstance.setValue(string: presentationsShareCount, key: ConfigKeys.PRESENTATION_COUNT_KEY)
    }
    
    
    func saveUserData(userData:UserData) {
        let saveData = NSKeyedArchiver.archivedData(withRootObject: userData)
        KeyChainService.sharedInstance.setValue(data: saveData, key: ConfigKeys.USER_DATA_KEY)
        AssetDownloaderService.sharedInstance.coreImageDownloader.downloadImage(url: userData.profileImageUrl ?? "", filename: userData.profileImageName()) { (status) in
            print("Profile image download:\(status)")
        }
    }
    
    func saveAccessAndRefreshToken(data:[String:AnyObject]) {
        if let accessToken = data["access_token"] as? String {
            KeyChainService.sharedInstance.setValue(string: accessToken, key: ConfigKeys.ACCESS_TOKEN_KEY)
        }
        
        if let refreshToken = data["refresh_token"] as? String {
            KeyChainService.sharedInstance.setValue(string: refreshToken, key: ConfigKeys.REFRESH_TOKEN_KEY)
        }
    }

}
