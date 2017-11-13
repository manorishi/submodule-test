//
//  CustomNavigationViewController.swift
//  mfadvisor
//
//  Created by Apple on 12/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import XLPagerTabStrip

/**
 CustomNavigationViewController used to show page indicator title
 */
class CustomNavigationViewController: UINavigationController,IndicatorInfoProvider {

    var pagerTitle:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    init(rootViewController: UIViewController, pagerTitle:String) {
        super.init(rootViewController: rootViewController)
        self.pagerTitle = pagerTitle
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pagerTitle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
