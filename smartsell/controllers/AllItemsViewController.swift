//
//  AllItemsViewController.swift
//  smartsell
//
//  Created by Apple on 02/05/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import mfadvisor
import Core

/**
 Displays all funds.
 */
class AllItemsViewController: UIViewController {

    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appIconWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var actionBarView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    
    
    let MFADVISOR_IDENTIFIER = "org.cocoapods.mfadvisor"
    let ALLFUNDS_VIEWCONTROLLER = "AllFundsViewController"
    
    var isFromHomeScreen = false
    var fundOptionType:FundOptionsType? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMFAView()
        configureView()
    }
    
    func configureView() {
        backButtonWidthConstraint.constant = isFromHomeScreen ? 50 : 5
        appIconWidthConstraint.constant = isFromHomeScreen ? 0 : 40
        titleLabel.text = isFromHomeScreen ? fundsTitle() : "ALL_FUNDS_TITLE".localized
        backbutton.isHidden = !isFromHomeScreen
        appIconImageView.isHidden = isFromHomeScreen
        homeButton.isHidden = !isFromHomeScreen
        actionBarView.backgroundColor = isFromHomeScreen ? hexStringToUIColor(hex: Colors.PINK) : UIColor.black
    }
    
    func fundsTitle() -> String{
        guard let type = fundOptionType else{
            return "MFPULSE".localized
        }
        switch type {
        case .fundComparison:
            return "fund_comparison".localized
        case .salesPitch:
            return "fund_faq".localized
        case .presentation:
            return "fund_presentation".localized
        case .performance:
            return "fund_performance".localized
        case .swpCalculator:
            return "swp_calculator".localized
        case .sipCalculator:
            return "sip_calculator".localized
        }
    }
    
    func addMFAView() {
        var allFundsVC:AllFundsViewController?
        let podBundle = Bundle(identifier: MFADVISOR_IDENTIFIER)
        allFundsVC = AllFundsViewController(nibName: ALLFUNDS_VIEWCONTROLLER, bundle: podBundle)
        allFundsVC?.managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.mfaManagedObjectContext
        if isFromHomeScreen {
            allFundsVC?.isExpandable = false
            allFundsVC?.fundOptionType = fundOptionType
        }
        configureChildViewController(childController: allFundsVC!, onView: self.containerView)
    }

    @IBAction func clickedOnBackButton(_ sender: Any) {
        if isFromHomeScreen {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onHomeButtonTap(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
