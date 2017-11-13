//
//  FavouritesViewController.swift
//  smartsell
//
//  Created by Apple on 22/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Core

/**
 FavouritesViewController displays all user favourites in groups as posters, pdf etc in TabView
 */
class FavouritesViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        setupPagerTab()
        super.viewDidLoad()
    }
    
    func setupPagerTab() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = UIColor(red: 0.74, green: 0.24, blue: 0.45, alpha: 1.0)
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 0.74, green: 0.24, blue: 0.45, alpha: 1.0)
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 12)
        settings.style.selectedBarHeight = 1.5
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = hexStringToUIColor(hex: "#d2d2d2")
            newCell?.label.textColor = UIColor.white
        }
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let directoryObj = FavouriteChildViewController()
        directoryObj.contentType = .directory
        let posterObj = FavouriteChildViewController()
        posterObj.contentType = .poster
        let videoObj = FavouriteChildViewController()
        videoObj.contentType = .video
        let pdfObj = FavouriteChildViewController()
        pdfObj.contentType = .pdf
        
        return [posterObj, videoObj, pdfObj, directoryObj]
    }
    
    @IBAction func onBackButtonPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onHomeTap(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
