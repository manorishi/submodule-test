//
//  BasePresenter.swift
//  Directory
//
//  Created by kunal singh on 01/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 BasePresenter implement common methods for Gallery and Grid view like directing to   selected module on selection.
 */

import Foundation
import Core
import CoreData
import Poster
import pdf
import Video
import DropDown

public class BasePresenter: NSObject {
    private let BASE_DIRECTORY_VIEW_CONTROLLER = "BaseDirectoryViewController"
    private let POSTER_VIEW_CONTROLLER = "PosterViewController"
    private let PDF_VIEW_CONTROLLER = "PdfViewController"
    private let VIDEO_VIEW_CONTROLLER = "VideoViewController"
    private let DIRECTORY_BUNDLE_NAME = "Directory"
    private let POSTER_IDENTIFIER = "org.cocoapods.Poster"
    private let PDF_IDENTIFIER = "org.cocoapods.pdf"
    private let VIDEO_IDENTIFIER = "org.cocoapods.Video"
    
    private let IMAGE_NOT_DOWNLOADED_ERROR = "Image has not been downloaded, Please sync to download the image"
    private let PDF_NOT_DOWNLOADED_ERROR = "Pdf has not been downloaded, Please sync to download the pdf"
    
    public override init() {
        
    }
    
    /**
     Triggered when clicked on directory items.
     
     @param indexPath Contains indexpath of clicked item in collection view.
     @param data Contains directory data
     */
    public func clickedOnDirectoryItem(data: DierctoryContent, managedObjectContext: NSManagedObjectContext, navigationController: UINavigationController, isParentConfidential: Bool = false) {
        if let contentDataType = ContentDataType.enumFromContentTypeId(contentTypeId: data.contentTypeId){
            switch contentDataType {
            case ContentDataType.directory:
                showDirectory(data: data, managedObjectContext: managedObjectContext, navigationController: navigationController)
            case ContentDataType.poster:
//                if AssetDownloaderService.sharedInstance.coreImageDownloader.retrieveImageFromDisk(filename: data.imageFileName ?? "") != nil{
                    showPoster(data: data, managedObjectContext: managedObjectContext, navigationController: navigationController, isParentConfidential: isParentConfidential)
//                }else{
//                    AlertViewHelper(alertViewCallbackProtocol: nil).showAlertView(title: "", message: IMAGE_NOT_DOWNLOADED_ERROR)
//                }
            case ContentDataType.pdf:
                if AssetDownloaderService.sharedInstance.corePdfDownloader.checkifFileExists(filename: data.pdfFileName ?? ""){
                    showPdf(data: data, managedObjectContext: managedObjectContext, navigationController: navigationController)
                }else{
                    AlertViewHelper(alertViewCallbackProtocol: nil).showAlertView(title: "", message: PDF_NOT_DOWNLOADED_ERROR)
                }
            case ContentDataType.video:
                showVideo(data: data, managedObjectContext: managedObjectContext, navigationController: navigationController)
            }
        }
    }
    
    /**
     Show Video and pass required parameters to ViewController
     
     @param data Contains directory data
     */
    private func showVideo(data: DierctoryContent, managedObjectContext: NSManagedObjectContext, navigationController: UINavigationController){
        let bundle = Bundle(identifier: VIDEO_IDENTIFIER)
        let videoVC = VideoViewController(nibName: VIDEO_VIEW_CONTROLLER, bundle: bundle)
        videoVC.managedObjectContext = managedObjectContext
        videoVC.interPodsCommunicationModel = InterPodsCommunicationModel(id: data.id, name: data.name, contentDescription: data.contentDescription, assetFileName: data.imageFileName, assetUrl: data.assetURL, shareText: data.shareText, thumbnailUrl: data.thumbnailURL)
        navigationController.present(videoVC, animated: true, completion: nil)
    }

    /**
     Show Pdf and pass required parameters to ViewController
     
     @param data Contains directory data
     */
    func showPdf(data: DierctoryContent, managedObjectContext: NSManagedObjectContext, navigationController: UINavigationController){
        let bundle = Bundle(identifier: PDF_IDENTIFIER)
        let pdfVC = PdfViewController(nibName: PDF_VIEW_CONTROLLER, bundle: bundle)
        pdfVC.pdfFileName = data.imageFileName ?? ""
        pdfVC.pdfDescription = data.name
        navigationController.present(pdfVC, animated: true, completion: nil)
    }
    
    /**
     Show Poster and pass required parameters to ViewController
     
     @param data Contains directory data
     */
    private func showPoster(data: DierctoryContent, managedObjectContext: NSManagedObjectContext, navigationController: UINavigationController, isParentConfidential: Bool){
        
        let bundle = Bundle(identifier: POSTER_IDENTIFIER)
        let posterVC = PosterViewController(nibName: POSTER_VIEW_CONTROLLER, bundle: bundle)
        posterVC.managedObjectContext = managedObjectContext
        posterVC.baseModel = InterPodsCommunicationModel(id: data.id, name: data.name, contentDescription: data.contentDescription, assetFileName: data.imageFileName, assetUrl: data.assetURL, shareText: data.shareText, thumbnailUrl: data.thumbnailURL)
        posterVC.isConfidential = isParentConfidential
        navigationController.present(posterVC, animated: true, completion: nil)
    }
    
    /**
     Show BaseDirectoryViewController and pass required parameters to ViewController
     
     @param data Contains directory data
     */
    func showDirectory(data: DierctoryContent, managedObjectContext: NSManagedObjectContext, navigationController: UINavigationController) {
        var baseDirectory:BaseDirectoryViewController?
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: DIRECTORY_BUNDLE_NAME, withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                baseDirectory = BaseDirectoryViewController(nibName: BASE_DIRECTORY_VIEW_CONTROLLER, bundle: bundle)
                baseDirectory?.managedObjectContext = managedObjectContext
                baseDirectory?.directoryContentData = data
                baseDirectory?.hidesBottomBarWhenPushed = true
                navigationController.pushViewController(baseDirectory!, animated: true)
            }
        }
    }

    /**
     Called when clicked on more option button.
     */
    func clickedOnMoreButton(data: DierctoryContent, viewController: UIViewController, completion:@escaping (_ status:Bool) -> ()) {
        let alerController = AlertViewHelper(alertViewCallbackProtocol:nil).loadingAlertViewController(title: "Loading...", message: "\n\n")
        viewController.present(alerController, animated: true, completion: nil)
        AssetDownloaderService.sharedInstance.coreImageDownloader.downloadImage(url: data.thumbnailURL ?? "", filename: data.imageFileName ?? "", completion: {(status) in
            if status == true {
                if let contentDataType = ContentDataType.enumFromContentTypeId(contentTypeId: data.contentTypeId){
                    if contentDataType == ContentDataType.pdf{
                        AssetDownloaderService.sharedInstance.corePdfDownloader.downloadPdf(url: data.assetURL ?? "", filename: data.pdfFileName ?? "", completion: {(status) in
                            DispatchQueue.main.async {
                                alerController.dismiss(animated: true, completion: nil)
                                completion(true)
                            }
                        })
                    }else{
                        DispatchQueue.main.async {
                            alerController.dismiss(animated: true, completion: nil)
                            completion(true)
                        }
                    }
                }
            }
            else{
                alerController.dismiss(animated: true, completion: nil)
                completion(true)
            }
        })
    }
    
    /**
     Initialise overflow menu
     */
    func initialiseDropDown(dropDown: DropDown){
        dropDown.dataSource = ["Details"]
        dropDown.width = 120
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        dropDown.selectionBackgroundColor = dropDown.backgroundColor ?? UIColor.lightGray
    }
    
    /**
     Set anchoe view for dropdown
     */
    func setDropDownAnchor(dropDown: DropDown, anchorView: UIView){
        dropDown.anchorView = anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
    }
    
    /**
     Get Favourite image icon based on paramter 'isFavourite'
     */
    func favouriteImage(isFavorite:Bool, bundle:Bundle?) -> UIImage? {
        if isFavorite {
            return UIImage(named: "dir_favorite_selected", in: bundle, compatibleWith: nil)
        }
        else{
            return UIImage(named: "dir_favorite_unselected", in: bundle, compatibleWith: nil)
        }
    }
    
    func clickedOnFavourite(data:DierctoryContent,indexpath:IndexPath,managedObjectContext:NSManagedObjectContext,completionHandler:(_ status:Bool) -> Void) {
        let baseInteractor = BaseInteractor()
        baseInteractor.updateFavouriteStatus(contentId: data.id, contentTypeId: data.contentTypeId, isFavourite: !data.isFavourite, context: managedObjectContext) { (status) in
            if status{
                data.isFavourite = !data.isFavourite
            }
            completionHandler(status)
        }
        
    }
}
