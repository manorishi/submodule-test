//
//  RegistrationInteractor.swift
//  smartsell
//
//  Created by Apple on 06/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

/**
 OTPInteractor contains api call to update user details and storing data in keychain
 */
class RegistrationInteractor {

    private let USER_NAME_KEY = "name"
    private let LOCATION_KEY = "location"
    private let DESIGNATION_KEY = "designation"
    
    func updateUserDetailsOnServer(name:String, designation:String, location:String,completionHandler:@escaping (_ status:Bool,_ errorTitle:String?,_ errorMsg:String?) -> ()) {
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: AppUrlConstants.updateUserDetails, params: nil, httpBody: [USER_NAME_KEY:name as AnyObject,DESIGNATION_KEY:designation as AnyObject,LOCATION_KEY:location as AnyObject], completionHandler: { (responseStatus, response) in
            DispatchQueue.main.async {
                switch responseStatus {
                case .success:
                    self.updateUserDetailsInKeychain(name: name, designation: designation, location: location)
                    completionHandler(true,nil,nil)
                case .error:
                    completionHandler(false,NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                case .forbidden:
                    (UIApplication.shared.delegate as? AppDelegate)?.gotoLoginController()
                    return
                default:
                    completionHandler(false,NetworkUtils.errorTitle(response: nil),NetworkUtils.errorMessage(response: nil))
                }
            }
        })
    }
    
    func locationData() -> [String] {
        do {
            if let file = Bundle.main.url(forResource: "LocationData", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let locationArray = json as? [String] {
                    return locationArray
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("LocationData.json file does not exist.")
            }
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func updateUserDetailsInKeychain(name: String, designation: String, location: String) {
        let userData = UserData()
        userData.name = name
        userData.designation = designation
        userData.location = location
        userData.registrationStatus = true
        let saveData = NSKeyedArchiver.archivedData(withRootObject: userData)
        KeyChainService.sharedInstance.setValue(data: saveData, key: ConfigKeys.USER_DATA_KEY)
    }
}
