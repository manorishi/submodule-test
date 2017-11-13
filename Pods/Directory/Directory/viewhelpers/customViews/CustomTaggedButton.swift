//
//  CustomTaggedButton.swift
//  Directory
//
//  Created by kunal singh on 01/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import UIKit
import Core

class CustomTaggedButton: UIButton {
    var buttonIdentifier: String?
    private let SEPARATOR = "@"
    
    func tagWithSectionAndRow(section: Int, row: Int) -> String{
        return String(section) + SEPARATOR + String(row)
    }
    
    func sectionRowFromTag(tag: String) -> (Int, Int)?{
        let stringArray = tag.components(separatedBy: SEPARATOR)
        if stringArray.count > 1{
            return (Int(stringArray[0])!, Int(stringArray[1])!)
        }
        return nil
    }
    
    
}
