//
//  FundInformationViewController.swift
//  mfadvisor
//
//  Created by Anurag Dake on 28/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import XLPagerTabStrip

public class FundInformationViewController: ButtonBarPagerTabStripViewController{
    
    @IBOutlet weak var pageTitleLabel: UILabel!
    public var managedObjectContext: NSManagedObjectContext?
    public var fundIds: [String]!
    public var fundOptionType:FundOptionsType? = nil
    
    var fundInformationPresenter: FundInformationPresenter!
    
    override public func viewDidLoad() {
        setupPagerTab()
        fundInformationPresenter = FundInformationPresenter()
        super.viewDidLoad()
        setPageTitle()
    }
    
    func setPageTitle(){
        guard let type = fundOptionType, let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else { return }
        switch type {
        case .salesPitch:
            pageTitleLabel.text = NSLocalizedString("SALES_PITCH", tableName: nil, bundle: bundle, value: "", comment: "")
            
        case .performance:
            pageTitleLabel.text = NSLocalizedString("DETAILED_PERFORMANCE", tableName: nil, bundle: bundle, value: "", comment: "")
            
        default: break
        }
    }
    
    func fundNames() -> [String]{
        var fundNames = [String]()
        for id in fundIds{
            if let fundName = fundInformationPresenter.fundNameFrom(fundId: id, managedObjectContext: managedObjectContext!){
                fundNames.append(fundName)
            }
        }
        return fundNames
    }
    
    func setupPagerTab() {
        settings.style.buttonBarBackgroundColor = UIColor(red: 0.74, green: 0.24, blue: 0.45, alpha: 1.0)
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 0.74, green: 0.24, blue: 0.45, alpha: 1.0)
        settings.style.selectedBarBackgroundColor = UIColor.white
        if #available(iOS 8.2, *) {
            settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
        } else {
            settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 13)
        }
        settings.style.selectedBarHeight = 1.5
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarLeftContentInset = 2
        settings.style.buttonBarRightContentInset = 6
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.init(white: 0.8, alpha: 0.9)
            newCell?.label.textColor = UIColor.white
        }
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        guard let type = fundOptionType else { return [] }
        var controllersArray:[UIViewController] = []
        let funds = fundNames()
        
        for i in 0..<fundIds.count{
            switch type {
            case .salesPitch:
                if let salesPitchVC = fundInformationPresenter.salesPitchViewControllerObject(managedObjectContext: managedObjectContext!, fundId: fundIds[i], fundName: funds[i]) {
                    salesPitchVC.tabTitle = funds[i]
                    controllersArray.append(salesPitchVC)
                }
                
            case .performance:
                if let performanceVC = fundInformationPresenter.performanceViewControllerObject(managedObjectContext: managedObjectContext!, fundId: fundIds[i], fundName: funds[i]) {
                    let navigationController = CustomNavigationViewController(rootViewController: performanceVC, pagerTitle: funds[i])
                    controllersArray.append(navigationController)
                }
                
            default: break
            }
        }
    
        return controllersArray
    }
    
    override public func configureCell(_ cell: ButtonBarViewCell, indicatorInfo: IndicatorInfo) {
        cell.label.numberOfLines = 0
        cell.label.adjustsFontSizeToFitWidth = false
        cell.label.textAlignment = .center
    }
    
    @IBAction func onBackButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onHomeButtonTap(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
