//
//  RiskometerView.swift
//  mfadvisor
//
//  Created by Anurag Dake on 03/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

/**
 RiskometerView is corresponding class for RiskometerView.xib to access outlets
 This view is used in fund selection details and presentation page to display riskometer details
 */
class RiskometerView: UIView{
    
    @IBOutlet weak var riskometerImageView: UIImageView!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productDisclaimerLabel: UILabel!
    
    @IBOutlet weak var disclaimerTopConstraint: NSLayoutConstraint!
    
    func updateViewHeight(){
        let productLabelHeight = (self.productLabel.attributedText?.heightWithConstrainedWidth(self.productLabel.frame.width, font: self.productLabel.font) ?? 21)
        if productLabelHeight > CGFloat(107) {
            let difference = (productLabelHeight - 107)
            disclaimerTopConstraint.constant = CGFloat(4 + difference)
            self.frame.size.height = CGFloat(180 + difference)
        } else {
            self.frame.size.height = 180
        }
    }
}
