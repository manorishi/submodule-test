//
//  DirectoryUtils.swift
//  Directory
//
//  Created by kunal singh on 23/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import UIKit

/**
 Get content type icon based on passed content id as parameter.
 
 @param contentTypeId Contains contents type id
 
 @return Return UIImage instance
 */
func contentTypeImage(resourceFileName:String?, resourceBundle: Bundle?) -> UIImage? {
    if let bundle = resourceBundle{
        return UIImage(named: resourceFileName ?? "", in: bundle, compatibleWith: nil)
    }
    return nil
}

func loadResourceBundle(coder: AnyClass, bundleName: String = "Directory") -> Bundle?{
    let podBundle = Bundle(for: coder)
    if let bundleURL = podBundle.url(forResource: bundleName, withExtension: "bundle") {
        return Bundle(url: bundleURL)
    }
    return nil
}
