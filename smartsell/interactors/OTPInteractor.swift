//
//  OTPInteractor.swift
//  smartsell
//
//  Created by Apple on 07/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Foundation
import Core

/**
 OTPInteractor contains api call to verify opt and save user data in keychain/db
 */
class OTPInteractor {
    
    private let PARAM_MOBILE_NO_KEY = "mobile_number"
    private let PARAM_RE_CHECK_KEY = "re_check"
    private let PARAM_OTP_KEY = "otp"
    
    func otpVerification(otpCode:String,mobileNo:String, completionHandler:@escaping (_ status:Bool,_ userData:UserData?,_ errorTitle:String?,_ errorMsg:String?) -> ()) {
        NetworkService.sharedInstance.networkClient?.doPOSTRequest(requestURL: AppUrlConstants.otpVerificationUrl, params: nil, httpBody:[PARAM_MOBILE_NO_KEY:mobileNo as AnyObject,PARAM_OTP_KEY:otpCode as AnyObject],completionHandler: {[weak self] (responseStatus, response) in
            DispatchQueue.main.async {
                print(response ?? [])
                switch responseStatus {
                case .success:
                    guard let userData = response?["user"] as? [String : AnyObject], let accessKeys = response?["token"] as? [String : AnyObject]  else {
                        completionHandler(false, nil, NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                        return
                    }
                    let userDataObj = UserData(userData: userData)
                    self?.saveUserData(userData: userDataObj)
                    self?.saveAccessAndRefreshToken(data:accessKeys )
                    self?.saveFavouriteData(response: response ?? [:])
                    self?.saveAchievementData(response: response ?? [:])
                    self?.saveShareCountData(response: response ?? [:])
                    completionHandler(true, userDataObj,nil,nil)
                case .error:
                    completionHandler(false,nil,NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                default:
                    completionHandler(false, nil, NetworkUtils.errorTitle(response: nil),NetworkUtils.errorMessage(response: nil))
                }
            }
        })
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
    
    func verifyMobileNumber(mobileNumber:String,completionHandler:@escaping (_ status:Bool,_ errorTitle:String?,_ errorMsg:String?) -> ()) {
        
        NetworkService.sharedInstance.networkClient?.doPOSTRequest(requestURL: AppUrlConstants.mobileVerificationUrl, params: nil, httpBody:[PARAM_MOBILE_NO_KEY:mobileNumber as AnyObject,PARAM_RE_CHECK_KEY:1 as AnyObject],completionHandler: { (responseStatus, response) in
            DispatchQueue.main.async {
                switch responseStatus {
                case .success:
                    completionHandler(true,nil,nil)
                case .error:
                    completionHandler(false,NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                default:
                    completionHandler(false,NetworkUtils.errorTitle(response: nil),NetworkUtils.errorMessage(response: nil))
                }
            }
        })
    }
}
