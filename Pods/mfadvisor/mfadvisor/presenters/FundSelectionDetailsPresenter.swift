//
//  FundSelectionDetailsPresenter.swift
//  mfadvisor
//
//  Created by Anurag Dake on 03/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core

/**
 FundSelectionDetailsPresenter handle UI logic for FundSelectionDetailsViewController to generate fund details pages
 */
class FundSelectionDetailsPresenter: MFBasePresenter{
    
    weak var fundSelectionDetailsViewController: FundSelectionDetailsViewController!
    var fundSelectionDetailsInteractor: FundSelectionDetailsInteractor!
    
    private let FUND_SELECTION_FORM_VIEW_CONTROLLER = "FundSelectionFormViewController"
    
    init(fundSelectionDetailsViewController: FundSelectionDetailsViewController) {
        self.fundSelectionDetailsViewController = fundSelectionDetailsViewController
        fundSelectionDetailsInteractor = FundSelectionDetailsInteractor()
    }
    
    func fundSelectionData(managedObjectContext:NSManagedObjectContext, fundsWithAllocation: [String : Float], maxDuration: Int, riskAppetite: String) -> MFSelectionItem{
        return fundSelectionDetailsInteractor.getFundData(managedObjectContext: managedObjectContext, fundsWithAllocation: fundsWithAllocation, maxDuration: maxDuration, riskAppetite: riskAppetite)
    }
    
    func makeViewCircular(view: UIView){
        fundSelectionDetailsViewController.view.layoutIfNeeded()
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
    }
    
    ///Generates first page of fund details
    func page1View(mFSelectionItem: MFSelectionItem, scrollView: UIScrollView, pageWidth: CGFloat, pageHeight: CGFloat) -> UIView{
        let page1 = UIView()
        page1.backgroundColor = UIColor.white
        page1.frame = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder ) else {
            return page1
        }
        
        let topImageView = bundle.loadNibNamed("TopImageView", owner: self, options: nil)?[0] as! TopImageView
        topImageView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: (pageWidth*9/16))
        topImageView.topImageView.image = UIImage(named: mFSelectionItem.page1TopImage ?? "", in: bundle, compatibleWith: nil) ?? UIImage()
        topImageView.titleLabel.text = ""
        page1.addSubview(topImageView)
        
        let herolineView = bundle.loadNibNamed("HerolineView", owner: self, options: nil)?[0] as! HerolineView
        herolineView.heroLineLabel.text = mFSelectionItem.page1Heroline
        herolineView.frame = CGRect(x: 0, y: topImageView.frame.height, width: pageWidth, height: 50)
        page1.addSubview(herolineView)
        
        let suggestedInvestmentsLabel = UILabel(frame: CGRect(x: 16, y: herolineView.frame.maxY, width: pageWidth, height: 40))
        suggestedInvestmentsLabel.text = "Suggested Investment"
        suggestedInvestmentsLabel.textColor = UIColor.darkGray
        suggestedInvestmentsLabel.font = UIFont.systemFont(ofSize: 13)
        page1.addSubview(suggestedInvestmentsLabel)
        
        let fund1 = mFSelectionItem.fundItems.first
        let fund1InfoView = bundle.loadNibNamed("FundInfoView", owner: self, options: nil)?[0] as! FundInfoView
        fund1InfoView.frame = CGRect(x: 16, y: suggestedInvestmentsLabel.frame.maxY, width: pageWidth - 32, height: 70)
        fund1InfoView.firstLineLabel.text = "Invest \(String(format: "%.1f", fund1?.fundAllocation ?? 0))% in"
        fund1InfoView.secondLineLabel.text = fund1?.fundName ?? ""
        fund1InfoView.secondLineLabel.adjustsFontSizeToFitWidth = true
        fund1InfoView.fundInitials1Label.text = "\(String(format: "%.1f", fund1?.fundAllocation ?? 0))%"
        fund1InfoView.fundInitials2Label.text = fund1?.fundInitials ?? ""
        fund1InfoView.firstLineLabel.font = UIFont.systemFont(ofSize: 13)
        fund1InfoView.secondLineLabel.font = UIFont.boldSystemFont(ofSize: 13)
        page1.addSubview(fund1InfoView)
        
        if mFSelectionItem.fundItems.count > 1{
            let fund2 = mFSelectionItem.fundItems.last
            let fund2InfoView = bundle.loadNibNamed("FundInfoView", owner: self, options: nil)?[0] as! FundInfoView
            fund2InfoView.frame = CGRect(x: 16, y: fund1InfoView.frame.maxY + 10, width: pageWidth - 32, height: 70)
            fund2InfoView.firstLineLabel.text = "Invest \(String(format: "%.1f", fund2?.fundAllocation ?? 0))% in"
            fund2InfoView.secondLineLabel.text = fund2?.fundName ?? ""
            fund2InfoView.secondLineLabel.adjustsFontSizeToFitWidth = true
            fund2InfoView.fundInitials1Label.text = "\(String(format: "%.1f", fund2?.fundAllocation ?? 0))%"
            fund2InfoView.fundInitials2Label.text = fund2?.fundInitials ?? ""
            fund2InfoView.firstLineLabel.font = UIFont.systemFont(ofSize: 13)
            fund2InfoView.secondLineLabel.font = UIFont.boldSystemFont(ofSize: 13)
            page1.addSubview(fund2InfoView)
        }
        /*else{
            if let userData = KeyChainService.sharedInstance.getData(key: ConfigKeys.USER_DATA_KEY),let userDataObj =  NSKeyedUnarchiver.unarchiveObject(with: userData) as? UserData{
                let signatureView = bundle.loadNibNamed("SignatureView", owner: self, options: nil)?[0] as! SignatureView
                signatureView.signatureLabel.text = userDataObj.signature?.replacingOccurrences(of: ";", with: "\n")
                signatureView.signatureLabel.sizeToFit()
                let signatureHeight = signatureView.signatureLabel.frame.height + 25
                signatureView.frame = CGRect(x: 16, y: pageHeight - signatureHeight, width: pageWidth - 32, height: signatureHeight)
                page1.addSubview(signatureView)
            }
        }*/
        
        page1.addSubview(pageNumberLabel(pageNo: 1, pageWidth: pageWidth, pageHeight: pageHeight))
        return page1
    }
    
    func gotoFundSelectionForm(managedObjectContext:NSManagedObjectContext?, mFSelectionItem: MFSelectionItem?){
        var fundSelectionFormViewController: FundSelectionFormViewController?
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            fundSelectionFormViewController = FundSelectionFormViewController(nibName:FUND_SELECTION_FORM_VIEW_CONTROLLER, bundle: bundle)
            fundSelectionFormViewController?.mFSelectionItem = mFSelectionItem
            fundSelectionFormViewController?.managedObjectContext = managedObjectContext
            fundSelectionDetailsViewController.navigationController?.pushViewController(fundSelectionFormViewController!, animated: true)
        }
    }
    
}
