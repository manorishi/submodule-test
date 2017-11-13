//
//  HelpAlertView.swift
//  mfadvisor
//
//  Created by Anurag Dake on 27/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

/**
 HelpAlertView is corresponding class for HelpAlertView.xib to access outlets
 This view will be dispalyed when user clicks on HELP button on fund selection screen
 */
class HelpAlertView: UIView{
    
    @IBOutlet weak var fullScreenView: UIView!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var keepAllButton: FundSelectionButton!
    @IBOutlet weak var sellAllInvestmentButton: FundSelectionButton!
    @IBOutlet weak var sellSomeButton: FundSelectionButton!
    @IBOutlet weak var bothEquallyButton: FundSelectionButton!
    @IBOutlet weak var minLossButton: FundSelectionButton!
    @IBOutlet weak var maxGainButton: FundSelectionButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    var stockManager:FundSelectionButtonManager!
    var shortTermManager:FundSelectionButtonManager!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configViews()
    }
    
    func configViews() {
        for button in [keepAllButton, sellAllInvestmentButton, sellSomeButton, bothEquallyButton, minLossButton, maxGainButton] {
            button?.titleLabel?.numberOfLines = 2
        }
        stockManager = FundSelectionButtonManager(buttons: bothEquallyButton, minLossButton, maxGainButton)
        shortTermManager = FundSelectionButtonManager(buttons: sellAllInvestmentButton, sellSomeButton, keepAllButton)
    }
    
    func getRiskAppetite() -> String {
        let selectedStock = stockManager.selectedButton()
        let selectedShortTerm = stockManager.selectedButton()
        if selectedStock == sellAllInvestmentButton {
            return "L"
        }else if (selectedStock == maxGainButton){
            return "H"
        }else if selectedStock != nil && selectedShortTerm != nil {
            switch (selectedStock!, selectedShortTerm!) {
            case (maxGainButton, sellAllInvestmentButton),(minLossButton, keepAllButton),(bothEquallyButton,sellSomeButton), (bothEquallyButton, keepAllButton):
                return "M"
            case (maxGainButton,sellSomeButton), (maxGainButton, keepAllButton):
                return "H"
            case (minLossButton,sellAllInvestmentButton), (minLossButton, sellSomeButton), (bothEquallyButton,sellAllInvestmentButton):
                return "L"
            default:
                return "M"
            }
        } else {
            return "M"
        }
    }
    
    func clearSelection() {
        stockManager.unselectAllButtons()
        shortTermManager.unselectAllButtons()
    }
    
}
