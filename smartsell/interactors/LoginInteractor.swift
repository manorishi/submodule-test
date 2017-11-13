//
//  LoginInteractor.swift
//  licsuperagent
//
//  Created by kunal singh on 10/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

/**
 LoginInteractor containg api call to verify mobile number
 */
class LoginInteractor {
    
    private let PARAM_USERNAME_KEY = "username"
    
    
    func verifyUserName(userName:String,completionHandler:@escaping (_ status:Bool, _ email: String?, _ registeredStatus: Int?, _ errorTitle:String?,_ errorMsg:String?) -> ()) {
        NetworkService.sharedInstance.networkClient?.doPOSTRequest(requestURL: AppUrlConstants.userNameVerificationUrl, params: nil, httpBody:[PARAM_USERNAME_KEY:userName as AnyObject],completionHandler: { (responseStatus, response) in
            switch responseStatus {
            case .success:
                guard let email = response?["email"] as? String, let registeredStatus = response?["registered_status"] as? Int  else {
                    completionHandler(false, nil, 0, NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                    return
                }
                
                completionHandler(true, email, registeredStatus, nil,nil)
            case .error:
                completionHandler(false, nil, 0, NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
            default:
                completionHandler(false, nil, 0, NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
            }
        })
    }
    
    
    
}
