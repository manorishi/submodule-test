//
//  OfflineSyncer.swift
//  smartsell
//
//  Created by kunal singh on 19/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Foundation
import Core
import Directory
import CoreData

/**
 Used to sync offline data from server like favourites data.
 */

class OfflineSyncer: NetworkListenerDelegate {

    func startListening(){
        ReachabilityService.sharedInstance.reachabilityManager.startMonitoring(listener: self)
    }
    
    func stopListening(){
        ReachabilityService.sharedInstance.reachabilityManager.stopMonitoring()
    }

    func onConnectionAvailable() {
        /**
         When connect with internet update unsynced favourite data to server.
         */
        var managedObjectContext:NSManagedObjectContext? = nil
        DispatchQueue.main.async {
            managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        }
        if let managedObjectContext = managedObjectContext, let _ = KeyChainService.sharedInstance.getValue(key: ConfigKeys.ACCESS_TOKEN_KEY) {
        BaseInteractor().updateUnsyncedFavourites(managedObjectContext: managedObjectContext, completionHandler: { (responseStatus) in
            switch responseStatus {
            case .forbidden:
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as? AppDelegate)?.gotoLoginController()
                }
            default:
                break
            }
        })
        }
    }
    
    func onConnectionUnavailable() {
        
    }
}
