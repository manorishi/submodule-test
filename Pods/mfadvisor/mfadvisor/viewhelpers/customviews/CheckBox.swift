//
//  CheckBox.swift
//  WealthApp
//
//  Created by Anurag Dake on 22/06/16.
//  Copyright © 2016 Cybrilla. All rights reserved.
//

import UIKit

/**
 Checkbox is subclass of UIButton to operate as checkbox with check/uncheck behaviour
 */
class CheckBox: UIButton {
    
    var checkedImage: UIImage!
    var uncheckedImage: UIImage!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func initialize(){
        let bundleManager = BundleManager()
        checkedImage = UIImage(named: "check_box_checked", in: bundleManager.loadResourceBundle(coder: self.classForCoder), compatibleWith: nil)
        uncheckedImage = UIImage(named: "check_box_unchecked", in: bundleManager.loadResourceBundle(coder: self.classForCoder), compatibleWith: nil)
    }
    
    var isChecked: Bool = false {
        didSet{
            if isChecked {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
