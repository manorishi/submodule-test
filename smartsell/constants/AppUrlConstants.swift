//
//  AppUrlConstants.swift
//  smartsell
//
//  Created by Apple on 07/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Foundation
import Core

/**
 Conatins App urls
 */
struct AppUrlConstants {
    static let mobileVerificationUrl = URLConstants.BASE_URL + "/checkMobileNumber"
    static let otpVerificationUrl = URLConstants.BASE_URL + "/verifyOTP"
    static let updateUserDetails = URLConstants.BASE_URL + "/updateUserDetails"
    static let updateProfilePic = URLConstants.BASE_URL + "/updateProfileImage"
    static let updateSignature = URLConstants.BASE_URL + "/updateSignature"
    static let updateEmail = URLConstants.BASE_URL + "/updateEmail"
    static let updateUserName = URLConstants.BASE_URL + "/updateName"
    static let leaderboardData = URLConstants.BASE_URL + "/getLeaderboardData"
    static let announcementData = URLConstants.BASE_URL + "/getAnnouncement"
    static let addUserAchievemnetsUrl = URLConstants.BASE_URL + "/addUserAchievements"
    static let updateFCM = URLConstants.BASE_URL + "/updateFCM"
    static let iOSAppDetails = URLConstants.BASE_URL + "/getIOSAppDetails"
    
    //Latest Urls
    static let userNameVerificationUrl = URLConstants.BASE_URL + "/checkUserExists"
    static let verifyUserSecurityUrl = URLConstants.BASE_URL + "/verfyUserSecurity"
    static let updateUserPasswordUrl = URLConstants.BASE_URL + "/updateUserPassword"
    static let resendPasswordUrl = URLConstants.BASE_URL + "/resendPassword"
    static let verifyUserPasswordUrl = URLConstants.BASE_URL + "/verifyUserPassword"
    
}
