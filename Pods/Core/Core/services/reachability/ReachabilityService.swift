//
//  ReachabilityService.swift
//  Core
//
//  Created by kunal singh on 19/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 ReachabilityService initiate ReachabilityManager
 */

import Foundation

public class ReachabilityService {
    public static let sharedInstance = ReachabilityService()
    public var reachabilityManager: ReachabilityManager
    
    
    private init() {
        reachabilityManager = ReachabilityManager()
    }
}


