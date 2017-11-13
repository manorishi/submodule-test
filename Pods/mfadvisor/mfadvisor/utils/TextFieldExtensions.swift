//
//  TextFieldExtensions.swift
//  mfadvisor
//
//  Created by Anurag Dake on 08/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

///This file contains extensions related to UITextField

import UIKit

///TextField extension to underline the uitextfield with specified color
extension UITextField{
    
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
