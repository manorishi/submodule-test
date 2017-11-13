//
//  Extensions.swift
//  licsuperagent
//
//  Created by Anurag Dake on 10/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

/**
 Textfiled extension used to get underlined textfield.
 */

extension UITextField{
    
    ///textfield extension to underline field with given color
    func underlined(underlineColor: UIColor){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = underlineColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
