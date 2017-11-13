//
//  FundSelectionButton.swift
//  mfadvisor
//
//  Created by Anurag Dake on 26/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

/**
 FundSelectionButton is subclass of button to achive behavior of radio button
 */
class FundSelectionButton : UIButton{
    
    let unselectedBackgroundColor = UIColor.white
    let selectedBackgroundColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
    let unselectedTextColor = UIColor.darkGray
    let selectedTextColor = UIColor.white
    let unselectedBorderColor = UIColor.darkGray
    let selectedBorderColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    override var isSelected: Bool {
        didSet {
            toggleButton()
        }
    }
    
    func toggleButton() {
        if self.isSelected {
            selectButton()
        } else {
            unselectButton()
        }
    }

    func initialize() {
        self.frame = bounds
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        if #available(iOS 8.2, *) {
            self.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        } else {
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        }
        unselectButton()
    }
    
    func unselectButton(){
        self.backgroundColor = unselectedBackgroundColor
        self.setTitleColor(unselectedTextColor, for: .normal)
        self.layer.borderColor = unselectedBorderColor.cgColor
    }
    
    func selectButton(){
        self.backgroundColor = selectedBackgroundColor
        self.setTitleColor(selectedTextColor, for: .normal)
        self.layer.borderColor = selectedBorderColor.cgColor
    }

}
