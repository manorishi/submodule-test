//
//  ReachabilityManager.swift
//  Core
//
//  Created by kunal singh on 19/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 ReachabilityManager monitor for network changes.
 */

import Foundation
import ReachabilitySwift

public class ReachabilityManager: NSObject{
    let reachability = Reachability()!
    weak var networkListener: NetworkListenerDelegate?
    
    func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        if let listener = networkListener{
            switch reachability.currentReachabilityStatus {
            case .notReachable:
                listener.onConnectionUnavailable!()
            case .reachableViaWiFi:
                listener.onConnectionAvailable()
            case .reachableViaWWAN:
                listener.onConnectionAvailable()
            }
        }
    }
    
    public func isNetworkAvailable() -> Bool {
        return reachability.currentReachabilityStatus != .notReachable
    }
    
    public func startMonitoring(listener: NetworkListenerDelegate) {
        self.networkListener = listener
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            logToConsole(printObject: "Could not start reachability notifier")
        }
    }
    
    public func stopMonitoring(){
        NotificationCenter.default.removeObserver(self, name:ReachabilityChangedNotification,
                                                  object: reachability)
        reachability.stopNotifier()
        self.networkListener = nil
    }
    
}

