//
//  FundInfoView.swift
//  mfadvisor
//
//  Created by Anurag Dake on 03/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

/**
 FundInfoView is corresponding class for FundInfoView.xib to access outlets
 This view is used in fund selection details and presentation page to display info about fund such as name, initials etc
 */
class FundInfoView: UIView {
    
    @IBOutlet weak var firstLineLabel: UILabel!
    @IBOutlet weak var secondLineLabel: UILabel!
    @IBOutlet weak var fundInitials1Label: UILabel!
    @IBOutlet weak var fundInitials2Label: UILabel!
    
}
