//
//  SecurityKeyVerificationInteractor.swift
//  smartsell
//
//  Created by Anurag Dake on 02/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Foundation
import Core

class SecurityKeyVerificationInteractor{
    
    private let PARAM_USERNAME_KEY = "username"
    private let PARAM_SECURITYKEY_KEY = "security_key"
    
    func verifyUserSecurity(userName: String, securityKey: String,  completionHandler:@escaping (_ status:Bool, _ errorTitle:String?,_ errorMsg:String?) -> ()) {
        NetworkService.sharedInstance.networkClient?.doPOSTRequest(requestURL: AppUrlConstants.verifyUserSecurityUrl, params: nil, httpBody:[PARAM_USERNAME_KEY:userName as AnyObject, PARAM_SECURITYKEY_KEY: securityKey as AnyObject],completionHandler: { (responseStatus, response) in
            switch responseStatus {
            case .success:
                completionHandler(true, nil, nil)
            case .error:
                completionHandler(false, NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
            default:
                completionHandler(false, NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
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
