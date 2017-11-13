//
//  SuggestedInvestmentView.swift
//  mfadvisor
//
//  Created by Sunil Sharma on 17/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

protocol SuggestedInvestmentDelegate:class {
    func clickedOnProceedButton()
}

class SuggestedInvestmentView: UIView {
    
    @IBOutlet weak var firstFundView: UIView!
    @IBOutlet weak var secondFundView: UIView!
    @IBOutlet weak var firstSuggestedFundPercent: UILabel!
    @IBOutlet weak var firstSuggestedFundTitle: UILabel!
    @IBOutlet weak var firstSuggestedFundIcon: UIButton!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var secondSuggestedFundHeight: NSLayoutConstraint!
    @IBOutlet weak var secondSuggestedFundPercent: UILabel!
    @IBOutlet weak var secondSuggestedFundTitle: UILabel!
    @IBOutlet weak var secondSuggestedFundIcon: UIButton!
    
    weak var delegate:SuggestedInvestmentDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        proceedButton.clipsToBounds = true
        proceedButton.layer.cornerRadius = proceedButton.frame.height / 2
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
    }
    
    func updateSuggestedFund(firstFundName:String?, firstFundAllocation:Float,secondFundName:String?, secondFundAllocation:Float ) {
        if let fundName = firstFundName {
            updateAllFundViewsVisibility(isHidden: false)
            firstSuggestedFundTitle.text = fundName
            firstSuggestedFundPercent.text = "\(String(format: "%.1f", firstFundAllocation))% of investment in this scheme"
            if let secondName = secondFundName, secondFundAllocation != 0 {
                secondFundView.isHidden = false
                secondSuggestedFundTitle.text = secondName
                secondSuggestedFundPercent.text = "\(String(format: "%.1f", secondFundAllocation))% of investment in this scheme"
                proceedButton.frame.origin.y = secondFundView.frame.origin.y + secondFundView.frame.height + 12
            } else {
                secondFundView.isHidden = true
                proceedButton.frame.origin.y = firstFundView.frame.origin.y + firstFundView.frame.height + 20
            }
        } else{
            updateAllFundViewsVisibility(isHidden: true)
        }
        updateImagePadding(fund1Percent: firstFundAllocation, fund2Percent: secondFundAllocation)
    }
    
    private func updateImagePadding(fund1Percent:Float, fund2Percent:Float) {
        let icon1Padding:CGFloat = CGFloat(((100 - fund1Percent) / 100.0) * 20)
        let icon2Padding:CGFloat = CGFloat(((100 - fund2Percent) / 100.0) * 20)
        firstSuggestedFundIcon.contentEdgeInsets = UIEdgeInsetsMake(0, icon1Padding, 2 * icon1Padding , icon1Padding)
        secondSuggestedFundIcon.contentEdgeInsets = UIEdgeInsetsMake(0, icon2Padding, 2 * icon2Padding, icon2Padding)
    }
    
    private func updateAllFundViewsVisibility(isHidden: Bool) {
        proceedButton.isHidden = isHidden
        firstFundView.isHidden = isHidden
        secondFundView.isHidden = isHidden
    }
    
    func enableProceedButton() {
        proceedButton.isEnabled = true
    }

    @IBAction func clickedOnProceedButton(_ sender: Any) {
        proceedButton.isEnabled = false
        delegate?.clickedOnProceedButton()
    }
}
