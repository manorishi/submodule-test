//
//  UserData.swift
//  smartsell
//
//  Created by Apple on 07/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

public class UserData: NSObject,NSCoding {
    
    ///These variable contains property of UserData.
    public var userId:Int?
    public var userTypeId: Int?
    public var name:String?
    public var userName:String?
    public var mobileNumber:String?
    public var emailId:String?
    public var signature: String? = ";;;"
    public var designation:String?
    public var location:String?
    public var profileImageUrl:String?
    public var registrationStatus:Bool = false
    
    ///These are the key used for saving data in Keychain.
    private let userIdKey = "userId"
    private let userTypeIdKey = "userTypeIdKey"
    private let nameKey = "name"
    private let userNameKey = "userName"
    private let mobileNoKey = "mobileNumber"
    private let emailIdKey = "emailId"
    private let signatureKey = "signatureKey"
    private let designationKey = "designation"
    private let locationKey = "location"
    private let profileImageUrlKey = "profileImgUrl"
    private let registrationStatusKey = "registrationStatusKey"
    
    public override init() {
        
    }
    
    public init(userData:[String:AnyObject]) {
        if let userId = userData["user_id"] as? Int {
            self.userId = userId
        }
        if let userTypeId = userData["user_type_id"] as? Int {
            self.userTypeId = userTypeId
        }
        if let userName = userData["name"] as? String {
            self.name = userName
        }
        if let mobileNo = userData["mobile_number"] as? String {
            self.mobileNumber = mobileNo
        }
        if let email = userData["email"] as? String {
            self.emailId = email
        }
        if let signature = userData["signature"] as? String {
            self.signature = signature
        }
        else{
            self.signature = ";;;"
        }
        if let designation = userData["designation"] as? String {
            self.designation = designation
        }
        if let location = userData["location"] as? String {
            self.location = location
        }
        if let imageUrl = userData["profile_img_url"] as? String {
            self.profileImageUrl = imageUrl
        }
        if let registrationStatus = userData["registered_status"] as? Bool {
            self.registrationStatus = registrationStatus
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        
        if let userId = aDecoder.decodeObject(forKey: userIdKey) as? NSNumber {
            self.userId = userId.intValue
        }
        if let userTypeId = aDecoder.decodeObject(forKey: userTypeIdKey) as? NSNumber {
            self.userTypeId = userTypeId.intValue
        }
        if let name = aDecoder.decodeObject(forKey: nameKey) as? String {
            self.name = name
        }
        
        if let userName = aDecoder.decodeObject(forKey: userNameKey) as? String {
            self.name = userName
        }
        
        if let emailId = aDecoder.decodeObject(forKey: emailIdKey) as? String {
            self.emailId = emailId
        }
        if let signature = aDecoder.decodeObject(forKey: signatureKey) as? String {
            self.signature = signature
        }
        if let mobileNo = aDecoder.decodeObject(forKey: mobileNoKey) as? String {
            self.mobileNumber = mobileNo
        }
        if let designation = aDecoder.decodeObject(forKey: designationKey) as? String {
            self.designation = designation
        }
        if let location = aDecoder.decodeObject(forKey: locationKey) as? String {
            self.location = location
        }
        if let profileImgUrl = aDecoder.decodeObject(forKey: profileImageUrlKey) as? String {
            self.profileImageUrl = profileImgUrl
        }
        self.registrationStatus = aDecoder.decodeBool(forKey: registrationStatusKey)
    }
    
    public func encode(with aCoder: NSCoder) {
        if let userId = self.userId {
            aCoder.encode(NSNumber(value: userId), forKey: userIdKey)
        }
        if let userTypeId = self.userTypeId {
            aCoder.encode(NSNumber(value: userTypeId), forKey: userTypeIdKey)
        }
        if let name = self.name {
            aCoder.encode(name, forKey: nameKey)
        }
        if let userName = self.userName {
            aCoder.encode(userName, forKey: userNameKey)
        }
        if let emailId = self.emailId {
            aCoder.encode(emailId, forKey: emailIdKey)
        }
        if let signature = self.signature {
            aCoder.encode(signature, forKey: signatureKey)
        }
        if let mobileNo = self.mobileNumber {
            aCoder.encode(mobileNo, forKey: mobileNoKey)
        }
        if let designation = self.designation {
            aCoder.encode(designation, forKey: designationKey)
        }
        if let location = self.location {
            aCoder.encode(location, forKey: locationKey)
        }
        if let profileImgUrl = self.profileImageUrl {
            aCoder.encode(profileImgUrl, forKey: profileImageUrlKey)
        }
        aCoder.encode(self.registrationStatus, forKey: registrationStatusKey)
    }
    
    /**
     Get profile image name
     Profile Image name will be combination of UserId, USerTypeId and version as 0 fixed
     */
    public func profileImageName() -> String{
        return buildFileName(contentId: Int32(userId ?? 0), contentTypeId: Int16(userTypeId ?? 0), assetVersion: 0) ?? ""
    }
    
    public func signatureInDisplayFormat() -> String{
        return signature?.replacingOccurrences(of: ";", with: "\n") ?? ""
    }
}
