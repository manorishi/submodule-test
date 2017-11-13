//
//  FavouriteChildPresenter.swift
//  smartsell
//
//  Created by Apple on 14/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Directory
import Core

/**
 Add Directory controller as child controller for favourite screen.
 */

class FavouriteChildPresenter {

    private let DIRECTORY_IDENTIFIER = "org.cocoapods.Directory"
    private let DIRECTORY_VIEW_CONTROLLER = "DirectoryViewController"
    
    weak var favouriteChildVC: FavouriteChildViewController!
    var favouriteChildInteractor: FavouriteChildInterator!
    
    init(favouriteChildViewController: FavouriteChildViewController) {
        self.favouriteChildVC = favouriteChildViewController
        favouriteChildInteractor = FavouriteChildInterator()
    }
    
    /**
     Add Directory grid view as child ViewController in FavouriteChildViewController
     */
    func addGridView(contentType:ContentDataType) {
        var directoryVC:DirectoryViewController?
        let podBundle = Bundle(identifier: DIRECTORY_IDENTIFIER)
        directoryVC = DirectoryViewController(nibName: DIRECTORY_VIEW_CONTROLLER, bundle: podBundle)
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            directoryVC?.managedObjectContext = managedObjectContext
            directoryVC?.favouriteContentTypeId = Int16(contentType.rawValue)
        }
        favouriteChildVC.configureChildViewController(childController: directoryVC!, onView: favouriteChildVC.view)
    }
    
}
