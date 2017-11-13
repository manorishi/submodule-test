//
//  FundSelectionDetailsViewController.swift
//  mfadvisor
//
//  Created by Anurag Dake on 03/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core
import Floaty

/**
 FundSelectionDetailsViewController shows selected fund details with required pages
 */
class FundSelectionDetailsViewController: UIViewController{
    
    @IBOutlet weak var fundSelectionScrollView: UIScrollView!
    @IBOutlet weak var fundSelectionScrollContentView: UIView!
    @IBOutlet weak var scrollContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var floatingCreateButton: UIButton!
    
    var fundSelectionDetailsPresenter: FundSelectionDetailsPresenter!
    var managedObjectContext:NSManagedObjectContext?
    
    var fundsWithAllocation: [String : Float]?
    var maxDuration: Int?
    var riskAppetite: String?
    var mFSelectionItem: MFSelectionItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fundSelectionDetailsPresenter = FundSelectionDetailsPresenter(fundSelectionDetailsViewController: self)
        initialise()
        addFloatingButtons()
    }
    
    func initialise(){
        fundSelectionDetailsPresenter.makeViewCircular(view: floatingCreateButton)
        fetchFundSelectionData()
        initialiseUI()
    }
    
    func fetchFundSelectionData(){
        if fundsWithAllocation != nil && maxDuration != nil && riskAppetite != nil && managedObjectContext != nil && mFSelectionItem == nil {
            mFSelectionItem = fundSelectionDetailsPresenter.fundSelectionData(managedObjectContext: managedObjectContext!, fundsWithAllocation: fundsWithAllocation!, maxDuration: maxDuration!, riskAppetite: riskAppetite!)
        }
    }
    
    ///displays generated pages one after another
    func initialiseUI(){
        guard let selectionItem = mFSelectionItem else {
            return
        }
        let screenWidth = UIScreen.main.bounds.width
        let scrollViewHeight = UIScreen.main.bounds.maxY - fundSelectionScrollView.frame.origin.y
        scrollContentViewHeight.constant = 0
        
        let page1 = fundSelectionDetailsPresenter.page1View(mFSelectionItem: selectionItem, scrollView: fundSelectionScrollView, pageWidth: screenWidth, pageHeight: scrollViewHeight)
        fundSelectionScrollContentView.addSubview(page1)
        
        let seperator1 = fundSelectionDetailsPresenter.seperatorView(x: 0, y: page1.frame.maxY, width: screenWidth)
        fundSelectionScrollContentView.addSubview(seperator1)
        
        var lastFundSeperatorView: UIView!
        for (index, fund) in (mFSelectionItem?.fundItems ?? []).enumerated() {
            let fundPage = fundSelectionDetailsPresenter.pageFundView(fundItem: fund, scrollView: fundSelectionScrollView, pageWidth: screenWidth, pageHeight: scrollViewHeight, pageNumber: index + 2)
            fundPage.frame = CGRect(x: 0, y: index == 0 ? seperator1.frame.maxY : lastFundSeperatorView.frame.maxY, width: screenWidth, height: scrollViewHeight)
            
            fundSelectionScrollContentView.addSubview(fundPage)
            
            let seperator = fundSelectionDetailsPresenter.seperatorView(x: 0, y: fundPage.frame.maxY, width: screenWidth)
            fundSelectionScrollContentView.addSubview(seperator)
            
            scrollContentViewHeight.constant = scrollContentViewHeight.constant + fundPage.frame.height + seperator.frame.height
            lastFundSeperatorView = seperator
        }
        let tenureAndLiquidityPage = fundSelectionDetailsPresenter.tenureAndLiquidityPageView(mFSelectionItem: selectionItem, scrollView: fundSelectionScrollView, pageWidth: screenWidth, pageHeight: scrollViewHeight, pageNumber: ((mFSelectionItem?.fundItems ?? []).count > 1) ? 4 : 3)
        tenureAndLiquidityPage.frame = CGRect(x: 0, y: lastFundSeperatorView.frame.maxY, width: screenWidth, height: tenureAndLiquidityPage.frame.height)
        fundSelectionScrollContentView.addSubview(tenureAndLiquidityPage)
        
        scrollContentViewHeight.constant = scrollContentViewHeight.constant + page1.frame.height + seperator1.frame.height + tenureAndLiquidityPage.frame.height
        
        if (mFSelectionItem?.fundItems ?? []).count > 1{
            let seperator2 = fundSelectionDetailsPresenter.seperatorView(x: 0, y: tenureAndLiquidityPage.frame.maxY, width: screenWidth)
            fundSelectionScrollContentView.addSubview(seperator2)
            
            let riskometerPage = fundSelectionDetailsPresenter.riskometerPageView(mFSelectionItem: selectionItem, scrollView: fundSelectionScrollView, pageWidth: screenWidth, pageHeight: scrollViewHeight, pageNumber: 5)
            riskometerPage.frame = CGRect(x: 0, y: seperator2.frame.maxY, width: screenWidth, height: scrollViewHeight)
            fundSelectionScrollContentView.addSubview(riskometerPage)
            
            scrollContentViewHeight.constant = scrollContentViewHeight.constant + seperator2.frame.height + riskometerPage.frame.height
        }
        
    }
    
    @IBAction func onHomeButtonTap(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onFloatingCreateTap(_ sender: UIButton) {
        fundSelectionDetailsPresenter.gotoFundSelectionForm(managedObjectContext: managedObjectContext, mFSelectionItem: mFSelectionItem)
    }
    
    
    @IBAction func onBackPress(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

extension FundSelectionDetailsViewController{
    
    func addFloatingButtons(){
        let floaty = Floaty()
        floaty.openAnimationType = .pop
        floaty.buttonColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
        floaty.itemImageColor = UIColor.white
        floaty.plusColor = UIColor.white
        floaty.autoCloseOnTap = true
        floaty.addItem(item: faqButton())
        floaty.addItem(item: performanceButton())
        self.view.addSubview(floaty)
    }
    
    private func faqButton() -> FloatyItem{
        let faqButton = floatyButton(title: " FAQs ", iconName: "ic_fab_faq")
        faqButton.handler = { [weak self] item in
            self?.gotoFundInformationVC(fundOptionType: .salesPitch)
        }
        return faqButton
    }
    
    private func performanceButton() -> FloatyItem{
        let performanceButton = floatyButton(title: "Detailed Performance", iconName: "ic_fab_performance")
        performanceButton.handler = { [weak self] item in
            self?.gotoFundInformationVC(fundOptionType: .performance)
        }
        return performanceButton
    }
    
    func gotoFundInformationVC(fundOptionType: FundOptionsType){
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else { return }
        
        let fundInformationVC = FundInformationViewController(nibName: "FundInformationViewController", bundle: bundle)
        fundInformationVC.managedObjectContext = managedObjectContext
        fundInformationVC.fundOptionType = fundOptionType
        if let fundIds = fundsWithAllocation?.keys{
            fundInformationVC.fundIds = Array(fundIds)
        }
        self.navigationController?.pushViewController(fundInformationVC, animated: true)
    }
    
    func floatyButton(title: String?, iconName: String?) -> FloatyItem{
        let fabButton = FloatyItem()
        fabButton.imageSize = CGSize(width: 20, height: 20)
        fabButton.buttonColor = hexStringToUIColor(hex: MFColors.FAB_BUTTON_COLOR)
        fabButton.title = title
        fabButton.titleLabel.textAlignment = .center
        fabButton.titleLabel.font = UIFont.systemFont(ofSize: 14)
        fabButton.icon = UIImage(named: iconName ?? "", in: BundleManager().loadResourceBundle(), compatibleWith: nil)
        fabButton.iconImageView.contentMode = .scaleAspectFit
        fabButton.titleLabel.backgroundColor = UIColor.darkGray
        return fabButton
    }
    
    
    
}
