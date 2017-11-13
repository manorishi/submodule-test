//
//  ApptentiveService.swift
//  smartsell
//
//  Created by Anurag Dake on 03/10/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Foundation
import Apptentive

class ApptentiveService: ExternalServicesProtocol{
    
    let APPENTIVE_KEY_PROD = "IOS-AXIS-MF-PULSE-IOS"
    let APPENTIVE_SIGNATURE_PROD = "867cee4d150cf3c85b954de2a17f242f"
    
    let APPENTIVE_KEY_DEBUG = "IOS-AXIS-MF-PULSE-IOS"
    let APPENTIVE_SIGNATURE_DEBUG = "867cee4d150cf3c85b954de2a17f242f"
    
    func initializeService() {
        #if DEBUG
            print("DEBUG mode activated")
            guard let configuration = ApptentiveConfiguration(apptentiveKey: APPENTIVE_KEY_DEBUG, apptentiveSignature: APPENTIVE_SIGNATURE_DEBUG) else{
                return
            }
        #else
            guard let configuration = ApptentiveConfiguration(apptentiveKey: APPENTIVE_KEY_PROD, apptentiveSignature: APPENTIVE_SIGNATURE_PROD) else{
                return
            }
        #endif
        
        configuration.appID = AppConstants.APP_ID
        Apptentive.register(with: configuration)
    }
}
