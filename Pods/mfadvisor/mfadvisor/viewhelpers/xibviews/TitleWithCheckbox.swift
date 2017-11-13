//
//  TitleWithCheckbox.swift
//  mfadvisor
//
//  Created by Apple on 09/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

/**
 TitleWithCheckbox displays view that contains a text with checkbox
 */
class TitleWithCheckbox: UIView {

    @IBOutlet weak var checkboxButton: CheckBox!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func updateTitle(string:String) {
        let height = string.heightWithConstrainedWidth(titleLabel.frame.size.width, font: titleLabel.font)
        titleLabel.frame.size.height = height <= 24 ? 24 : height
        self.frame.size.height = height <= 24 ? 45 : height + 16
        titleLabel.text = string
    }
    
}
