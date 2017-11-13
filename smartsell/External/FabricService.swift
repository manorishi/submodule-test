//
//  FabricUtils.swift
//  smartsell
//
//  Created by kunal singh on 30/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

/**
 Initialise Fabric Crashlytics.
*/

class FabricService: ExternalServicesProtocol {
    
    func initializeService() {
        #if DEBUG
            print("DEBUG mode activated")
        #else
            Crashlytics.sharedInstance().debugMode = true
            Fabric.with([Crashlytics.self])
        #endif
    }
}
