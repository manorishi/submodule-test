//
//  UserAgeSelectionView.swift
//  mfadvisor
//
//  Created by Sunil Sharma on 17/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

class UserAgeSelectionView: UIView {

    @IBOutlet weak var separatorLineView: UIView!
    @IBOutlet weak var ageScrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    let selectedAgeBgColor = hexStringToUIColor(hex: "F9C436")
    
    var selectedUserAge:Int = 52
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
        ageScrollView.layer.borderColor = UIColor.white.cgColor
        ageScrollView.layer.borderWidth = 0.5
        addTapGestureOnView()
        adjustScrollViewHeight()
        addAgeGrid()
    }
    
    func adjustScrollViewHeight() {
        let iconHeight = UIScreen.main.bounds.width * 0.15625
        let font = UIFont.boldSystemFont(ofSize: 20)
        let iconY:CGFloat = 300 * 0.0833333
        let title = "Customer's Age"
        let labelWidth = title.widthWithConstrainedHeight(30, font: font) + 10
        let centerX = UIScreen.main.bounds.width / 2
        self.frame.size.height = UIScreen.main.bounds.height - 170
        
        iconImageView.frame = CGRect(x: iconImageView.frame.origin.x, y: iconY , width: iconHeight, height: iconHeight)
        iconImageView.center.x = centerX
        titleLabel.text = title
        titleLabel.font = font
        titleLabel.frame = CGRect(x: 0, y: iconY + iconHeight + 9, width: labelWidth, height: 30)
        titleLabel.center.x = centerX
        
        let scrollViewY:CGFloat = floor(titleLabel.frame.origin.y + titleLabel.frame.height + 21)
        ageScrollView.frame.origin.y = scrollViewY
        ageScrollView.frame.size.height = UIScreen.main.bounds.height - (170 + scrollViewY)
    }
    
    func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func addAgeGrid() {
        let gridWidth:CGFloat = UIScreen.main.bounds.width / 5
        let gridHeight:CGFloat = gridWidth * 0.7
        let scrollContentView = UIView(frame:CGRect(x: 0, y: 0, width: ageScrollView.frame.width, height: 17 * gridHeight))
        scrollContentView.backgroundColor = .clear
        var frame = CGRect(x: 0, y: 0, width: gridWidth, height: gridHeight)
        for (index, value) in Array(18...100).enumerated() {
            frame = CGRect(x: CGFloat(index % 5) * gridWidth, y: CGFloat(index / 5) * gridHeight, width: gridWidth, height: gridHeight)
            let button = createAgeButton(frame: frame)
            button.setTitle("\(value)", for: .normal)
            button.tag = value
            scrollContentView.addSubview(button)
        }
        ageScrollView.contentSize = CGSize(width: ageScrollView.frame.width, height: scrollContentView.frame.height)
        ageScrollView.frame.size.height = ageScrollView.frame.size.height > scrollContentView.frame.height ? scrollContentView.frame.height : ageScrollView.frame.size.height
        ageScrollView.addSubview(scrollContentView)
        highlightFiftyTwoAgeButton()
    }
    
    func clickedOnAgeButton(sender:UIButton) {
        selectedUserAge = sender.tag
        if let button = ageScrollView.viewWithTag(30) as? UIButton, selectedUserAge != 30{
            button.setBackgroundImage(nil, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
        }
        let yellowBgImage = imageWithColor(selectedAgeBgColor, size: sender.frame.size)
        sender.setBackgroundImage(yellowBgImage, for: .normal)
        shrinkWithAnimation()
    }
    
    func getSelectedUserAgeTuple() -> (minAge:Int, maxAge:Int){
        return selectedUserAge <= 50 ? (0,50) : (51,100)
        //return selectedUserAge < 50 ? (0,50) : (50,nil)
    }
    
    func createAgeButton(frame: CGRect) -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = frame
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(clickedOnAgeButton(sender:)), for: .touchUpInside)
        return button
    }
    
    func addTapGestureOnView()  {
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickedOnView(sender:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    func clickedOnView(sender:UIGestureRecognizer) {
        if isShrinked {
            expandWithAnimation(duration: 0.4)
        }
    }
    
    func highlightFiftyTwoAgeButton() {
        if let button = ageScrollView.viewWithTag(30) as? UIButton{
            selectedUserAge = 30
            let yellowBgImage = imageWithColor(selectedAgeBgColor, size: button.frame.size)
            button.setBackgroundImage(yellowBgImage, for: .normal)
            button.setTitleColor(hexStringToUIColor(hex: MFColors.PRIMARY_COLOR), for: .normal)
        }
    }
    
    func expandWithAnimation(duration:TimeInterval) {
        delegate?.fundPrerequisiteDeselectionExpand(fundPrerequisiteType: .customerAge)
        UIView.animate(withDuration: 0.1) {[weak self] in
            self?.backgroundColor = .clear
            self?.separatorLineView.alpha = 0
        }
        isShrinked = false
        highlightFiftyTwoAgeButton()
        let iconHeight = UIScreen.main.bounds.width * 0.15625
        let font = UIFont.boldSystemFont(ofSize: 20)
        let iconY:CGFloat = 300 * 0.0833333
        let title = "Customer's Age"
        let labelWidth = title.widthWithConstrainedHeight(30, font: font) + 10
        let centerX = UIScreen.main.bounds.width / 2
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {[weak self] in
            self?.frame.size.height = UIScreen.main.bounds.height - 170
            self?.iconImageView.frame = CGRect(x: self?.iconImageView.frame.origin.x ?? 0, y: iconY , width: iconHeight, height: iconHeight)
            self?.iconImageView.center.x = centerX
            self?.titleLabel.text = title
            self?.titleLabel.font = font
            self?.titleLabel.frame = CGRect(x: 0, y: iconY + iconHeight + 9, width: labelWidth, height: 30)
            self?.titleLabel.center.x = centerX
            self?.ageScrollView.alpha = 1
        }) { (isFinished) in}
    }
    
    func shrinkWithAnimation() {
        isShrinked = true
        let iconHeight:CGFloat = 34
        let font = UIFont.systemFont(ofSize: 13)
        let title = "Customer's Age: \(selectedUserAge)"
        let labelWidth = title.widthWithConstrainedHeight(15, font: font) + 10
        self.delegate?.fundPrerequisiteSelectionShrink(fundPrerequisiteType: .customerAge)
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {[weak self] in
            self?.ageScrollView.alpha = 0
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
            if let button = self?.ageScrollView.viewWithTag(self?.selectedUserAge ?? 0) as? UIButton{
                button.setBackgroundImage(nil, for: .normal)
            }
        }
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
}
