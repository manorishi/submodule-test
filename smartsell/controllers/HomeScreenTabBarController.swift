//
//  HomeScreenTabBarController.swift
//  smartsell
//
//  Created by kunal singh on 10/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

class HomeScreenTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeAppearance()
    }
    
    private func customizeAppearance(){
        self.tabBar.barTintColor = UIColor.black
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
        setActiveTabBackgroundColor()
    }
    
    private func setActiveTabBackgroundColor(){
        let numberOfItems = CGFloat((self.tabBar.items!.count))
        let tabBarItemSize = CGSize(width: self.tabBar.frame.width / numberOfItems, height: self.tabBar.frame.height)
        self.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: hexStringToUIColor(hex: Colors.COLOR_PRIMARY), size: tabBarItemSize).resizableImage(withCapInsets: .zero)
        self.tabBar.frame.size.width = self.view.frame.width + 4
        self.tabBar.frame.origin.x = -2
    }
    
    override var selectedViewController: UIViewController?{
        didSet {
            guard let viewControllers = viewControllers else {
                return
            }
            for viewController in viewControllers {
                let fontAttributes: [String: AnyObject] = [NSFontAttributeName:UIFont.systemFont(ofSize: 17.0), NSForegroundColorAttributeName: UIColor.white]
                viewController.tabBarItem.setTitleTextAttributes(fontAttributes, for: .normal)
            }
        }
    }
}
