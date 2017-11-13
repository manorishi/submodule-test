//
//  BundleManager.swift
//  news
//
//  Created by Anurag Dake on 06/09/17.
//  Copyright © 2017 enParadigm. All rights reserved.
//

import Foundation

class BundleManager: NSObject {
    
    private let bundleName = "news"
    
    func loadResourceBundle(coder: AnyClass) -> Bundle?{
        let podBundle = Bundle(for: coder)
        if let bundleURL = podBundle.url(forResource: bundleName, withExtension: "bundle") {
            return Bundle(url: bundleURL)
        }
        return nil
    }
}
