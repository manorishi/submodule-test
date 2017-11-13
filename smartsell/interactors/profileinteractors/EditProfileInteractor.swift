//
//  EditProfileInteractor.swift
//  smartsell
//
//  Created by Anurag Dake on 13/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

/**
 EditProfileInteractor fetches user data from keychain, make api calls to update userdata
 */
class EditProfileInteractor{
    
    /**
     Upload image to server
     */
    func upload(image:UIImage, completionHandler:@escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void){
        NetworkService.sharedInstance.networkClient?.uploadImage(requestURL: AppUrlConstants.updateProfilePic, params: nil, httpBody: nil, image: image, completionHandler: completionHandler)
    }
    
    /**
     Replace profile image locally with new one
     */
    func replaceImageFromGallery(with image: UIImage, fileName: String){
        AssetDownloaderService.sharedInstance.coreImageDownloader.replaceImageFromGallery(filename: fileName, image: image)
    }
    
    /**
     Delete local profile image
     */
    func deleteImage(fileName: String){
        AssetDownloaderService.sharedInstance.coreImageDownloader.deleteImage(filename: fileName)
    }
    
    /**
     Retrive image from local cache
     */
    func retrieveImage(fileName: String) -> UIImage?{
        return AssetDownloaderService.sharedInstance.coreImageDownloader.retrieveImageFromDisk(filename: fileName)
    }
    
    /**
     Update name in server
     */
    func update(name: String, completionHandler: @escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void){
        updateNameInKeychain(name: name)
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: AppUrlConstants.updateUserName, params: nil, httpBody: ["name": name as AnyObject], completionHandler: completionHandler)
    }
    
    /**
     Update email id in server
     */
    func update(emailID: String, completionHandler: @escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void){
        updateEmailInKeychain(email: emailID)
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: AppUrlConstants.updateEmail, params: nil, httpBody: ["email": emailID as AnyObject], completionHandler: completionHandler)
    }
    
    /**
     Update signature in server
     */
    func update(signature: String, completionHandler: @escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void){
        let signatureToUpload = signature.replacingOccurrences(of: "\n", with: ";")
        updateSignatureInKeychain(signature: signatureToUpload)
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: AppUrlConstants.updateSignature, params: nil, httpBody: ["signature": signatureToUpload as AnyObject], completionHandler: completionHandler)
    }
    
    /**
     Update name in keychain
     */
    private func updateNameInKeychain(name: String){
        guard let userDataObj = userData() else{
            return
        }
        userDataObj.name = name
        saveUserData(userDataObj: userDataObj)
    }
    
    /**
     Update email in keychain
     */
    private func updateEmailInKeychain(email: String){
        guard let userDataObj = userData() else{
            return
        }
        userDataObj.emailId = email
        saveUserData(userDataObj: userDataObj)
    }
    
    /**
     Update signature in keychain
     */
    private func updateSignatureInKeychain(signature: String){
        guard let userDataObj = userData() else{
            return
        }
        userDataObj.signature = signature
        saveUserData(userDataObj: userDataObj)
    }
    
    /**
     Get user data from keychain
     */
    private func userData() -> UserData?{
        guard let userData = KeyChainService.sharedInstance.getData(key: ConfigKeys.USER_DATA_KEY),let userDataObj =  NSKeyedUnarchiver.unarchiveObject(with: userData) as? UserData else{
            return nil
        }
        return userDataObj
    }
    
    /**
     Save user data in keychain
     */
    private func saveUserData(userDataObj: UserData){
        let saveData = NSKeyedArchiver.archivedData(withRootObject: userDataObj)
        KeyChainService.sharedInstance.setValue(data: saveData, key: ConfigKeys.USER_DATA_KEY)
    }
}
