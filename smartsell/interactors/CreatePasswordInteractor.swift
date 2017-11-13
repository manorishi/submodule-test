//
//  CreatePasswordInteractor.swift
//  smartsell
//
//  Created by Anurag Dake on 04/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Foundation
import Core

class CreatePasswordInteractor: SmartSellBaseInteractor{
    
    private let PARAM_USERNAME_KEY = "username"
    private let PARAM_SECURITYKEY_KEY = "security_key"
    private let PARAM_NEWPASSWORD_KEY = "new_password"
    
    func updateUserPassword(userName: String, securityKey: String, password: String, completionHandler:@escaping (_ status:Bool, _ userData:UserData?, _ errorTitle:String?,_ errorMsg:String?) -> ()) {
        NetworkService.sharedInstance.networkClient?.doPOSTRequest(requestURL: AppUrlConstants.updateUserPasswordUrl, params: nil, httpBody:[PARAM_USERNAME_KEY:userName as AnyObject, PARAM_SECURITYKEY_KEY: securityKey as AnyObject, PARAM_NEWPASSWORD_KEY: password as AnyObject],completionHandler: { [weak self] (responseStatus, response) in
            switch responseStatus {
            case .success:
                guard let userData = response?["user"] as? [String : AnyObject], let accessKeys = response?["token"] as? [String : AnyObject]  else {
                    completionHandler(false, nil, NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                    return
                }
                let userDataObj = UserData(userData: userData)
                userDataObj.userName = userName
                self?.saveUserData(userData: userDataObj)
                self?.saveAccessAndRefreshToken(data:accessKeys )
                self?.saveFavouriteData(response: response ?? [:])
                self?.saveAchievementData(response: response ?? [:])
                self?.saveShareCountData(response: response ?? [:])
                completionHandler(true, userDataObj,nil,nil)
            case .error:
                completionHandler(false, nil, NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
            default:
                completionHandler(false, nil, NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
            }
        })
    }
    
}
