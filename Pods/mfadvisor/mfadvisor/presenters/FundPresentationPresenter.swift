//
//  FundPresentationPresenter.swift
//  mfadvisor
//
//  Created by Anurag Dake on 08/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core
import CoreData

/**
 FundPresentationPresenter handle UI logic for FundPresentationViewController to generate fund presentation pages
 */
class FundPresentationPresenter: MFBasePresenter {
    
    weak var fundPresentationViewController: FundPresentationViewController!
    var fundPresentationInteractor: FundPresentationInteractor!
    private let INVESTMENT_STRATEGY = "Investment Strategy"
    private let PORTFOLIO_ALLOCATION = "Portfolio Allocation"
    
    init(fundPresentationViewController: FundPresentationViewController) {
        self.fundPresentationViewController = fundPresentationViewController
        fundPresentationInteractor = FundPresentationInteractor()
    }
    
    func makeViewCircular(view: UIView){
        fundPresentationViewController.view.layoutIfNeeded()
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
    }
    
    ///Generates first page of presentation
    func page1View(mFSelectionItem: MFSelectionItem, scrollView: UIScrollView, pageWidth: CGFloat, pageHeight: CGFloat, customerName: String?) -> UIView{
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
        
        //let herolineText = "A personalised investment presentation \((customerName != nil && customerName != "") ? "for \(customerName!)" : "")"
        let herolineText = "Investment Presentation"
        let herolineView = bundle.loadNibNamed("HerolineView", owner: self, options: nil)?[0] as! HerolineView
        herolineView.heroLineLabel.text = herolineText
        herolineView.frame = CGRect(x: 0, y: topImageView.frame.height, width: pageWidth, height: 50)
        page1.addSubview(herolineView)
        
        let suggestedInvestmentsLabel = UILabel(frame: CGRect(x: 16, y: herolineView.frame.maxY, width: pageWidth, height: 40))
        suggestedInvestmentsLabel.text = "Suggested Investment"
        suggestedInvestmentsLabel.textColor = UIColor.darkGray
        suggestedInvestmentsLabel.font = UIFont.systemFont(ofSize: 13)
        page1.addSubview(suggestedInvestmentsLabel)
        
        var isFund1Available = false
        let fund1 = mFSelectionItem.fundItems.first
        let fund1DetailsView = bundle.loadNibNamed("FundDetailsView", owner: self, options: nil)?[0] as! FundDetailsView
        if fund1?.lumpSum != nil || fund1?.sip != nil{
            fund1DetailsView.frame = CGRect(x: 16, y: suggestedInvestmentsLabel.frame.maxY, width: pageWidth - 32, height: fundDetailsViewHeight(lumpSum: fund1?.lumpSum, sip: fund1?.sip))
            fund1DetailsView.fundNameLabel.text = fund1?.fundName ?? ""
            fund1DetailsView.fundNameLabel.adjustsFontSizeToFitWidth = true
            fund1DetailsView.fundInitialsLabel.text = fund1?.fundInitials ?? ""
            let texts = lumpSumAndSIPTexts(lumpSum: fund1?.lumpSum, sip: fund1?.sip)
            fund1DetailsView.line2Label.text = texts.firstLine
            fund1DetailsView.line3Label.text = texts.secondLine
            page1.addSubview(fund1DetailsView)
            isFund1Available = true
        }
        
//        var isFund2Available = false
        if mFSelectionItem.fundItems.count > 1{
            let fund2 = mFSelectionItem.fundItems.last
            if fund2?.lumpSum != nil || fund2?.sip != nil{
                let fund2DetailsView = bundle.loadNibNamed("FundDetailsView", owner: self, options: nil)?[0] as! FundDetailsView
                fund2DetailsView.frame = CGRect(x: 16, y: (isFund1Available ? fund1DetailsView.frame.maxY : suggestedInvestmentsLabel.frame.maxY) + 10, width: pageWidth - 32, height: fundDetailsViewHeight(lumpSum: fund2?.lumpSum, sip: fund2?.sip))
                fund2DetailsView.fundNameLabel.text = fund2?.fundName ?? ""
                fund2DetailsView.fundNameLabel.adjustsFontSizeToFitWidth = true
                fund2DetailsView.fundInitialsLabel.text = fund2?.fundInitials ?? ""
                let texts = lumpSumAndSIPTexts(lumpSum: fund2?.lumpSum, sip: fund2?.sip)
                fund2DetailsView.line2Label.text = texts.firstLine
                fund2DetailsView.line3Label.text = texts.secondLine
                page1.addSubview(fund2DetailsView)
//                isFund2Available = true
            }
            
        }
        /*if !isFund2Available{
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
    
    ///Generates investment strategy page
    func investmentStrategyPage(fundId: String, fundName: String, scrollView: UIScrollView, pageWidth: CGFloat, pageHeight: CGFloat, pageNumber: Int, managedObjectContext: NSManagedObjectContext) -> UIView{
        let investmentStrategyPage = UIView()
        investmentStrategyPage.backgroundColor = UIColor.white
        investmentStrategyPage.frame = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder ) else {
            return investmentStrategyPage
        }
        let answers = fundPresentationInteractor.investmentStrategy(managedObjectContext: managedObjectContext, fundId: fundId)
        
        let topImageView = bundle.loadNibNamed("TopImageView", owner: self, options: nil)?[0] as! TopImageView
        topImageView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: (pageWidth*9/16))
        topImageView.topImageView.image = UIImage(named: "strategy_top.jpg", in: bundle, compatibleWith: nil) ?? UIImage()
        topImageView.titleLabel.text = fundName
        investmentStrategyPage.addSubview(topImageView)
        
        let herolineView = bundle.loadNibNamed("HerolineView", owner: self, options: nil)?[0] as! HerolineView
        herolineView.frame = CGRect(x: 0, y: topImageView.frame.maxY, width: pageWidth, height: 50)
        herolineView.heroLineLabel.text = INVESTMENT_STRATEGY
        investmentStrategyPage.addSubview(herolineView)
        
        var viewJustAbove : UIView = herolineView
        for answer in answers.answers{
            let specialityLineView = answerView(bundle: bundle, viewJustAbove: viewJustAbove, pageWidth: pageWidth, answerIcon: answer.icon, answerLine: answer.answer)
            investmentStrategyPage.addSubview(specialityLineView)
            viewJustAbove = specialityLineView
        }
        
        let pageNoLabel = pageNumberLabel(pageNo: pageNumber, pageWidth: pageWidth, pageHeight: pageHeight)
        investmentStrategyPage.addSubview(pageNoLabel)
        
        let disclaimerView = disclaimerLabel(disclaimertext: answers.disclaimer, pageWidth: pageWidth, pageNumberLabelY: pageNoLabel.frame.origin.y)
        investmentStrategyPage.addSubview(disclaimerView)
        return investmentStrategyPage
    }
    
    ///Generates portfolio allocation page
    func portfolioAllocationPage(fundId: String, fundName: String, scrollView: UIScrollView, pageWidth: CGFloat, pageHeight: CGFloat, pageNumber: Int, managedObjectContext: NSManagedObjectContext) -> UIView{
        let portfolioAllocationPage = UIView()
        portfolioAllocationPage.backgroundColor = UIColor.white
        portfolioAllocationPage.frame = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder ) else {
            return portfolioAllocationPage
        }
        let answers = fundPresentationInteractor.portfolioAllocation(managedObjectContext: managedObjectContext, fundId: fundId)
        
        let topImageView = bundle.loadNibNamed("TopImageView", owner: self, options: nil)?[0] as! TopImageView
        topImageView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: (pageWidth*9/16))
        topImageView.topImageView.image = UIImage(named: "portfolio_top.jpg", in: bundle, compatibleWith: nil) ?? UIImage()
        topImageView.titleLabel.text = fundName
        portfolioAllocationPage.addSubview(topImageView)
        
        let herolineView = bundle.loadNibNamed("HerolineView", owner: self, options: nil)?[0] as! HerolineView
        herolineView.frame = CGRect(x: 0, y: topImageView.frame.maxY, width: pageWidth, height: 50)
        herolineView.heroLineLabel.text = PORTFOLIO_ALLOCATION
        portfolioAllocationPage.addSubview(herolineView)
        
        var viewJustAbove : UIView = herolineView
        for answer in answers.answers{
            let specialityLineView = answerView(bundle: bundle, viewJustAbove: viewJustAbove, pageWidth: pageWidth, answerIcon: answer.icon, answerLine: answer.answer)
            portfolioAllocationPage.addSubview(specialityLineView)
            viewJustAbove = specialityLineView
        }
        
        let pageNoLabel = pageNumberLabel(pageNo: pageNumber, pageWidth: pageWidth, pageHeight: pageHeight)
        portfolioAllocationPage.addSubview(pageNoLabel)
        
        let disclaimerView = disclaimerLabel(disclaimertext: answers.disclaimer, pageWidth: pageWidth, pageNumberLabelY: pageNoLabel.frame.origin.y)
        portfolioAllocationPage.addSubview(disclaimerView)
        return portfolioAllocationPage
    }
    
    func answerView(bundle: Bundle, viewJustAbove: UIView, pageWidth: CGFloat, answerIcon: String?, answerLine: NSAttributedString) -> SpecialityLineView{
        let specialityLineView = bundle.loadNibNamed("SpecialityLineView", owner: self, options: nil)?[0] as! SpecialityLineView
        specialityLineView.frame = CGRect(x: 0, y: viewJustAbove.frame.maxY + 8, width: pageWidth, height: 60)
        specialityLineView.specialityIconImageView.image = UIImage(named: answerIcon ?? "", in: bundle, compatibleWith: nil) ?? UIImage()
        specialityLineView.specialityTextLabel.attributedText = answerLine
        return specialityLineView
    }
    
    func fundDetailsViewHeight(lumpSum: Double?, sip: Float?) -> CGFloat{
        if lumpSum != nil && sip != nil{
            return 90
        }
        return 70
    }
    
    func lumpSumAndSIPTexts(lumpSum: Double?, sip: Float?) -> (firstLine: String, secondLine: String){
        var lumpSumString = ""
        var sipString = ""
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if lumpSum != nil{
            lumpSumString = "Lumpsum: ₹" + (numberFormatter.string(from: NSNumber(value:Int(lumpSum!))) ?? "")
            if sip != nil{
                sipString = "SIP: ₹" + (numberFormatter.string(from: NSNumber(value:Int(sip ?? 0))) ?? "")
            }
        }else{
            lumpSumString = "SIP: ₹" + (numberFormatter.string(from: NSNumber(value:Int(sip ?? 0))) ?? "")
        }
        
        return (lumpSumString, sipString)
    }
    
    func updateShareCount(){
        fundPresentationInteractor.incrementPresentationShareCount {[weak self] (responseStatus, responseData) in
            DispatchQueue.main.async {
                switch responseStatus{
                case .success:
                    if let shareCount: Int = responseData?["presentations_shared"] as? Int {
                        self?.fundPresentationInteractor.updatePresentationShareCount(count: shareCount)
                        self?.fundPresentationInteractor.deletePendingShareCount()
                        self?.sendShareCountUpdateNotification()
                    }
                case .error:
                    self?.fundPresentationInteractor.updatePresentationsToShareCount()
                    self?.sendShareCountUpdateNotification()
                    
                case .forbidden: break
                default: break
                }
            }
        }
    }
    
    private func sendShareCountUpdateNotification(){
        NotificationCenter.default.post(name: AppNotificationConstants.PRESENTATION_SHARE_COUNT_UPDATE_NOTIFICATION, object: nil)
    }
}
