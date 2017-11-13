//
//  FundSelectionViewController.swift
//  mfadvisor
//
//  Created by Anurag Dake on 26/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core

/**
 FundSelectionViewController displays questions to get user values to decide suitable funds for them.
 */
public class FundSelectionViewController: UIViewController{
    
    @IBOutlet weak var backgroundView: UIView!
    
    var helpAlertView: HelpAlertView!
    var fundSelectionPresentor: FundSelectionPresentor!
    public var managedObjectContext:NSManagedObjectContext?
    
    var investmentPeriodButtonManager: FundSelectionButtonManager!
    var riskButtonManager: FundSelectionButtonManager!
    var customerAgeButtonManager: FundSelectionButtonManager!
    var lockInPeriodButtonManager: FundSelectionButtonManager!
    private let MFADVISOR_BUNDLE = "mfadvisor"
    
    fileprivate var tenureView:TenureSelection!
    fileprivate var riskAppetiteView:RiskAppetiteView!
    fileprivate var userAgeSelectionView:UserAgeSelectionView!
    fileprivate var suggestedInvestmentView:SuggestedInvestmentView!
    fileprivate var mFSelectionItem: MFSelectionItem?
    fileprivate var fundsWithAllocation:[String:Float] = [:]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        fundSelectionPresentor = FundSelectionPresentor(fundSelectionViewController: self)
        addPrerequisiteViews()
        initialiseHelpAlertView()
    }
    
    func addPrerequisiteViews() {
        backgroundView.layer.addSublayer(fundSelectionPresentor.getBackgroundGradient())
        addTenureView()
        addRiskAppetite()
        addCustomersAge()
        addSuggestedInvestmentView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        suggestedInvestmentView.enableProceedButton()
    }
    
    func addSuggestedInvestmentView() {
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder)
            else { return }
        suggestedInvestmentView = bundle.loadNibNamed("SuggestedInvestmentView", owner: self, options: nil)?[0] as! SuggestedInvestmentView
        suggestedInvestmentView.frame = CGRect(x: 0, y: 220, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 220)
        suggestedInvestmentView.isHidden = true
        suggestedInvestmentView.delegate = self
        self.view.addSubview(suggestedInvestmentView)
    }
    
    func addCustomersAge() {
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder)
            else { return }
        userAgeSelectionView = bundle.loadNibNamed("UserAgeSelectionView", owner: self, options: nil)?[0] as! UserAgeSelectionView
        userAgeSelectionView.frame = CGRect(x: 0, y: 170, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 170)
        userAgeSelectionView.delegate = self
        userAgeSelectionView.isHidden = true
        self.view.addSubview(userAgeSelectionView)
    }
    
    func addRiskAppetite() {
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder)
            else { return }
        riskAppetiteView = bundle.loadNibNamed("RiskAppetiteView", owner: self, options: nil)?[0] as! RiskAppetiteView
        riskAppetiteView.frame = CGRect(x: 0, y: 120, width: UIScreen.main.bounds.width, height: 320)
        riskAppetiteView.delegate = self
        riskAppetiteView.isHidden = true
        riskAppetiteView.addTargetOnHelpButton(target: self, action: #selector(showHelpUIAlertController))
        self.view.addSubview(riskAppetiteView)
    }
    
    func addTenureView(){
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder)
            else { return }
        tenureView = bundle.loadNibNamed("TenureSelection", owner: self, options: nil)?[0] as! TenureSelection
        tenureView.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.width, height: 300)
        tenureView.delegate = self
        self.view.addSubview(tenureView)
    }
    
    func initialiseHelpAlertView(){
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder)
            else { return }
        helpAlertView = bundle.loadNibNamed("HelpAlertView", owner: self, options: nil)?[0] as! HelpAlertView
        helpAlertView.frame = view.frame
        helpAlertView.bounds = view.bounds
        helpAlertView.alertView.layer.cornerRadius = 5
        helpAlertView.fullScreenView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        helpAlertView.okButton.addTarget(self, action: #selector(onHelpOkPress), for: .touchUpInside)
        helpAlertView.cancelButton.addTarget(self, action: #selector(onHelpCancelPress), for: .touchUpInside)
        view.addSubview(helpAlertView)
        helpAlertView.isHidden = true
        helpAlertView.alertView.isHidden = true
    }
    
    func showHelpUIAlertController(){
        helpAlertView.alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.helpAlertView.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {[weak self] () -> Void in
            self?.helpAlertView.alertView.transform = CGAffineTransform.identity
            self?.helpAlertView.alertView.isHidden = false
            }, completion: nil)
    }
    
    func onHelpOkPress(){
        riskAppetiteView.selectedRiskAppetite = helpAlertView.getRiskAppetite()
        riskAppetiteView.shrinkWithAnimation()
        Toast(with: "Risk Appetite set to \(riskAppetiteView.getSelectedRiskAppetiteText())").show()
        helpAlertView.clearSelection()
        dismissHelpView()
    }
    
    func onHelpCancelPress(){
        dismissHelpView()
    }
    
    func dismissHelpView(){
        helpAlertView.alertView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {[weak self] () -> Void in
            self?.helpAlertView.alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { [weak self](finished: Bool) -> Void in
                self?.helpAlertView.isHidden = true
        })
    }
    
    func getSuggestedFundData() {
        let age = userAgeSelectionView.getSelectedUserAgeTuple()
        let riskAppetiteString = riskAppetiteView.selectedRiskAppetite
        let investmentDuration = tenureView.selectedTenurePeriod
        let isOkWithLockIn = "YES"
        fundsWithAllocation = fundSelectionPresentor.fundsWithSlot(managedObjectContext: managedObjectContext!, minAge: age.minAge, maxAge: age.maxAge, minDuration: investmentDuration.minDuration, maxDuration: investmentDuration.maxDuration, riskAppetite: riskAppetiteString, lockInFlag: isOkWithLockIn)
        mFSelectionItem = fundSelectionPresentor.fundSelectionData(managedObjectContext: managedObjectContext!, fundsWithAllocation: fundsWithAllocation, maxDuration: investmentDuration.maxDuration ?? 0, riskAppetite: riskAppetiteString)
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension FundSelectionViewController: SuggestedInvestmentDelegate {
    func clickedOnProceedButton() {
        let riskAppetiteString = riskAppetiteView.selectedRiskAppetite
        let investmentDuration = tenureView.selectedTenurePeriod
        fundSelectionPresentor.gotoFundSelectionDetails(managedObjectContext: managedObjectContext, fundsWithAllocation: fundsWithAllocation, maxDuration: investmentDuration.maxDuration ?? 0, riskAppetite: riskAppetiteString, mFSelectionItem: mFSelectionItem)
    }
}

extension FundSelectionViewController:FundPrerequisiteDelegate {
    func fundPrerequisiteSelectionShrink(fundPrerequisiteType: FundPrerequisiteType) {
        switch fundPrerequisiteType {
        case .tenure:
            riskAppetiteView.showView()
        case .risk:
            userAgeSelectionView.showView()
            userAgeSelectionView.adjustScrollViewHeight()
        case .customerAge:
            getSuggestedFundData()
            suggestedInvestmentView.showView()
            updateSuggestedFunds()
        }
    }
    
    func updateSuggestedFunds() {
        var fund1 = mFSelectionItem?.fundItems.first
        var fund2:SelectionFundItem? = nil
        if (mFSelectionItem?.fundItems.count ?? 0) > 1 {
            fund2 = mFSelectionItem?.fundItems.last
            if (fund1?.fundAllocation ?? 0) < (fund2?.fundAllocation ?? 0) {
                let fund3 = fund1
                fund1 = fund2
                fund2 = fund3
            }
        }
        suggestedInvestmentView.updateSuggestedFund(firstFundName: fund1?.fundName, firstFundAllocation: fund1?.fundAllocation ?? 0, secondFundName: fund2?.fundName, secondFundAllocation: fund2?.fundAllocation ?? 0)
    }
    
    func fundPrerequisiteDeselectionExpand(fundPrerequisiteType: FundPrerequisiteType) {
        switch fundPrerequisiteType {
        case .tenure:
            riskAppetiteView.hideAndResetView()
            userAgeSelectionView.hideAndResetView()
            suggestedInvestmentView.hideAndResetView()
        case .risk:
            userAgeSelectionView.hideAndResetView()
            suggestedInvestmentView.hideAndResetView()
        case .customerAge:
            suggestedInvestmentView.hideAndResetView()
        }
    }
}





