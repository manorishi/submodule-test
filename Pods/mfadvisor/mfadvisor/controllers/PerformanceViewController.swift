//
//  PerformanceViewController.swift
//  mfadvisor
//
//  Created by Apple on 05/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core

/**
 PerformanceViewController shows options to display fund performance data for selected fund
 It is shown as tab of FundDetailViewController
 */
class PerformanceViewController: UIViewController {
    
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var yearsContainerView: UIView!
    @IBOutlet weak var performanceButton: UIButton!
    public var managedObjectContext:NSManagedObjectContext?
    private var performancePresenter:PerformancePresenter!
    var selectedYears:(threeMonth:Bool, sixMonth:Bool, first:Bool, third:Bool, fifth:Bool) = (false,false,true,true,true)
    
    public var fundId:String!
    public var fundName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        performancePresenter = PerformancePresenter(performanceViewController: self)
        fundNameLabel.text = fundName ?? ""
        self.view.backgroundColor = MFColors.VIEW_BACKGROUND_COLOR
        addYearsWithCheckbox()
        performancePresenter.updateCreatePerformanceButton()
    }
    
    func addYearsWithCheckbox() {
        yearsContainerView.frame.size.width = UIScreen.main.bounds.size.width - 16
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            var originY:CGFloat = 0
            var titles:[String] = []
            titles.append(NSLocalizedString("3_MONTHS_PERFORMANCE", tableName: nil, bundle: bundle, value: "", comment: ""))
            titles.append(NSLocalizedString("6_MONTHS_PERFORMANCE", tableName: nil, bundle: bundle, value: "", comment: ""))
            titles.append(NSLocalizedString("1_YEAR_PERFORMANCE", tableName: nil, bundle: bundle, value: "", comment: ""))
            titles.append(NSLocalizedString("3_YEAR_PERFORMANCE", tableName: nil, bundle: bundle, value: "", comment: ""))
            titles.append(NSLocalizedString("5_YEAR_PERFORMANCE", tableName: nil, bundle: bundle, value: "", comment: ""))
            for index in 0..<5 {
                let titleWithBox = bundle.loadNibNamed("TitleWithCheckbox", owner: self, options: nil)?[0] as! TitleWithCheckbox
                titleWithBox.checkboxButton.addTarget(self, action: #selector(clickedOnCheckbox(sender:)), for: .touchUpInside)
                titleWithBox.checkboxButton.isChecked = Bool((index >> 1) as NSNumber)
                titleWithBox.frame = CGRect(x: 0, y: originY, width: UIScreen.main.bounds.size.width - 16, height: 60)
                titleWithBox.checkboxButton.tag = index
                titleWithBox.updateTitle(string: titles[index])
                originY += titleWithBox.frame.size.height
                self.yearsContainerView.addSubview(titleWithBox)
            }
        }
    }
    
    func clickedOnCheckbox(sender: CheckBox) {
        let tag = sender.tag
        switch  tag{
        case 0:
            selectedYears.threeMonth = sender.isChecked
        case 1:
            selectedYears.sixMonth = sender.isChecked
        case 2:
            selectedYears.first = sender.isChecked
        case 3:
            selectedYears.third = sender.isChecked
        case 4:
            selectedYears.fifth = sender.isChecked
        default:
            break
        }
        performancePresenter.updateCreatePerformanceButton()
    }
    
    @IBAction func clickedOnPerformanceButton(_ sender: Any) {
        if let targetVC = performancePresenter.returnAndRatioViewController() {
            targetVC.fundId = fundId
            targetVC.titleString = fundName
            targetVC.selectedYears = selectedYears
            gotoViewController(targetVC)
        }
    }
    
    func gotoViewController(_ viewController:UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
