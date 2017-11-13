//
//  SwpCalDetailsViewController.swift
//  mfadvisor
//
//  Created by Anurag Dake on 08/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

class SwpCalDetailsViewController: UIViewController{
    
    @IBOutlet weak var swpCalDetailsScrollview: UIScrollView!
    @IBOutlet weak var swpCalculatorContentView: UIView!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    var swpCalDetailsPresenter: SwpCalDetailsPresenter!
    public var swpOutput: SWPOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swpCalDetailsPresenter = SwpCalDetailsPresenter()
        initialiseUI()
    }
    
    func initialiseUI(){
        guard let sipOutputData = swpOutput else {
            return
        }
        let screenWidth = UIScreen.main.bounds.width
        let scrollViewHeight = UIScreen.main.bounds.maxY - swpCalDetailsScrollview.frame.origin.y
        
        let calculationDetailspage = swpCalDetailsPresenter.calculationsView(swpOutput: sipOutputData, scrollView: swpCalDetailsScrollview, pageWidth: screenWidth, pageHeight: scrollViewHeight)
        swpCalculatorContentView.addSubview(calculationDetailspage)
        
        scrollViewHeightConstraint.constant = calculationDetailspage.frame.size.height
    }
    
    @IBAction func onCloseButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
