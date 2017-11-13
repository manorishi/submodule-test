//
//  BaseElement.swift
//  Poster
//
//  Created by kunal singh on 01/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

class BaseElement{
    var id: Int32!
    var leftMargin: Int16!
    var onByDefault: Bool
    var posterId: Int32!
    var topMargin: Int16!
    
    init(id:Int32, posterId:Int32,  leftMargin: Int16, onByDefault: Bool, topMargin: Int16) {
        self.id = id
        self.posterId = posterId
        self.leftMargin = leftMargin
        self.topMargin = topMargin
        self.onByDefault = onByDefault
    }
    
}
