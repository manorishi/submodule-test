//
//  TenureSelection.swift
//  mfadvisor
//
//  Created by Sunil Sharma on 14/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

enum FundPrerequisiteType {
    case tenure,risk,customerAge
}

protocol FundPrerequisiteDelegate:class {
    func fundPrerequisiteSelectionShrink(fundPrerequisiteType:FundPrerequisiteType)
    func fundPrerequisiteDeselectionExpand(fundPrerequisiteType:FundPrerequisiteType)
}

class TenureSelection: UIView {
    
    @IBOutlet weak var yearsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var separatorLineView: UIView!
    @IBOutlet weak var moreThanFiveYearButton: UIButton!
    @IBOutlet weak var fiveYearButton: UIButton!
    @IBOutlet weak var threeYearButton: UIButton!
    @IBOutlet weak var lessThanYearButton: UIButton!
    
    var selectedTenurePeriod:(minDuration:Int, maxDuration:Int?) = (0,0)
    var isShrinked = false
    weak var delegate:FundPrerequisiteDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configView() {
        let buttons = [lessThanYearButton, threeYearButton, fiveYearButton, moreThanFiveYearButton]
        for button in buttons {
            button?.clipsToBounds = true
            button?.layer.cornerRadius = 4
        }
        if separatorLineView != nil {
            separatorLineView.alpha = 0
            separatorLineView.frame.origin.y += 0.5
            separatorLineView.frame.size.height = 0.5
        }
        addTapGestureOnView()
    }
    
    func addTapGestureOnView()  {
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickedOnView(sender:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    func clickedOnView(sender:UIGestureRecognizer) {
        if isShrinked {
            expandWithAnimation()
        }
    }
    
    func expandWithAnimation() {
        delegate?.fundPrerequisiteDeselectionExpand(fundPrerequisiteType: .tenure)
        UIView.animate(withDuration: 0.1) {[weak self] in
            self?.backgroundColor = .clear
            self?.separatorLineView.alpha = 0
        }
        
        isShrinked = false
        let iconHeight = UIScreen.main.bounds.width * 0.15625
        let font = UIFont.boldSystemFont(ofSize: 20)
        let iconY:CGFloat = 300 * 0.0833333
        let title = "Tenure"
        let labelWidth = title.widthWithConstrainedHeight(30, font: font) + 10
        let centerX = UIScreen.main.bounds.width / 2
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {[weak self] in
            self?.frame.size.height = 300
            self?.iconImageView.frame = CGRect(x: self?.iconImageView.frame.origin.x ?? 0, y: iconY , width: iconHeight, height: iconHeight)
            self?.iconImageView.center.x = centerX
            self?.titleLabel.text = title
            self?.titleLabel.font = font
            self?.titleLabel.frame = CGRect(x: 0, y: iconY + iconHeight + 9, width: labelWidth, height: 30)
            self?.titleLabel.center.x = centerX
            self?.yearsView.alpha = 1.0
        }) { (isFinished) in}
    }
    
    func shrinkWithAnimation() {
        isShrinked = true
        yearsView.alpha = 0
        let iconHeight:CGFloat = 34
        let font = UIFont.systemFont(ofSize: 13)
        let title = "Tenure: \(getSelectedTenureText())"
        let labelWidth = title.widthWithConstrainedHeight(15, font: font) + 10
        self.delegate?.fundPrerequisiteSelectionShrink(fundPrerequisiteType: .tenure)
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {[weak self] in
            self?.frame.size.height = 50
            self?.iconImageView.frame = CGRect(x: (UIScreen.main.bounds.width / 2) - (iconHeight + labelWidth)/2 , y: 7, width: iconHeight, height: iconHeight)
            self?.titleLabel.text = title
            self?.titleLabel.frame = CGRect(x: (self?.iconImageView.frame.origin.x ?? 0) + iconHeight, y: 7, width: labelWidth, height: iconHeight)
            self?.titleLabel.font = font
            UIView.animate(withDuration: 0.1, delay: 0.2, options: [.curveEaseInOut], animations: {
                self?.backgroundColor = UIColor.black
            }, completion: nil)
        }) {[weak self] (isFinished) in
            self?.separatorLineView.alpha = 1.0
        }
    }
    
    @IBAction func clickedOnMoreThanFiveYear(_ sender: Any) {
        selectedTenurePeriod = (5,nil)
        shrinkWithAnimation()
    }
    
    @IBAction func clickedOnFiveYear(_ sender: Any) {
        selectedTenurePeriod = (3,5)
        shrinkWithAnimation()
    }
    
    @IBAction func clickedOnThree(_ sender: Any) {
        selectedTenurePeriod = (1,3)
        shrinkWithAnimation()
    }
    
    @IBAction func clickedOnLessThanOneYear(_ sender: Any) {
        selectedTenurePeriod = (0,1)
        shrinkWithAnimation()
    }
    
    func getSelectedTenureText() -> String {
        switch selectedTenurePeriod.minDuration {
        case 0:
            return "<1 yr"
        case 1:
            return "1-3 yrs"
        case 3:
            return "3-5 yrs"
        case 5:
            return "5 yrs+"
        default:
            return "<1 yr"
        }
    }
}
