//
//  FundQuestionTableViewCell.swift
//  mfadvisor
//
//  Created by Apple on 05/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

/**
 FundQuestionTableViewCell is cell item for question item on salespitch screen
 */
class FundQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var iconWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionIcon: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.questionLabel.attributedText = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(questionIcon:String, question:String,bundle:Bundle?) {
        self.questionIcon.image = UIImage(named: questionIcon, in: bundle, compatibleWith: nil)
        self.questionLabel.text = question
        self.arrowIcon.image = UIImage(named: "ic_arrow_down", in: bundle, compatibleWith: nil)
    }
    
    func updateViewToCollapse() {
        self.containerView.backgroundColor = UIColor.white
        iconWidthLayoutConstraint.constant = 40
        self.questionLabel.font = UIFont.systemFont(ofSize: 16)
        rotate(isCollapsed: true)
    }
    
    func updateViewToExpand() {
        self.containerView.backgroundColor = hexStringToUIColor(hex: MFColors.ANSWER_BACKGROUND)
        iconWidthLayoutConstraint.constant = 0
        self.questionLabel.font = UIFont.systemFont(ofSize: 17)
        rotate(isCollapsed: false)
    }
        
    func rotate(isCollapsed:Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            self.arrowIcon.transform = CGAffineTransform(rotationAngle: CGFloat(isCollapsed ? 0 : Double.pi))
        }, completion: nil)
    }
}
