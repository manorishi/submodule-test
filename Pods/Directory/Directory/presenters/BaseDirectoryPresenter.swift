//
//  BaseDirectoryPresenter.swift
//  smartsell
//
//  Created by Apple on 27/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

/**
 BaseDirectoryPresenter present Gallery and Grid view controller based on type.
 */

import Foundation
import CoreData
import Core

class BaseDirectoryPresenter:NSObject, BaseDirectoryProtocol {
    
    private let DIRECTORY_VIEW_CONTROLLER = "DirectoryViewController"
    private let GALLERY_VIEW_CONTROLLER = "GalleryViewController"
    
    weak var baseDirectoryViewController: BaseDirectoryViewController!
    var baseDirectoryInteractor: BaseDirectoryInteractor!
    
    init(baseDirectoryViewController: BaseDirectoryViewController) {
        self.baseDirectoryViewController = baseDirectoryViewController
        baseDirectoryInteractor = BaseDirectoryInteractor()
    }
    
    func initializeDirectory(directoryContentData:DierctoryContent?) {
        if directoryContentData?.id == nil {
            if let galleryVC = galleryViewController() {
                self.baseDirectoryViewController.configureChildViewController(childController: galleryVC, onView: self.baseDirectoryViewController.contentView)
            }
        }
        else {
            if let directoryVC = directoryViewController() {
                directoryVC.directoryContentData = directoryContentData
                self.baseDirectoryViewController.configureChildViewController(childController: directoryVC, onView: self.baseDirectoryViewController.contentView)
            }
        }
    }
    
    /**
     Create a DirectoryViewController instance.
     
     @return Return DirectoryViewController instance.
    */
    private func directoryViewController() -> DirectoryViewController? {
        var directory:DirectoryViewController?
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "Directory", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                directory = DirectoryViewController(nibName: DIRECTORY_VIEW_CONTROLLER, bundle: bundle)
                    directory?.managedObjectContext = baseDirectoryViewController.managedObjectContext
            }
        }
        return directory
    }
    
    /**
     Create a GalleryViewController instance.
     
     @return Return GalleryViewController instance.
     */
    private func galleryViewController() -> GalleryViewController? {
        var galleryViewController:GalleryViewController?
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "Directory", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                galleryViewController = GalleryViewController(nibName: GALLERY_VIEW_CONTROLLER, bundle: bundle)
                galleryViewController?.managedObjectContext = baseDirectoryViewController.managedObjectContext
            }
        }
        return galleryViewController
    }
    
    /**
     Dismiss controller
     */
    func dismissViewController() {
        if let childVC = baseDirectoryViewController.childViewControllers.first {
            childVC.willMove(toParentViewController: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParentViewController()
        }
        _ = baseDirectoryViewController.navigationController?.popViewController(animated: true)
    }
    
    func directoryContentDataWithId(_ directoryId:Int32, managedObjectContext:NSManagedObjectContext, isConfidential: Bool = false) -> DierctoryContent? {
        return baseDirectoryInteractor.contentFromTypeId(contentTypeId: Int16(ContentDataType.directory.rawValue) , contentId: directoryId, managedObjectContext: managedObjectContext, isConfidential: isConfidential)
    }
}
