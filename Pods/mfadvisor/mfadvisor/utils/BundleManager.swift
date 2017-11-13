//
//  BundleUtils.swift
//  mfadvisor
//
//  Created by Anurag Dake on 27/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 BundleManager gives bundle for mfadvisor module
 */
class BundleManager: NSObject {
    
    private let bundleName = "mfadvisor"
    
    func loadResourceBundle(coder: AnyClass) -> Bundle?{
        let podBundle = Bundle(for:coder)
        if let bundleURL = podBundle.url(forResource: bundleName, withExtension: "bundle") {
            return Bundle(url: bundleURL)
        }
        return nil
    }
    
    func loadResourceBundle() -> Bundle?{
        let podBundle = Bundle(identifier: "org.cocoapods.mfadvisor")
        if let bundleURL = podBundle?.url(forResource: bundleName, withExtension: "bundle") {
            return Bundle(url: bundleURL)
        }
        return nil
    }
}
