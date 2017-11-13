//
//  DirectoryPresenter.swift
//  Directory
//
//  Created by kunal singh on 23/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 DirectoryPresenter contains UI logic like updating favourite icon, showing and hiding empty data message and configure drop down menu.
 */

import Foundation
import CoreData
import Core
import Poster
import DropDown

class DirectoryPresenter:BasePresenter, DirectoryScreenProtocol {
    
    weak var directoryViewController: DirectoryViewController!
    var directoryInteractor: DirectoryInteractor!
    
    init(directoryViewController: DirectoryViewController) {
        self.directoryViewController = directoryViewController
        directoryInteractor = DirectoryInteractor()
    }
    
    ///Fetch Home Directory Contents
    func homeDirectoryContents(using managedObjectContext: NSManagedObjectContext) -> [DierctoryContent] {
        return directoryInteractor.homeDirectoryContents(using: managedObjectContext)
    }
    
    ///Fetch Directory Contents
    func directoryContents(with directoryId: Int32, using managedObjectContext: NSManagedObjectContext) -> [DierctoryContent] {
        return directoryInteractor.directoryContents(with: directoryId, using: managedObjectContext)
    }
    
    func favouriteContents(contentTypeId:Int16 , managedObjectContext: NSManagedObjectContext) -> [DierctoryContent]{
        return directoryInteractor.favouriteContents(contentTypeId: contentTypeId, managedObjectContext: managedObjectContext)
    }
    
    func isHiddenEmptyDataMessageView(dataCount:Int, favouriteContentTypeId:Int16?) -> Bool{
        if dataCount == 0 && favouriteContentTypeId != nil {
            return false
        }
        else{
            return true
        }
    }
    
    /**
     Triggered when clicked on directory items.
     
     @param indexPath Contains indexpath of clicked item in collection view.
     @param data Contains directory data
    */
    func clickedOnDirectoryItem(data: DierctoryContent, isParentConfidential: Bool = false) {
//        super.clickedOnDirectoryItem(data: data, managedObjectContext: self.directoryViewController.managedObjectContext!, navigationController: self.directoryViewController.navigationController!)
        
        if let contentDataType = ContentDataType.enumFromContentTypeId(contentTypeId: data.contentTypeId){
            switch contentDataType {
            case ContentDataType.pdf:
                if AssetDownloaderService.sharedInstance.corePdfDownloader.checkifFileExists(filename: data.pdfFileName ?? ""){
                    super.showPdf(data: data, managedObjectContext: self.directoryViewController.managedObjectContext!, navigationController: self.directoryViewController.navigationController!)
                }else{
                    onRefreshMenuSelect(data: data)
                }
            default:
                super.clickedOnDirectoryItem(data: data, managedObjectContext: self.directoryViewController.managedObjectContext!, navigationController: self.directoryViewController.navigationController!, isParentConfidential: isParentConfidential)
            }
        }
    }
    
    func clickedOnMoreButton(data:DierctoryContent , completion:@escaping (_ status:Bool) -> ()){
        super.clickedOnMoreButton(data: data, viewController: self.directoryViewController, completion: completion)
    }
    
    private func interPodCommunicationModel(from directoryContent: DierctoryContent)-> InterPodsCommunicationModel?{
        let interPodCommunicationModel = InterPodsCommunicationModel.init(id: directoryContent.id, name: directoryContent.name, contentDescription: directoryContent.contentDescription, assetFileName: directoryContent.imageFileName, assetUrl: directoryContent.thumbnailURL, shareText: directoryContent.shareText, thumbnailUrl: directoryContent.thumbnailURL)
        return interPodCommunicationModel
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
//        clickedOnMoreButton(data: data, completion: {
//            (status) -> Void in
//            self.directoryViewController.directoryCollectionView.reloadData()
//        })
        guard NetworkChecker().isConnectedToNetwork() else {
            showAlert(title: "Network Error!", message: "Please check your internet connection.")
            return
        }
        clickedOnMoreButton(data: data, completion: {[weak self] (status) -> Void in
            if status{
                self?.directoryViewController.directoryCollectionView.reloadData()
                if let contentDataType = ContentDataType.enumFromContentTypeId(contentTypeId: data.contentTypeId){
                    switch contentDataType {
                    case ContentDataType.pdf:
                        self?.showPdf(data: data, managedObjectContext: (self?.directoryViewController.managedObjectContext)!, navigationController: (self?.directoryViewController.navigationController)!)
                    default: break
                    }
                }
            }else{
                self?.showAlert(title: "", message: "An error occured")
            }
        })
    }
    
    func showAlert(title: String, message: String){
        AlertViewHelper(alertViewCallbackProtocol: nil).showAlertView(title: title, message: message)
    }
    
    /**
     On Details dropdown item selected
     */
    func onDetailsMenuSelect(data: DierctoryContent){
        AlertViewHelper(alertViewCallbackProtocol: nil).showAlertView(title: data.name ?? "", message: data.contentDescription ?? "")
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
