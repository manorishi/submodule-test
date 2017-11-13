//
//  SecurityKeyTextField.swift
//  smartsell
//
//  Created by Anurag Dake on 01/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

class SecurityKeyTextField: UITextField{
    
    let textFieldColor = hexStringToUIColor(hex: Colors.COLOR_PRIMARY)
    let borderColor = hexStringToUIColor(hex: Colors.LIGHT_GREY)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialiseLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialiseLayout()
    }
    
    func initialiseLayout(){
        self.isSecureTextEntry = true
        
        self.textColor = textFieldColor
        self.autocapitalizationType = .allCharacters
        self.font = UIFont.systemFont(ofSize: 18)
        self.textAlignment = .center
        self.tintColor = UIColor.clear
        
        self.borderStyle = .roundedRect
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = 4
    }
}
