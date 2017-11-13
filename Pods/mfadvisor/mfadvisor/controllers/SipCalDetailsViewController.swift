//
//  SipCalDetailsViewController.swift
//  mfadvisor
//
//  Created by Anurag Dake on 08/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

class SipCalDetailsViewController: UIViewController{
    
    @IBOutlet weak var sipCalDetailsScrollview: UIScrollView!
    @IBOutlet weak var sipCalculatorContentView: UIView!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    public var sipOutput: SIPOutput?
    
    var sipCalDetailsPresenter: SipCalDetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sipCalDetailsPresenter = SipCalDetailsPresenter()
        initialiseUI()
    }
    
    func initialiseUI(){
        guard let sipOutputData = sipOutput else {
            return
        }
        let screenWidth = UIScreen.main.bounds.width
        let scrollViewHeight = UIScreen.main.bounds.maxY - sipCalDetailsScrollview.frame.origin.y

        let calculationDetailspage = sipCalDetailsPresenter.calculationsView(sipoutput: sipOutputData, scrollView: sipCalDetailsScrollview, pageWidth: screenWidth, pageHeight: scrollViewHeight)
        sipCalculatorContentView.addSubview(calculationDetailspage)
        
        scrollViewHeightConstraint.constant = calculationDetailspage.frame.size.height
    }
    
    @IBAction func onCloseButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
