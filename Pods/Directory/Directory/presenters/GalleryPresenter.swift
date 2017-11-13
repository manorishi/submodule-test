//
//  GalleryPresenter.swift
//  Directory
//
//  Created by Apple on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 GalleryPresenter contain UI logic like updating favourite icon and configure drop down menu.
 */

import UIKit
import CoreData
import DropDown
import Core

class GalleryPresenter: BasePresenter, GalleryScreenProtocol {
    weak var galleryViewController: GalleryViewController!
    var galleryInteractor: GalleryInteractor!
    
    init(galleryViewController: GalleryViewController) {
        self.galleryViewController = galleryViewController
        galleryInteractor = GalleryInteractor()
    }
    
    func dataForGallery(managedObjectContext: NSManagedObjectContext) -> [[GalleryHeader: [DierctoryContent]]]{
        return galleryInteractor.galleryData(managedObjectContext: managedObjectContext)
    }
    
    func galleryDataContainingNewItems(managedObjectContext: NSManagedObjectContext) -> [[GalleryHeader: [DierctoryContent]]]{
        return galleryInteractor.galleryDataContainingNewItems(managedObjectContext: managedObjectContext)
    }
    
    func clickedOnGalleryItem(data: DierctoryContent){
        if let contentDataType = ContentDataType.enumFromContentTypeId(contentTypeId: data.contentTypeId){
            switch contentDataType {
            case ContentDataType.pdf:
                if AssetDownloaderService.sharedInstance.corePdfDownloader.checkifFileExists(filename: data.pdfFileName ?? ""){
                    super.showPdf(data: data, managedObjectContext: self.galleryViewController.managedObjectContext!, navigationController: self.galleryViewController.navigationController!)
                }else{
                    onRefreshMenuSelect(data: data)
                }
                
            case ContentDataType.directory:
                super.clickedOnDirectoryItem(data: data, managedObjectContext: self.galleryViewController.managedObjectContext!, navigationController: self.galleryViewController.navigationController!, isParentConfidential: data.isConfidential)
                
            default:
                super.clickedOnDirectoryItem(data: data, managedObjectContext: self.galleryViewController.managedObjectContext!, navigationController: self.galleryViewController.navigationController!)
            }
        }
    }
    
    func clickedOnMoreButton(data:DierctoryContent , completion:@escaping (_ status:Bool) -> ()){
        super.clickedOnMoreButton(data: data, viewController: self.galleryViewController, completion: completion)
    }
    
    /**
     Defines dropdown actions
     */
    func setDropDownSelectionActions(dropDown: DropDown, data: DierctoryContent){
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            switch index {
//            case 0: self.onRefreshMenuSelect(data: data)
            case 0: self.onDetailsMenuSelect(data: data)
            default: break
            }
        }
        dropDown.cancelAction = { [] in
            dropDown.hide()
        }
    }
    
    /**
     On Refresh dropdown item selected
     */
    func onRefreshMenuSelect(data: DierctoryContent){
        guard NetworkChecker().isConnectedToNetwork() else {
            showAlert(title: "Network Error!", message: "Please check your internet connection.")
            return
        }
        clickedOnMoreButton(data: data, completion: {[weak self] (status) -> Void in
            if status{
                self?.galleryViewController.reloadRowsWhenAssetDownloaded()
                if let contentDataType = ContentDataType.enumFromContentTypeId(contentTypeId: data.contentTypeId){
                    switch contentDataType {
                    case ContentDataType.pdf:
                        self?.showPdf(data: data, managedObjectContext: (self?.galleryViewController.managedObjectContext)!, navigationController: (self?.galleryViewController.navigationController)!)
                    default: break
                    }
                }
            }else{
                self?.showAlert(title: "", message: "An error occured")
            }
        })
    }
    
    /**
     On Details dropdown item selected
     */
    func onDetailsMenuSelect(data: DierctoryContent){
        showAlert(title: data.name ?? "", message: data.contentDescription ?? "")
    }
    
    func showAlert(title: String, message: String){
        AlertViewHelper(alertViewCallbackProtocol: nil).showAlertView(title: title, message: message)
    }
    
    /**
     Get Favourite image icon based on paramter 'isFavourite'
     */
    override func favouriteImage(isFavorite:Bool, bundle:Bundle?) -> UIImage? {
        return super.favouriteImage(isFavorite: isFavorite, bundle: bundle)
    }
    
    func clickedOnFavourite(data:DierctoryContent,indexpath:IndexPath,managedObjectContext:NSManagedObjectContext,completionHandler:@escaping (_ status:Bool) -> Void){
        
        super.clickedOnFavourite(data: data, indexpath: indexpath, managedObjectContext: managedObjectContext) {(status) in
            if status {
                completionHandler(true)
            }
            else{
                completionHandler(false)
            }
        }
    }
    
}
