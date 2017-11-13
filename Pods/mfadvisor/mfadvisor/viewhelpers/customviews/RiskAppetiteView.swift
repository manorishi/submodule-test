//
//  RiskAppetiteView.swift
//  mfadvisor
//
//  Created by Sunil Sharma on 14/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

class RiskAppetiteView: UIView {
    
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var highRiskButton: UIButton!
    @IBOutlet weak var mediumRiskButton: UIButton!
    @IBOutlet weak var lowRiskButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var separatorLineView: UIView!
    
    var selectedRiskAppetite:String = ""
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
        if separatorLineView != nil {
            separatorLineView.alpha = 0
            separatorLineView.frame.origin.y += 0.5
            separatorLineView.frame.size.height = 0.5
        }
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            lowRiskButton.setImage(UIImage.init(named: "low_yellow", in: bundle, compatibleWith: nil), for: .highlighted)
            mediumRiskButton.setImage(UIImage.init(named: "medium_yellow", in: bundle, compatibleWith: nil), for: .highlighted)
            highRiskButton.setImage(UIImage.init(named: "high_yellow", in: bundle, compatibleWith: nil), for: .highlighted)
        }

        for (index,button) in [lowRiskButton, mediumRiskButton, highRiskButton].enumerated() {
            button?.tag = index
            addTapGestureOnImageView(button)
        }
        addTapGestureOnView()
    }
    
    func addTapGestureOnImageView(_ button:UIButton?)  {
        button?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickedRiskAppetiteImage(sender:)))
        tapGesture.numberOfTapsRequired = 1
        button?.addGestureRecognizer(tapGesture)
    }
    
    func addTapGestureOnView()  {
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickedOnView(sender:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    func clickedRiskAppetiteImage(sender:UIGestureRecognizer) {
        if let button = sender.view as? UIButton {
            switch button.tag {
            case 0:
                selectedRiskAppetite = "L"
            case 1:
                selectedRiskAppetite = "M"
            case 2:
                selectedRiskAppetite = "H"
            default:
                selectedRiskAppetite = ""
            }
            shrinkWithAnimation()
        }
    }
    
    func clickedOnView(sender:UIGestureRecognizer) {
        if isShrinked {
            expandWithAnimation(duration: 0.4)
        }
    }
    
    func expandWithAnimation(duration:TimeInterval) {
        delegate?.fundPrerequisiteDeselectionExpand(fundPrerequisiteType: .risk)
        UIView.animate(withDuration: 0.1) {[weak self] in
            self?.backgroundColor = .clear
            self?.separatorLineView.alpha = 0
        }
        
        isShrinked = false
        let iconHeight = UIScreen.main.bounds.width * 0.15625
        let font = UIFont.boldSystemFont(ofSize: 20)
        let iconY:CGFloat = 300 * 0.0833333
        let title = "Risk Appetite"
        let labelWidth = title.widthWithConstrainedHeight(30, font: font) + 10
        let centerX = UIScreen.main.bounds.width / 2
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {[weak self] in
            self?.updateButtonsAlpha(value: 1.0)
            self?.frame.size.height = 320
            self?.iconImageView.frame = CGRect(x: self?.iconImageView.frame.origin.x ?? 0, y: iconY , width: iconHeight, height: iconHeight)
            self?.iconImageView.center.x = centerX
            self?.titleLabel.text = title
            self?.titleLabel.font = font
            self?.titleLabel.frame = CGRect(x: 0, y: iconY + iconHeight + 9, width: labelWidth, height: 30)
            self?.titleLabel.center.x = centerX
        }) { (isFinished) in}
    }
    
    func shrinkWithAnimation() {
        isShrinked = true
        updateButtonsAlpha(value: 0)
        let iconHeight:CGFloat = 34
        let font = UIFont.systemFont(ofSize: 13)
        let title = "Risk Appetite: \(getSelectedRiskAppetiteText())"
        let labelWidth = title.widthWithConstrainedHeight(15, font: font) + 10
        self.delegate?.fundPrerequisiteSelectionShrink(fundPrerequisiteType: .risk)
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
    
    func updateButtonsAlpha(value:CGFloat) {
        lowRiskButton.alpha = value
        mediumRiskButton.alpha = value
        highRiskButton.alpha = value
        helpButton.alpha = value
    }
    
    public func showView(){
        self.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {[weak self] in
            self?.isHidden = false
            self?.alpha = 1.0
        }, completion: nil)
        
    }

    public func hideAndResetView(){
        self.isHidden = true
        expandWithAnimation(duration: 0)
    }
    
    func addTargetOnHelpButton(target: Any?, action: Selector) {
        helpButton.addTarget(target, action:action, for: .touchUpInside)
    }
    
    func getSelectedRiskAppetiteText() -> String {
        switch selectedRiskAppetite {
        case "L":
            return "Low"
        case "M":
            return "Medium"
        case "H":
            return "High"
        default:
            return ""
        }
    }
}
