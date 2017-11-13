//
//  DirectoryViewController.swift
//  smartsell
//
//  Created by Anurag Dake on 22/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Core

class FavouriteChildViewController: UIViewController,IndicatorInfoProvider {
    
    var contentType: ContentDataType!
    private var favouriteChildPresenter : FavouriteChildPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteChildPresenter = FavouriteChildPresenter(favouriteChildViewController: self)
        initialiseUI()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        switch contentType! {
        case .directory:
            return IndicatorInfo(title: "FOLDER")
        case ContentDataType.poster :
            return IndicatorInfo(title: "POSTER")
        case ContentDataType.pdf :
            return IndicatorInfo(title: "PDF")
        case ContentDataType.video :
            return IndicatorInfo(title: "VIDEO")
        }
    }
    
    func initialiseUI(){
        favouriteChildPresenter.addGridView(contentType: contentType)
    }
}
