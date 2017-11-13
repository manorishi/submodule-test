//
//  UrlFileNameMapper.swift
//  Core
//
//  Created by kunal singh on 28/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 Model object used to map url and filename.
 */

class UrlFileNameMapper {
    var filename: String?
    var url: String?
    
    init(filename: String?, url: String?) {
        self.filename = filename
        self.url = url
    }
}

