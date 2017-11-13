//
//  FundAnswerTableViewCell.swift
//  mfadvisor
//
//  Created by Apple on 05/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

/**
 FundAnswerTableViewCell is cell item for answer data item on salespitch screen
 */
class FundAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var answerIconImageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.answerLabel.attributedText = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(answerData:AnswerData?, bundle:Bundle?,isCollapsed:Bool) {
        if answerData != nil && bundle != nil && !isCollapsed {
            self.answerIconImageView.image = UIImage(named: (answerData?.icon)!, in: bundle, compatibleWith: nil)
            self.answerLabel.attributedText = answerData?.answer
        }
        else {
            self.answerIconImageView.image = nil
            self.answerLabel.text = nil
            self.answerLabel.attributedText = nil
        }
    }
    
}
