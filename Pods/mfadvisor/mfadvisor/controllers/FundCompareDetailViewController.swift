//
//  FundCompareDetailViewController.swift
//  mfadvisor
//
//  Created by Apple on 12/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData

/**
 FundCompareDetailViewController displays fund comparison in tabular format
 */
class FundCompareDetailViewController: UIViewController {

    @IBOutlet weak var scrollContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var fundCompareScrollView: UIScrollView!
    public var managedObjectContext:NSManagedObjectContext?
    var fundCompareDetailPresenter:FundCompareDetailPresenter!
    var fundName:String!
    var fundId:String!
    var otherFundsSelected:[String:String] = [:]
    var selectedYears:(threeMonth:Bool, sixMonth:Bool, first:Bool, third:Bool, fifth:Bool)!
    var otherFundDataMasterArray:[MetaOtherFundMaster] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        fundCompareDetailPresenter = FundCompareDetailPresenter(fundCompareDetailViewController: self)
        createFundComaprisonPage()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func createFundComaprisonPage() {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 120)
        let pageView = fundCompareDetailPresenter.createFundComparePage(frame: frame,fundName:fundName,fundId:fundId, otherFundDataMasterArray: otherFundDataMasterArray, managedObjectContext:managedObjectContext!)
        scrollContentView.addSubview(pageView)
        scrollContentViewHeight.constant = pageView.frame.size.height
    }

    @IBAction func onCloseButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
