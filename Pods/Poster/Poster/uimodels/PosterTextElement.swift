//
//  PosterTextElement.swift
//  Poster
//
//  Created by Anurag Dake on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import Core

class PosterTextElementModel: BaseElement{
    var rightMargin: Int16!
    var defaultText: String?
    var fontColor: String?
    var fontFamily: String?
    var fontSize: Int16!
    var textAlignment: ElementTextAlignment?
    
    init(id: Int32, posterId: Int32, leftMargin: Int16, onByDefault: Bool, topMargin: Int16,rightMargin: Int16, defaultText: String?, fontColor: String?, fontFamily: String?, fontSize: Int16, textAlignment: ElementTextAlignment?) {
        super.init(id: id, posterId: posterId, leftMargin: leftMargin, onByDefault: onByDefault, topMargin: topMargin)
        self.rightMargin = rightMargin
        self.defaultText = defaultText
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.fontFamily = fontFamily
        self.textAlignment = textAlignment
    }
    
    
}
