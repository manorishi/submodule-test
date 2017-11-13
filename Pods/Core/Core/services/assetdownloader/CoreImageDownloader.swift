//
//  CoreImageDownloader.swift
//  Core
//
//  Created by kunal singh on 29/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 CoreImageDownloader downloads images from server, save on disk and cache on disk.
 */

import Foundation
import Kingfisher

public class CoreImageDownloader {
    var imageDownloader : ImageDownloader?
    var coreImageCache: ImageCache?
    
    init() {
        imageDownloader = ImageDownloader(name: CoreConstants.CUSTOM_DOWNLOADER_NAME)
        coreImageCache = ImageCache(name: CoreConstants.CUSTOM_CACHE_IMAGE_FOLDER)
        imageDownloader?.downloadTimeout = CoreConstants.CUSTOM_DOWNLOADER_DOWNLOAD_TIMEOUT
        coreImageCache?.maxCachePeriodInSecond = CoreConstants.CUSTOM_CACHE_TIMEOUT
    }
    
    /**
     Download image from the url.
     */
    public func downloadImage(url: String, filename: String, completion:@escaping (_ status:Bool) -> ()){
        if let validURL = URL.init(string: url), let loader = imageDownloader{
            loader.downloadImage(with: validURL, options: [], progressBlock: nil) {
                (image, error, url, data) in
                if let imageData = image, let imageCache = self.coreImageCache{
                    imageCache.store(imageData,  original: nil, forKey: filename, processorIdentifier: "", cacheSerializer: DefaultCacheSerializer.default, toDisk:true , completionHandler: {
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    })
                }else{
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }
    }

    /**
     Get an image for a key from disk.
     */
    public func retrieveImageFromDisk(filename: String) -> Image? {
        if let imageCache = coreImageCache {
            return imageCache.retrieveImageInDiskCache(forKey: filename)
        }
        return nil
    }
    
    /**
     Get an image for a key from memory or disk.
    */
    public func retrieveImage(filename: String, completionHandler: @escaping (Image?) -> Void){
        if let imageCache = coreImageCache {
            imageCache.retrieveImage(forKey: filename, options: nil) {
                image, cacheType in
                completionHandler(image)
            }
        }
    }
    
    /**
     Delete image file from disk.
     */
    public func deleteImage(filename: String) {
        let fileManager = FileManager.default
        if let imageCache = coreImageCache{
            let documentsUrl =  imageCache.diskCachePath
            do{
                let imageName = hashForImage(key: filename) ?? ""
                try fileManager.removeItem(atPath:"\(documentsUrl)/\(imageName)")
            }catch let error as NSError{
                logToConsole(printObject: error.localizedDescription)
            }
        }
    }

    
    public func replaceImageFromGallery(filename: String, image: UIImage){
        if let imageCache = self.coreImageCache{
            imageCache.store(image, forKey: filename)
        }
    }
    
    /**
     Check whether an image is cached for a key.
     
     - parameter key: Key for the image.
     
     - returns: The check result.
     */
    func isCoreImageCached(key: String) -> Bool{
        if let imageCache = coreImageCache {
            return imageCache.isImageCached(forKey: key).cached
        }
        return false
    }
    
    /**
    Get the hash for the key. This could be used for matching files.
    */
    func hashForImage(key: String) -> String?{
        if let imageCache = coreImageCache {
            return imageCache.hash(forKey: key)
        }
        return nil
    }
    
    func deleteOlderImages(downloadedImages: [String], alreadyPresentImages: [String]){
        let fileManager = FileManager.default
        if let imageCache = coreImageCache{
            let documentsUrl =  imageCache.diskCachePath
            for imageUrl in downloadedImages{
                if !alreadyPresentImages.contains(imageUrl){
                    do{
                        try fileManager.removeItem(atPath:"\(documentsUrl)/\(imageUrl)")
                    }catch let error as NSError{
                        logToConsole(printObject: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func listOfDownloadedImages() -> [String] {
        if let imageCache = coreImageCache{
            let documentsUrl =  imageCache.diskCachePath
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(atPath: documentsUrl)
                return directoryContents as [String]
            } catch let error as NSError {
                logToConsole(printObject: error.localizedDescription)
            }
        }
        return []
    }
}
