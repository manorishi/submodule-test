//
//  KeyChainService.swift
//  Core
//
//  Created by kunal singh on 17/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 KeyChainService contains methods to save, retrieve and delete data from keychain.
 */

import Foundation
import KeychainAccess

public class KeyChainService {
    
    public static let sharedInstance = KeyChainService()
    private let keychain:Keychain
    private let serviceName = "com.smartsell"
    
    private init() {
        keychain = Keychain(service: serviceName).accessibility(.afterFirstUnlock)
    }
    
    @discardableResult
    public func setValue(string:String, key:String) -> Bool {
        do {
            try keychain.set(string, key: key)
            return true
        }
        catch let error {
            logToConsole(printObject: error)
            return false
        }
    }
    
    public func getValue(key:String) -> String? {
        do {
            let value = try keychain.getString(key)
            return value
        }
        catch let error {
            logToConsole(printObject:error)
            return nil
        }
    }
    
    @discardableResult
    public func setValue(data:Data, key:String) -> Bool {
        do {
            try keychain.set(data, key: key)
            return true
        }
        catch let error {
            logToConsole(printObject: error)
            return false
        }
    }
    
    public func getData(key:String) -> Data? {
        do {
            let value = try keychain.getData(key)
            return value
        }
        catch let error {
            logToConsole(printObject: error)
            return nil
        }
    }
    
    @discardableResult
    public func deleteValue(key:String) -> Bool{
        do {
            try keychain.remove(key)
            return true
        }
        catch let error {
            logToConsole(printObject: error)
            return false
        }
    }
    
    @discardableResult
    public func deleteAllKeychainValue() -> Bool {
        do {
            try keychain.removeAll()
            return true
        }
        catch let error {
            logToConsole(printObject: error)
            return false
        }
    }
}
