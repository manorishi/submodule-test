//
//  FundTableViewCell.swift
//  mfadvisor
//
//  Created by Apple on 02/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

///UITableviewCell is view for all funds screen cell item
class FundTableViewCell: UITableViewCell {

    var indexPath:IndexPath?
    
    @IBOutlet weak var fundInitialWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleHeightLayoutContraint: NSLayoutConstraint!
    @IBOutlet weak var bottomPaddingLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var fundTitleLabel: UILabel!
    @IBOutlet weak var fundInitialLabel: UILabel!
    @IBOutlet weak var fundNAVLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var seperatorView: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        fundInitialLabel.backgroundColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
    }
    
    func updateViewToCollapse() {
        bottomPaddingLayoutConstraint.constant = 5
        fundInitialWidthLayoutConstraint.constant = 50
        containerView.backgroundColor = UIColor.white
        fundTitleLabel.textColor = UIColor.black
        fundNAVLabel.textColor = UIColor.black
        seperatorView.backgroundColor = UIColor.lightGray
    }
    
    func updateViewToExpand() {
        bottomPaddingLayoutConstraint.constant = 0
        fundInitialWidthLayoutConstraint.constant = 50
        containerView.backgroundColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
        fundTitleLabel.textColor = UIColor.white
        fundNAVLabel.textColor = UIColor.white
        seperatorView.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
