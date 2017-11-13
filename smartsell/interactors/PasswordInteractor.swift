//
//  PasswordInteractor.swift
//  smartsell
//
//  Created by Anurag Dake on 04/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Foundation
import Core

class PasswordInteractor: SmartSellBaseInteractor{
    
    private let PARAM_USERNAME_KEY = "username"
    private let PARAM_PASSWORD_KEY = "password"
    
    func verifyUserPassword(userName: String, password: String, completionHandler:@escaping (_ status:Bool, _ userData:UserData?, _ errorTitle:String?,_ errorMsg:String?) -> ()) {
        NetworkService.sharedInstance.networkClient?.doPOSTRequest(requestURL: AppUrlConstants.verifyUserPasswordUrl, params: nil, httpBody:[PARAM_USERNAME_KEY:userName as AnyObject, PARAM_PASSWORD_KEY: password as AnyObject],completionHandler: { [weak self] (responseStatus, response) in
            DispatchQueue.main.async {
                switch responseStatus {
                case .success:
                    print("verifyUserPassword success")
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
                    completionHandler(false,nil,NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                default:
                    completionHandler(false, nil, NetworkUtils.errorTitle(response: nil),NetworkUtils.errorMessage(response: nil))
                }
            }
        })
    }
    
    func resend(userName: String, completionHandler:@escaping (_ status:Bool, _ errorTitle:String?, _ message:String?) -> ()) {
        NetworkService.sharedInstance.networkClient?.doPOSTRequest(requestURL: AppUrlConstants.resendPasswordUrl, params: nil, httpBody:[PARAM_USERNAME_KEY:userName as AnyObject],completionHandler: { (responseStatus, response) in
            switch responseStatus {
            case .success:
                let message = response?["message"] as? String
                completionHandler(true, nil, message)
            case .error:
                completionHandler(false, NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
            default:
                completionHandler(false, NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
            }
        })
    }
    
    }
