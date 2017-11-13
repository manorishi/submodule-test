//
//  BaseInteractor.swift
//  Directory
//
//  Created by kunal singh on 31/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 BaseInteractor contains method common for Directory and Gallery inetractor like getting directory contents data, new items data, updating favourites data to local and server.
 */

import Foundation
import CoreData
import Core

public class BaseInteractor {

    private let directoryName = "Directory"
    private let posterName = "Poster"
    private let videoName = "Video"
    private let pdfName = "Pdf"
    private let directoryImageName = "ic_folder"
    private let posterImageName = "ic_poster"
    private let videoImageName = "ic_video"
    private let pdfImageName = "ic_pdf"
    
    private let serverContentIdKey = "content_id"
    private let serverContentTypeIdKey = "content_type_id"

    public init() {
        
    }
    
    /*!
     * @discussion Get contents of base directory
     * @param managedObjectContext managedObjectContext
     * @return List of DierctoryContent in home directory
     */
    func homeDirectoryContents(using managedObjectContext: NSManagedObjectContext) -> [DierctoryContent]{
        let homeDirectoryContentMappers: [UserHomeDirectoryContentMapper] = CoreDataService.sharedInstance.userHomeDirectoryContentMapperRepo(context: managedObjectContext).userHomeDirectoryContents()
        let newItemMappers = newItems(using: managedObjectContext)
        let favouritesItemsArray = allFavouriteItems(managedObjectContext: managedObjectContext)
        
        var homeDirectoryContents = [DierctoryContent]()
        for homeDirectoryItem in homeDirectoryContentMappers {
            let contentId = homeDirectoryItem.content_id
            if let content: DierctoryContent = contentFromTypeId(contentTypeId: homeDirectoryItem.content_type_id, contentId: contentId, managedObjectContext: managedObjectContext){
                if let _ = favouritesItemsArray.first(where: {
                    return ($0.content_id == content.id) && ($0.content_type_id == content.contentTypeId)
                }) {
                    content.isFavourite = true
                }
                content.sequence = Int(homeDirectoryItem.sequence)
                content.isNewContent = isNewItem(contentTypeId: content.contentTypeId ?? 0, contentId: contentId, newItemMappers: newItemMappers)
                homeDirectoryContents.append(content)
            }
        }
        homeDirectoryContents.sort { $0.sequence! < $1.sequence! }
        return homeDirectoryContents
    }
    
    /*!
     * @discussion Get contents of a directory
     * @param directoryId Id of directory
     * @return List of DierctoryContent in the directory
     */
    func directoryContents(with directoryId: Int32, using managedObjectContext: NSManagedObjectContext) -> [DierctoryContent]{
        return directoryContentsWithNewItems(userDirectoryContentMapperRepo: CoreDataService.sharedInstance.userDirectoryContentMapperRepo(context: managedObjectContext), directoryId: directoryId, managedObjectContext: managedObjectContext, newItems: newItems(using: managedObjectContext))
    }
    
    /**
     Get only favourites directory content data from local databse and sort data on sequence number..
     */
    func favouriteContents(contentTypeId:Int16, managedObjectContext:NSManagedObjectContext) -> [DierctoryContent] {
        let allFavourites = favouriteWithContentTypeId(contentTypeId, managedObjectContext: managedObjectContext)
        if let allFavouritesId = (allFavourites as NSArray).value(forKeyPath: "@distinctUnionOfObjects.content_id") as? [Int32] {
            var directoryContents = [DierctoryContent]()
            let newItemsMapper = newItems(using: managedObjectContext)
            let directoryContentMapper = CoreDataService.sharedInstance.userDirectoryContentMapperRepo(context: managedObjectContext).favouriteContentWith(contentIds: allFavouritesId)
            for directoryMapper in directoryContentMapper {
                if let content: DierctoryContent = contentFromTypeId(contentTypeId: contentTypeId, contentId: Int32(directoryMapper.content_id), managedObjectContext: managedObjectContext), directoryMapper.content_type_id == contentTypeId {
                    content.isFavourite = true
                    content.sequence = Int(directoryMapper.sequence)
                    content.isNewContent = isNewItem(contentTypeId: contentTypeId, contentId: Int32(directoryMapper.content_id) , newItemMappers: newItemsMapper)
                    directoryContents.append(content)
                }
            }
            directoryContents.sort { $0.sequence! < $1.sequence! }
            return directoryContents
        }
        return []
    }
    
    /**
     Get new items directory content data from local databse and sort data on sequence number.
     */
    func directoryContentsWithNewItems(userDirectoryContentMapperRepo: UserDirectoryContentMapperRepo, directoryId: Int32, managedObjectContext: NSManagedObjectContext, newItems: [NewItemMapper]) -> [DierctoryContent]{
        
        let directoryContentMapper = userDirectoryContentMapperRepo.userDirectoryContentHavingDirectoryId(directoryId: directoryId)
        let favouritesItemsArray = allFavouriteItems(managedObjectContext: managedObjectContext)
        var directoryContents = [DierctoryContent]()
        for directoryItem in directoryContentMapper {
            let contentId = directoryItem.content_id
            if let content: DierctoryContent = contentFromTypeId(contentTypeId: directoryItem.content_type_id, contentId: contentId, managedObjectContext: managedObjectContext){
                if let _ = favouritesItemsArray.first(where: {
                    return ($0.content_id == content.id) && ($0.content_type_id == content.contentTypeId)
                }) {
                    content.isFavourite = true
                }
                content.sequence = Int(directoryItem.sequence)
                content.isNewContent = isNewItem(contentTypeId: content.contentTypeId ?? 0, contentId: contentId , newItemMappers: newItems)
                directoryContents.append(content)
            }
        }
        directoryContents.sort { $0.sequence! < $1.sequence! }
        return directoryContents
    }
    
    func newItems(using managedObjectContext: NSManagedObjectContext) -> [NewItemMapper]{
        return CoreDataService.sharedInstance.newItemMapperRepo(context: managedObjectContext).newItems()
    }
    
    func isNewItem(contentTypeId: Int16, contentId: Int32, newItemMappers: [NewItemMapper]) -> Bool {
        for newItemMapper in newItemMappers {
            if contentTypeId == newItemMapper.content_type_id && contentId == newItemMapper.content_id{
                return true
            }
        }
        return false
    }
    
    /*!
     * @brief Get DierctoryContent from contentTypeId and contentId
     */
    public func contentFromTypeId(contentTypeId: Int16, contentId: Int32,  managedObjectContext: NSManagedObjectContext, isConfidential: Bool = false) -> DierctoryContent? {
        if let contentDataType = ContentDataType.enumFromContentTypeId(contentTypeId: contentTypeId){
            switch contentDataType{
            case ContentDataType.directory:
                if let directory = CoreDataService.sharedInstance.directoryRepo(context: managedObjectContext).directoryHavingId(directoryId: contentId){
                    return createContent(id: directory.id, name: directory.name, contentDescription: directory.directory_description, thumbnailUrl: directory.thumbnail_url, assetURL: nil, shareText: nil, sequence: 0, contentTypeId: contentTypeId, contentTypeName: directoryName, contentTypeImageName: directoryImageName, directoryDisplayType: Int(directory.display_id_type), isNewContent: false, imageFileName: buildFileName(contentId: directory.id, contentTypeId: contentTypeId, assetVersion: directory.image_version), pdfFileName: nil, isConfidential: directory.confidential)
                }
            case ContentDataType.poster:
                if let poster = CoreDataService.sharedInstance.posterRepo(context: managedObjectContext).posterHavingId(posterId: contentId){
                    return createContent(id: poster.id, name: poster.name, contentDescription: poster.poster_description, thumbnailUrl: poster.thumbnail_url, assetURL: nil, shareText: poster.share_text, sequence: 0, contentTypeId: contentTypeId, contentTypeName: posterName, contentTypeImageName: posterImageName, directoryDisplayType: 0, isNewContent: false, imageFileName: buildFileName(contentId: poster.id, contentTypeId: contentTypeId, assetVersion: poster.image_version), pdfFileName: nil)
                }
            case ContentDataType.video:
                if let video = CoreDataService.sharedInstance.videoRepo(context: managedObjectContext).videoHavingId(videoId: contentId){
                    return createContent(id: video.id, name: video.name, contentDescription: video.video_description, thumbnailUrl: video.thumbnail_url, assetURL: video.video_url, shareText: video.share_text, sequence: 0, contentTypeId: contentTypeId, contentTypeName: videoName, contentTypeImageName: videoImageName, directoryDisplayType: 0, isNewContent: false, imageFileName: buildFileName(contentId: video.id, contentTypeId: contentTypeId, assetVersion: video.image_version), pdfFileName: nil)
                }
            case ContentDataType.pdf:
                if let pdf = CoreDataService.sharedInstance.pdfRepo(context: managedObjectContext).pdfHavingId(pdfId: contentId){
                    return createContent(id: pdf.id, name: pdf.name, contentDescription: pdf.pdf_description, thumbnailUrl: pdf.thumbnail_url, assetURL: pdf.pdf_url, shareText: pdf.share_text, sequence: 0, contentTypeId: contentTypeId, contentTypeName: pdfName, contentTypeImageName: pdfImageName, directoryDisplayType: 0, isNewContent: false, imageFileName: buildFileName(contentId: pdf.id, contentTypeId: contentTypeId, assetVersion: pdf.image_version), pdfFileName: buildFileName(contentId: pdf.id, contentTypeId: contentTypeId, assetVersion: pdf.pdf_version))
                }
            }
        }
        return nil
    }
    
    /**
     Return favourite array of type passed as argument.
     */
    func favouriteWithContentTypeId(_ contentTypeId:Int16, managedObjectContext: NSManagedObjectContext) -> [Favourite]{
        let favouriteRepo = CoreDataService.sharedInstance.favouriteRepo(context:managedObjectContext)
        return favouriteRepo.favouriteWithContentTypeId(contentTypeId)
    }
    
    /**
     Return all favourite data(synced and unsynced)
     */
    func allFavouriteItems(managedObjectContext: NSManagedObjectContext) -> [Favourite] {
        return CoreDataService.sharedInstance.favouriteRepo(context: managedObjectContext).allFavourite()
    }
    
    private func createContent(id: Int32, name: String?, contentDescription: String?, thumbnailUrl: String?, assetURL: String?, shareText: String?, sequence: Int?, contentTypeId: Int16, contentTypeName: String?, contentTypeImageName:String?, directoryDisplayType: Int?, isNewContent: Bool, imageFileName: String?, pdfFileName: String?, isConfidential: Bool = false) -> DierctoryContent{
        return DierctoryContent.init(id: id, name: name, contentDescription: contentDescription, thumbnailURL: thumbnailUrl, assetURL:assetURL, shareText: shareText, sequence: sequence, contentTypeId: contentTypeId, contentTypeName: contentTypeName, contentTypeImageName: contentTypeImageName, directoryDisplayType: directoryDisplayType, isNewContent: isNewContent, imageFileName: imageFileName, pdfFileName: pdfFileName,isFavourite: false, isConfidential: isConfidential)
    }
    
    /**
     Update favourite status(favourite/unfavourite) in local db. Sync status is false as this this method is called before server api hit.
     */
    private func updateFavouriteStatusInLocalDB(contentId:Int32,contentTypeId:Int16,isFavourite:Bool,managedObjectContext:NSManagedObjectContext) -> Bool{
        let favouriteRepo = CoreDataService.sharedInstance.favouriteRepo(context: managedObjectContext)
        return favouriteRepo.updateFavouriteSyncStatus(contentId: contentId, contentTypeId: contentTypeId, syncStatus: false, isFavourite: isFavourite)
    }
    
    /**
     Update on server favourite status. If update is success on server then update favorite sync status on local db.
     */
    private func updateFavouriteStatusOnServer(contentId:Int32, contentTypeId:Int16,isFavourite:Bool,context:NSManagedObjectContext) {
        if NetworkChecker().isConnectedToNetwork() {
            let favouriteUrl = isFavourite ? DirectoryURLConstants.addFavouriteUrl : DirectoryURLConstants.removeFavouriteUrl
            NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: favouriteUrl , params: nil, httpBody: [serverContentIdKey:contentId as AnyObject,serverContentTypeIdKey:contentTypeId as AnyObject], completionHandler: { (responseStatus, response) in
                if responseStatus == .success {
                    let favouriteRepo = CoreDataService.sharedInstance.favouriteRepo(context: context)
                    if isFavourite {
                        favouriteRepo.updateFavouriteSyncStatus(contentId: contentId, contentTypeId: contentTypeId, syncStatus: true, isFavourite: isFavourite)
                    }
                    else{
                        favouriteRepo.deleteFavourite(contentId: contentId, contentTypeId: contentTypeId)
                    }
                }
            })
        }
    }
    
    /**
     Update favourite status on local and server.
     */
    func updateFavouriteStatus(contentId:Int32, contentTypeId:Int16, isFavourite:Bool,context:NSManagedObjectContext, completionHandler:(_ status:Bool) -> Void) {
        
        if updateFavouriteStatusInLocalDB(contentId: contentId, contentTypeId: contentTypeId,isFavourite: isFavourite, managedObjectContext: context) {
            completionHandler(true)
        }
        else {
            completionHandler(false)
        }
        updateFavouriteStatusOnServer(contentId: contentId, contentTypeId: contentTypeId,isFavourite: isFavourite, context: context)
    }
    
    /**
     Update unsynced favourites data to server.
     */
    public func updateUnsyncedFavourites(managedObjectContext:NSManagedObjectContext, completionHandler:@escaping (_ status:ResponseStatus) -> ()) {
        let httpBody = favouriteUpdateHttpBody(managedObjectContext: managedObjectContext)
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: DirectoryURLConstants.updateUserFavouriteUrl, params: nil, httpBody: httpBody, completionHandler: {[weak self] (responseStatus, response) in
            DispatchQueue.main.async {
                switch responseStatus {
                case .success:
                    self?.updateFavouriteWithNewData(managedObjectContext: managedObjectContext, response: response)
                    completionHandler(responseStatus)
                case .error, .forbidden:
                    completionHandler(responseStatus)
                default:
                    completionHandler(responseStatus)
                }
            }
        })
    }
    
    /**
     Delete favourite old data and insert new data received in response.
     */
    private func updateFavouriteWithNewData(managedObjectContext:NSManagedObjectContext, response:[String:AnyObject]?){
        let favouriteRepo = CoreDataService.sharedInstance.favouriteRepo(context: managedObjectContext)
        favouriteRepo.deleteAllFavourite()
        if let favouriteData = response?["userFavorites"] as? [Dictionary<String,Any>] {
            favouriteRepo.createFavourites(favouritesArray: favouriteData)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ConfigKeys.DATA_SYNC_NOTIFICATION), object: nil)
        }
    }
    
    /**
     Create favourite http body to update on server.
     */
    private func favouriteUpdateHttpBody(managedObjectContext:NSManagedObjectContext) -> [String : AnyObject] {
        let favouriteRepo = CoreDataService.sharedInstance.favouriteRepo(context: managedObjectContext)
        let favourites = favouriteRepo.favouritesWith(syncStatus: false, isFavourite: true)
        var favouritesIds = [[String:Int]]()
        for favourite in favourites {
            var data = [String:Int]()
            data["content_type_id"] = Int(favourite.content_type_id)
            data["content_id"] = Int(favourite.content_id)
            favouritesIds.append(data)
        }
        let unfavourite = favouriteRepo.favouritesWith(syncStatus: false, isFavourite: false)
        var unFavouritesIds = [[String:Int]]()
        for favourite in unfavourite {
            var data = [String:Int]()
            data["content_type_id"] = Int(favourite.content_type_id)
            data["content_id"] = Int(favourite.content_id)
            unFavouritesIds.append(data)
        }
        let updateDict = ["added_favorites":favouritesIds,"removed_favorites":unFavouritesIds]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: updateDict, options: .prettyPrinted)
            let jsonString = String(bytes: jsonData, encoding: String.Encoding.utf8) ?? ""
            return ["favorites": jsonString as AnyObject]
        }
        catch let error as NSError {
            print("\(error.debugDescription)")
        }
        return [:]
    }
}
