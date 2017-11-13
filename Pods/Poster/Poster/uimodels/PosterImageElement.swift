//
//  PosterImageElement.swift
//  Poster
//
//  Created by Anurag Dake on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import Core

class PosterImageElementModel: BaseElement{

    var height: Int16!
    var keep_aspect_ratio: Bool = true
    var shape: ElementShapes?
    var width: Int16!
   
    
    init(id: Int32, posterId: Int32, leftMargin: Int16, onByDefault: Bool, topMargin: Int16, height: Int16, keep_aspect_ratio: Bool, shape: ElementShapes?, width: Int16) {
        super.init(id: id, posterId: posterId, leftMargin: leftMargin, onByDefault: onByDefault, topMargin: topMargin)
        self.height = height
        self.keep_aspect_ratio = keep_aspect_ratio
        self.shape = shape
        self.width = width
    }
}
