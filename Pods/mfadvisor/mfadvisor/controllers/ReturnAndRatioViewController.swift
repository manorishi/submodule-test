//
//  ReturnAndRatioViewController.swift
//  mfadvisor
//
//  Created by Apple on 09/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData

/**
 ReturnAndRatioViewController displays return and ratios of selected fund
 */
class ReturnAndRatioViewController: UIViewController {
    
    @IBOutlet weak var scrollViewContentHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var returnAndRatioScrollView: UIScrollView!
    public var managedObjectContext:NSManagedObjectContext?
    public var titleString: String?
    var selectedYears:(threeMonth:Bool, sixMonth:Bool, first:Bool, third:Bool, fifth:Bool)!
    var fundId:String!
    var metaFundData:MetaFundData?
    var metaFundDataLive:MetaFundDataLive?
    
    var returnAndRatioPresenter:ReturnAndRatioPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        returnAndRatioPresenter = ReturnAndRatioPresenter(returnAndRatioViewController: self)
        self.automaticallyAdjustsScrollViewInsets = false
        getReturnAndRatioData()
        addPages()
    }
    
    func addPages() {
        var frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 120)
        let firstPage = returnAndRatioPresenter.createFirstPage(frame: frame, fundData: metaFundData!, fundDataLive: metaFundDataLive!, fundName: titleString ?? "", fundId: fundId)
        scrollContentView.addSubview(firstPage)
        scrollViewContentHieghtConstraint.constant = firstPage.frame.size.height
        
        let seperator = returnAndRatioPresenter.seperatorView(frame:CGRect(x: 0, y: scrollViewContentHieghtConstraint.constant, width: UIScreen.main.bounds.size.width, height: 8))
        scrollContentView.addSubview(seperator)
        
        scrollViewContentHieghtConstraint.constant += seperator.frame.size.height
        
        frame = CGRect(x: 0, y: scrollViewContentHieghtConstraint.constant, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 120)
        let secondPage = returnAndRatioPresenter.createSecondPage(frame: frame, fundData: metaFundData!, fundDataLive: metaFundDataLive!, fundName: titleString ?? "")
        scrollContentView.addSubview(secondPage)
        
        scrollViewContentHieghtConstraint.constant += secondPage.frame.size.height
        
        let seperator2 = returnAndRatioPresenter.seperatorView(frame:CGRect(x: 0, y: scrollViewContentHieghtConstraint.constant, width: UIScreen.main.bounds.size.width, height: 8))
        scrollContentView.addSubview(seperator2)
        
        scrollViewContentHieghtConstraint.constant += seperator2.frame.size.height
        
        frame = CGRect(x: 0, y: scrollViewContentHieghtConstraint.constant, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 120)
        let thirdPage = returnAndRatioPresenter.createThirdPage(frame: frame, fundData: metaFundData!)
        scrollContentView.addSubview(thirdPage)
        
        scrollViewContentHieghtConstraint.constant += thirdPage.frame.size.height
        
    }
    
    func getReturnAndRatioData() {
        metaFundData = returnAndRatioPresenter.getFundData(fundId: fundId, managedObjectContext: managedObjectContext!)
        
        metaFundDataLive = returnAndRatioPresenter.getFundDataLive(fundId: fundId, managedObjectContext: managedObjectContext!)
    }

    @IBAction func clickedOnCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCloseButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
