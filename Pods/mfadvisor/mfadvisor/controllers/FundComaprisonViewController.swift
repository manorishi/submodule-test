//
//  FundComaprisonViewController.swift
//  mfadvisor
//
//  Created by Apple on 05/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData

/**
 FundComaprisonViewController shows funds with which user wants to compare selected fund
 It is shown as tab of FundDetailViewController
 */
class FundComaprisonViewController: UIViewController {

    @IBOutlet weak var scrollContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var compareFundsButton: UIButton!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var fundsScrollView: UIScrollView!
    @IBOutlet weak var fundNameLabel: UILabel!
    public var managedObjectContext:NSManagedObjectContext?
    private var fundComparisonPresenter:FundComaprisonPresenter!
    var selectedYears:(threeMonth:Bool, sixMonth:Bool, first:Bool, third:Bool, fifth:Bool) = (false,false,true,true,true)
    
    public var fundId:String!
    public var fundName:String?
    public var fundCategoryId:String!
    
    var otherFundsSelection:[String:Bool] = [:]
    var otherFundsDataArray:[MetaOtherFundMaster] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        fundComparisonPresenter = FundComaprisonPresenter(fundComparisonViewController: self)
        self.view.backgroundColor = MFColors.VIEW_BACKGROUND_COLOR
        fundNameLabel.text = fundName ?? ""
        fundComparisonPresenter.updateCreatePerformanceButton()
        getOtherFundsData()
        addOtherFundsWithCheckbox()
    }
    
    func getOtherFundsData() {
        fundCategoryId = fundComparisonPresenter.fundCategoryId(fundId: fundId, managedObjectContext: managedObjectContext!)
        otherFundsDataArray = fundComparisonPresenter.otherFundsData(fundCategoryId: fundCategoryId, managedObjectContext: managedObjectContext!)
    }
    
    func addOtherFundsWithCheckbox() {
        fundsScrollView.frame.size.width = UIScreen.main.bounds.size.width - 16
        let titleLabel = UILabel(frame: CGRect(x: 4, y: 0, width: UIScreen.main.bounds.size.width - 16, height: 21))
        titleLabel.backgroundColor = .clear
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.text = "SELECT_RELEVANT_FUNDS".localized
        scrollContentView.addSubview(titleLabel)
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            var originY:CGFloat = titleLabel.frame.origin.y + titleLabel.frame.height + 16
            for (index, otherFund) in otherFundsDataArray.enumerated() {
                let titleWithBox = bundle.loadNibNamed("TitleWithCheckbox", owner: self, options: nil)?[0] as! TitleWithCheckbox
                titleWithBox.checkboxButton.addTarget(self, action: #selector(clickedOnCheckbox(sender:)), for: .touchUpInside)
                titleWithBox.checkboxButton.isChecked = false
                titleWithBox.frame = CGRect(x: 0, y: originY, width: UIScreen.main.bounds.size.width - 16, height: 50)
                titleWithBox.checkboxButton.tag = index
                titleWithBox.updateTitle(string: otherFund.fund_name ?? "")
                originY += titleWithBox.frame.size.height
                otherFundsSelection[otherFund.other_fund_id ?? ""] = false
                self.scrollContentView.addSubview(titleWithBox)
            }
            self.scrollContentViewHeight.constant = originY + 8
        }
        addYearsWithCheckbox()
    }
    
    func addYearsWithCheckbox() {
        let titleLabel = UILabel(frame: CGRect(x: 4, y: self.scrollContentViewHeight.constant + 10, width: UIScreen.main.bounds.size.width - 16, height: 21))
        titleLabel.backgroundColor = .clear
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.text = "WHAT_DETAILS_TO_INCLUDE".localized
        scrollContentView.addSubview(titleLabel)
        
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            var originY:CGFloat = titleLabel.frame.origin.y + titleLabel.frame.height +  8
            var titles:[String] = []
            titles.append(NSLocalizedString("3_MONTHS_PERFORMANCE", tableName: nil, bundle: bundle, value: "", comment: ""))
            titles.append(NSLocalizedString("6_MONTHS_PERFORMANCE", tableName: nil, bundle: bundle, value: "", comment: ""))
            titles.append(NSLocalizedString("1_YEAR_PERFORMANCE", tableName: nil, bundle: bundle, value: "", comment: ""))
            titles.append(NSLocalizedString("3_YEAR_PERFORMANCE", tableName: nil, bundle: bundle, value: "", comment: ""))
            titles.append(NSLocalizedString("5_YEAR_PERFORMANCE", tableName: nil, bundle: bundle, value: "", comment: ""))
            for index in 0..<5 {
                let titleWithBox = bundle.loadNibNamed("TitleWithCheckbox", owner: self, options: nil)?[0] as! TitleWithCheckbox
                titleWithBox.checkboxButton.addTarget(self, action: #selector(clickedOnYearsCheckbox(sender:)), for: .touchUpInside)
                titleWithBox.checkboxButton.isChecked = Bool((index >> 1) as NSNumber)
                titleWithBox.frame = CGRect(x: 0, y: originY, width: UIScreen.main.bounds.size.width - 16, height: 60)
                titleWithBox.checkboxButton.tag = index
                titleWithBox.updateTitle(string: titles[index])
                originY += titleWithBox.frame.size.height
                scrollContentView.addSubview(titleWithBox)
            }
            self.scrollContentViewHeight.constant = originY + 8
        }
    }
    
    func clickedOnYearsCheckbox(sender: CheckBox) {
        let tag = sender.tag
        switch tag {
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
        fundComparisonPresenter.updateCreatePerformanceButton()
    }
    
    func clickedOnCheckbox(sender: CheckBox) {
        let tag = sender.tag
        let otherFundData = otherFundsDataArray[tag]
        otherFundsSelection[otherFundData.other_fund_id ?? ""] = sender.isChecked
        fundComparisonPresenter.updateCreatePerformanceButton()
    }

    @IBAction func clickedOnCompareFunds(_ sender: Any) {
        if let targetVC = fundComparisonPresenter.fundComaprisonDetailViewControllerObject() {
            targetVC.otherFundsSelected = fundComparisonPresenter.getSelectedFundsData()
            targetVC.fundId = fundId
            targetVC.fundName = fundName
            targetVC.selectedYears = selectedYears
            targetVC.otherFundDataMasterArray = otherFundsDataArray
            self.navigationController?.pushViewController(targetVC, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
