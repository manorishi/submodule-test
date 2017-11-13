//
//  ImageDataSyncer.swift
//  Core
//
//  Created by kunal singh on 27/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 ImageDataSyncer download images from server.
 */

import Foundation
import CoreData
import Kingfisher

public class ImageDataSyncer: Operation{
    let delegate: ImageDataSyncDelegate
    let mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext!
    private var pdfURLString: [UrlFileNameMapper]
    private var totalItemsToBeDownloaded: Int
    private var downloadedItems: Int
    private var isOperationCancelled: Bool
    
    public init(managedObjectContext: NSManagedObjectContext, syncDelegate: ImageDataSyncDelegate) {
        mainManagedObjectContext = managedObjectContext
        delegate = syncDelegate
        pdfURLString = []
        totalItemsToBeDownloaded = 0
        downloadedItems = 0
        isOperationCancelled = false
        super.init()
    }
    
    public func cancelDownload(){
        self.cancel()
        isOperationCancelled = true
    }
    
    override public func main() {
        if self.isCancelled || isOperationCancelled { return }
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
        retrieveAllThumbnailUrls()
    }
    
    private func retrieveAllThumbnailUrls(){
        var imageUrls:[UrlFileNameMapper] = []
        imageUrls.append(contentsOf: retrievePosterUrls())
        imageUrls.append(contentsOf: retrieveVideoUrls())
        imageUrls.append(contentsOf: retrieveDirectoryUrls())
        imageUrls.append(contentsOf: retrievePdfUrls())
        downloadAssets(imageUrls: imageUrls)
    }
    
    private func downloadAssets(imageUrls: [UrlFileNameMapper]){
        var listOfAlreadyPresentImageUrls:[String] = []
        var listOfNewlyAddedImageUrls:[UrlFileNameMapper] = []
        var listOfAlreadyPresentPdfUrls:[String] = []
        var listOfNewlyAddedPdfUrls:[UrlFileNameMapper] = []
        
        // Get list of already present images and newly added images
        let imageDownloader = AssetDownloaderService.sharedInstance.coreImageDownloader
        let downlaodedImageUrls = imageDownloader.listOfDownloadedImages()
        for urlFileNameMapper in imageUrls{
            if imageDownloader.isCoreImageCached(key: urlFileNameMapper.filename ?? ""){
                listOfAlreadyPresentImageUrls.append(imageDownloader.hashForImage(key: urlFileNameMapper.filename ?? "") ?? "")
            }else{
                listOfNewlyAddedImageUrls.append(urlFileNameMapper)
            }
        }
        
        //get list of already present pdfs and newly added pdfs
        let pdfDownloader = AssetDownloaderService.sharedInstance.corePdfDownloader
        let downloadedPdfUrls = pdfDownloader.listOfDownloadedPdfs()
        for pdfurlMapperItem in pdfURLString{
            if downloadedPdfUrls.contains(pdfurlMapperItem.filename ?? ""){
                listOfAlreadyPresentPdfUrls.append(pdfurlMapperItem.filename ?? "")
            }else{
               listOfNewlyAddedPdfUrls.append(pdfurlMapperItem)
            }
        }
        
        //delete older images
        imageDownloader.deleteOlderImages(downloadedImages: downlaodedImageUrls, alreadyPresentImages: listOfAlreadyPresentImageUrls)
        //delete older pdfs
        pdfDownloader.deleteOlderPdfs(downloadedPdfs: downloadedPdfUrls, alreadyPresentPdfs: listOfAlreadyPresentPdfUrls)
        //notify the download details to the ui thread
        totalItemsToBeDownloaded = listOfNewlyAddedImageUrls.count + listOfNewlyAddedPdfUrls.count
        notifyDownloadDetails(total: totalItemsToBeDownloaded, downloaded: downloadedItems)
        if self.isCancelled || isOperationCancelled { return }
        
        //start downloading the images
        startDownloadingImagesAlongWithPdfs(imageUrls: listOfNewlyAddedImageUrls, pdfUrls: listOfNewlyAddedPdfUrls)
    }
    
    private func startDownloadingImagesAlongWithPdfs(imageUrls: [UrlFileNameMapper], pdfUrls: [UrlFileNameMapper]){
        downloadImages(imageUrls: imageUrls)
        if self.isCancelled || isOperationCancelled { return }
        downloadPdfs(pdfUrls: pdfUrls)
    }
    
    private func downloadPdfs(pdfUrls: [UrlFileNameMapper]){
        if self.isCancelled || isOperationCancelled { return }
        let pdfDownloader = AssetDownloaderService.sharedInstance.corePdfDownloader
        var mutableArray = pdfUrls
        if let lastFileNameMapper = mutableArray.popLast(){
            pdfDownloader.downloadPdf(url: lastFileNameMapper.url ?? "", filename: lastFileNameMapper.filename ?? ""){
                (_ status:Bool) -> () in
                self.notifyDownloadDetails(total: self.totalItemsToBeDownloaded, downloaded: self.downloadedItems + 1)
                self.downloadPdfs(pdfUrls: mutableArray)
            }
        }
    }
    
    private func downloadImages(imageUrls: [UrlFileNameMapper]){
        if self.isCancelled || isOperationCancelled { return }
        let imageDownloader = AssetDownloaderService.sharedInstance.coreImageDownloader
        var mutableArray = imageUrls
        if let lastFileNameMapper = mutableArray.popLast(){
            imageDownloader.downloadImage(url: lastFileNameMapper.url ?? "", filename: lastFileNameMapper.filename ?? "", completion:{
                (status) -> Void in
                self.notifyDownloadDetails(total: self.totalItemsToBeDownloaded, downloaded: self.downloadedItems + 1)
                self.downloadImages(imageUrls: mutableArray)
            })
        }
    }
    
    private func notifyDownloadDetails(total: Int, downloaded: Int){
        self.downloadedItems = downloaded
        DispatchQueue.main.async {
            self.delegate.imageDataSyncingProgress(total: total, downloaded: self.downloadedItems)
        }
    }
    
    private func retrievePosterUrls() -> [UrlFileNameMapper]{
        var posterUrls: [UrlFileNameMapper] = []
        let postersArray = PosterRepo(managedContext: privateManagedObjectContext).allPosters()
        for poster in postersArray{
            let urlFileNameMapper = UrlFileNameMapper.init(filename: buildFileName(contentId: poster.id, contentType: ContentDataType.poster, assetVersion: poster.image_version), url: poster.thumbnail_url)
            posterUrls.append(urlFileNameMapper)
        }
        return posterUrls
    }
    
    private func retrieveVideoUrls() -> [UrlFileNameMapper]{
        var videoUrls: [UrlFileNameMapper] = []
        let videosArray = VideoRepo(managedContext: privateManagedObjectContext).allVideos()
        for video in videosArray{
            let urlFileNameMapper = UrlFileNameMapper.init(filename: buildFileName(contentId: video.id, contentType: ContentDataType.video, assetVersion: video.image_version), url: video.thumbnail_url)
            videoUrls.append(urlFileNameMapper)
        }
        return videoUrls
    }
    
    private func retrieveDirectoryUrls() -> [UrlFileNameMapper]{
        var directoryUrls: [UrlFileNameMapper] = []
        let directoryArray = DirectoryRepo(managedContext: privateManagedObjectContext).allDirectories()
        for directory in directoryArray{
            let urlFileNameMapper = UrlFileNameMapper.init(filename: buildFileName(contentId: directory.id, contentType: ContentDataType.directory, assetVersion: directory.image_version), url: directory.thumbnail_url)
            directoryUrls.append(urlFileNameMapper)
        }
        return directoryUrls
    }
    
    private func retrievePdfUrls() -> [UrlFileNameMapper]{
        pdfURLString.removeAll()
        var pdfUrls: [UrlFileNameMapper] = []
        let pdfArray = PdfRepo(managedContext: privateManagedObjectContext).allPdfs()
        for pdf in pdfArray{
            pdfUrls.append(UrlFileNameMapper.init(filename: buildFileName(contentId: pdf.id, contentType: ContentDataType.pdf, assetVersion: pdf.image_version), url: pdf.thumbnail_url))
            pdfURLString.append(UrlFileNameMapper.init(filename: buildFileName(contentId: pdf.id, contentType: ContentDataType.pdf, assetVersion: pdf.pdf_version), url: pdf.pdf_url))
        }
        return pdfUrls
    }

}
