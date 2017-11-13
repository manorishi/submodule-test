//
//  GalleryHeader.swift
//  Directory
//
//  Created by kunal singh on 31/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

class GalleryHeader: Hashable{
    var uid: Int
    var name: String
    var description: String
    
    public var hashValue: Int {
        return self.uid
    }
    
    init(uid: Int, name: String, description: String) {
        self.description = description
        self.name = name
        self.uid = uid
    }

    static func ==(lhs: GalleryHeader, rhs: GalleryHeader) -> Bool {
        return lhs.uid == rhs.uid
    }
    
}
