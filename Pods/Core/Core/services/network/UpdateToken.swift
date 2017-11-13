//
//  UpdateToken.swift
//  Core
//
//  Created by Anurag Dake on 11/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 Update auth and refresh token in keychain.
 */
class UpdateToken {
    
    func updateTokens(with responsedata: [String : AnyObject]){
        let accesstoken = responsedata["token"]?["access_token"] as? String ?? ""
        let refreshToken = responsedata["token"]?["refresh_token"] as? String ?? ""
        KeyChainService.sharedInstance.setValue(string: accesstoken, key: ConfigKeys.ACCESS_TOKEN_KEY)
        KeyChainService.sharedInstance.setValue(string: refreshToken, key: ConfigKeys.REFRESH_TOKEN_KEY)
    }
    
}
