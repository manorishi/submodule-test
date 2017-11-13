//
//  FundOptionsTableViewCell.swift
//  mfadvisor
//
//  Created by Apple on 03/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

/**
 FundOptionsTableViewCell is cell item for expandable items in all funds screen
 */
class FundOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var optionTitleHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var fundOptionTitleLabel: UILabel!
    @IBOutlet weak var fundOptionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addFundOptionImage(row:Int) {
        let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder)
        switch row {
            
        case FundOptionsType.salesPitch.rawValue:
            self.fundOptionImageView.image = UIImage(named: "ic_salespitch", in: bundle, compatibleWith: nil)
        case FundOptionsType.presentation.rawValue:
            self.fundOptionImageView.image = UIImage(named: "ic_presentation", in: bundle, compatibleWith: nil)
        case FundOptionsType.performance.rawValue:
            self.fundOptionImageView.image = UIImage(named: "ic_performance", in: bundle, compatibleWith: nil)
        case FundOptionsType.fundComparison.rawValue:
            self.fundOptionImageView.image = UIImage(named: "ic_compare_fund", in: bundle, compatibleWith: nil)
        case FundOptionsType.swpCalculator.rawValue:
            self.fundOptionImageView.image = UIImage(named: "ic_swp_option", in: bundle, compatibleWith: nil)
        case FundOptionsType.sipCalculator.rawValue:
            self.fundOptionImageView.image = UIImage(named: "ic_sip_option", in: bundle, compatibleWith: nil)
            
        default:
            self.fundOptionImageView.image = UIImage(named: "ic_salespitch", in: bundle, compatibleWith: nil)
        }
    }
    
}
