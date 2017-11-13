//
//  FundDetailViewController.swift
//  mfadvisor
//
//  Created by Apple on 04/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Core
import CoreData

/**
 FundDetailViewController shows differnt possible operation on selected fund in tab format and handle respective navigation to pages
 */
class FundDetailViewController:  ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var fundDetailTitleLabel: UILabel!
    public var managedObjectContext:NSManagedObjectContext?
    public var titleString:String?
    public var fundId:String!
    
    var fundDetailPresenter:FundDetailPresenter!

    override func viewDidLoad() {
        setupPagerTab()
        fundDetailPresenter = FundDetailPresenter(fundDetailViewController: self)
        super.viewDidLoad()
        self.view.backgroundColor = MFColors.VIEW_BACKGROUND_COLOR
        updateFundName()
    }
    
    func updateFundName() {
        if titleString == nil {
            titleString = fundDetailPresenter.fundNameFrom(fundId: fundId, managedObjectContext: managedObjectContext!)
        }
        fundDetailTitleLabel.text = titleString ?? ""
    }
    
    func setupPagerTab() {
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = UIColor(red: 0.74, green: 0.24, blue: 0.45, alpha: 1.0)
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 0.74, green: 0.24, blue: 0.45, alpha: 1.0)
        settings.style.selectedBarBackgroundColor = UIColor.white
        if #available(iOS 8.2, *) {
            settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 11, weight: UIFontWeightSemibold)
        } else {
            settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 12)
        }
        settings.style.selectedBarHeight = 1.5
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarLeftContentInset = 2
        settings.style.buttonBarRightContentInset = 6
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.init(white: 0.8, alpha: 0.9)
            newCell?.label.textColor = UIColor.white
        }
    }
    
    override func configureCell(_ cell: ButtonBarViewCell, indicatorInfo: IndicatorInfo) {
        cell.label.numberOfLines = 0
        cell.label.adjustsFontSizeToFitWidth = true
        cell.label.textAlignment = .center
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder)
        var controllersArray:[UIViewController] = []
        if let salesPitchVC = fundDetailPresenter.salesPitchViewControllerObject(managedObjectContext: managedObjectContext!, fundId: fundId, fundName: titleString) {
            controllersArray.append(salesPitchVC)
        }
        
        if let performanceVC = fundDetailPresenter.performanceViewControllerObject(managedObjectContext: managedObjectContext!, fundId: fundId, fundName: titleString) {
            let navigationController = CustomNavigationViewController(rootViewController: performanceVC, pagerTitle: NSLocalizedString("RETURN_AND_RATIO", tableName: nil, bundle: bundle!, value: "", comment: ""))
            controllersArray.append(navigationController)
        }
        
        if let fundComparisonVC = fundDetailPresenter.fundComaprisonViewControllerObject(managedObjectContext: managedObjectContext!, fundId: fundId, fundName: titleString) {
            let navigationController = CustomNavigationViewController(rootViewController: fundComparisonVC, pagerTitle: NSLocalizedString("COMPARE_FUNDS", tableName: nil, bundle: bundle!, value: "", comment: ""))
            controllersArray.append(navigationController)
        }
        
        if let presentationVC = fundDetailPresenter.presentationViewControllerObject(managedObjectContext: managedObjectContext!, fundId: fundId, fundName: titleString) {
            let navigationController = CustomNavigationViewController(rootViewController: presentationVC, pagerTitle: NSLocalizedString("CREATE_PRESENTATION", tableName: nil, bundle: bundle!, value: "", comment: ""))
            controllersArray.append(navigationController)
        }
        
        if let swpCalculatorVC = fundDetailPresenter.swpCalculatorViewControllerObject(managedObjectContext: managedObjectContext!, fundId: fundId, fundName: titleString) {
            let navigationController = CustomNavigationViewController(rootViewController: swpCalculatorVC, pagerTitle: NSLocalizedString("SWP_CALCULATOR", tableName: nil, bundle: bundle!, value: "", comment: ""))
            controllersArray.append(navigationController)
        }
        
        if let sipCalculatorVC = fundDetailPresenter.sipCalculatorViewControllerObject(managedObjectContext: managedObjectContext!, fundId: fundId, fundName: titleString) {
            let navigationController = CustomNavigationViewController(rootViewController: sipCalculatorVC, pagerTitle: NSLocalizedString("SIP_CALCULATOR", tableName: nil, bundle: bundle!, value: "", comment: ""))
            controllersArray.append(navigationController)
        }
        return controllersArray
    }
    
    public func moveToSalesPitchViewController() {
        moveToViewController(at: 0, animated: false)
    }
    
    public func moveToPerformanceViewController() {
        moveToViewController(at: 1, animated: false)
    }
    
    public func moveToFundComparisonViewController() {
        moveToViewController(at: 2, animated: false)
    }
    
    public func moveToPresentationViewController() {
        moveToViewController(at: 3, animated: false)
    }
    
    public func moveToSWPCalculatorViewController() {
        moveToViewController(at: 4, animated: false)
    }
    
    public func moveToSIPCalculatorViewController() {
        moveToViewController(at: 5, animated: false)
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onHomeButtonTap(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
