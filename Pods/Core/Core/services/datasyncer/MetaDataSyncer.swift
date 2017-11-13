//
//  MetaDataSyncer.swift
//  Core
//
//  Created by kunal singh on 22/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 MetaDataSyncer get data from server and update all tables. While updating tables  if any error occur then rollback all tables update.
 */

import Foundation
import CoreData

public class MetaDataSyncer: Operation{
    var delegate: MetaDataSyncDelegate?
    let mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext!
    private var userTypeId:Int16 = 0
    private var isSyncError = false
    private var metaSyncUrl = ""
    
    public init(managedObjectContext: NSManagedObjectContext, urlString: String, syncDelegate: MetaDataSyncDelegate?, userTypeId: Int16) {
        mainManagedObjectContext = managedObjectContext
        delegate = syncDelegate
        metaSyncUrl = urlString
        self.userTypeId = userTypeId
        super.init()
    }
    
    override public func main() {
        if self.isCancelled { return }
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
        callSyncApi()
    }
    
    /**
     Get data from server
     */
    private func callSyncApi(){
        let networkClient = NetworkService.sharedInstance.networkClient
        networkClient?.doGETRequest(requestURL: metaSyncUrl, params: nil,httpBody:nil, completionHandler: { (status, response) -> Void in
            switch status {
            case .success:
                self.storeElementsData(response: response)
                // rollback if sync error occured
                self.checkForSyncError()
                // update the main thread
                self.updateUIThread(isStatus: true, isForbidden: false, errorTitle: nil, errorMessage: nil)
            case .error:
                self.updateUIThread(isStatus: false, isForbidden: false, errorTitle: NetworkUtils.errorTitle(response: response), errorMessage: NetworkUtils.errorMessage(response: response))
            case .forbidden:
                self.updateUIThread(isStatus: false, isForbidden: true, errorTitle: nil, errorMessage: nil)
            default:
                self.updateUIThread(isStatus: false, isForbidden: false, errorTitle: NetworkUtils.errorTitle(response: response), errorMessage: NetworkUtils.errorMessage(response: response))
            }
        })
    }
    
    /**
     Update all tables data.
     */
    func storeElementsData(response:[String:AnyObject]?) {
        privateManagedObjectContext.performAndWait {
            self.handlePostersData(data: response?["posters"] as? [Dictionary<String, AnyObject>])
            self.handleVideosData(data: response?["videos"] as? [Dictionary<String,AnyObject>])
            self.handlePdfData(data: response?["pdfs"] as? [Dictionary<String,AnyObject>])
            self.handleDirectoryData(data: response?["directories"] as? [Dictionary<String,AnyObject>])
            self.storeContentType(data: response?["contentTypes"] as? [Dictionary<String,AnyObject>])
            self.storeNewItemMapperData(data: response?["new_items_content"] as? [Dictionary<String,AnyObject>])
            self.storeDirectoryDisplayTypeData(data: response?["directory_display_types"] as? [Dictionary<String,AnyObject>])
            self.storePosterTextElementsRepoData(data: response?["poster_text_elements"] as? [Dictionary<String,AnyObject>])
            self.storePosterImageElementsRepoData(data: response?["poster_image_elements"] as? [Dictionary<String,AnyObject>])
            self.storeUserDirectoryContentMapperData(data: response?["user_directory_content"] as? [Dictionary<String,AnyObject>])
            self.storeUserHomeDirectoryContentMapperData(data: response?["user_home_directory_content"] as? [Dictionary<String,AnyObject>])
            self.storeMmAchievementsData(data: response?["meta_achievements_content"] as? [Dictionary<String,AnyObject>])
            self.storeFsAchievementsData(data: response?["meta_fs_achievements_content"] as? [Dictionary<String,AnyObject>])
            self.storeMappingUserHomePage(data: response?["mapping_user_home_page"] as? [Dictionary<String,AnyObject>])
            self.storeMappingUserHomeBanner(data: response?["mapping_user_home_banner"] as? [Dictionary<String,AnyObject>])
        }
    }
    
    /**
     Check for error if any error occured then rollback all tables update.
     */
    private func checkForSyncError(){
        if isSyncError{
            privateManagedObjectContext.rollback()
        }
    }
    
    private func handlePostersData(data: [Dictionary<String, AnyObject>]?){
        let posterRepo = PosterRepo(managedContext: privateManagedObjectContext)
        
        if !posterRepo.deletePosters() {
            isSyncError = true
        }
        
        if !posterRepo.createPosters(posterArray: data ?? []){
            isSyncError = true
        }
    }
    
    private func storeContentType(data: [Dictionary<String,AnyObject>]?){
        let contentTypeRepo = ContentTypeRepo(managedContext: privateManagedObjectContext)
        
        if !contentTypeRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !contentTypeRepo.createContentType(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    private func handleVideosData(data: [Dictionary<String,AnyObject>]?){
        let videoRepo = VideoRepo(managedContext: privateManagedObjectContext)
        
        if !videoRepo.deleteVideos() {
            isSyncError = true
        }
        
        if !videoRepo.createVideos(videosArray: data ?? []){
            isSyncError = true
        }
    }
    
    private func handlePdfData(data: [Dictionary<String,AnyObject>]?){
        let pdfRepo = PdfRepo(managedContext: privateManagedObjectContext)
        
        if !pdfRepo.deletePdfs() {
            isSyncError = true
        }
        
        if !pdfRepo.createPdfs(pdfsArray: data ?? []) {
            isSyncError = true
        }
    }
    
    private func handleDirectoryData(data: [Dictionary<String,AnyObject>]?){
        let directoryRepo = DirectoryRepo(managedContext: privateManagedObjectContext)
        
        if !directoryRepo.deleteDirectories() {
            isSyncError = true
        }
        
        if !directoryRepo.createDirectories(directoryArray: data ?? []) {
            isSyncError = true
        }
    }
    
    private func storeNewItemMapperData(data: [Dictionary<String,AnyObject>]?){
        let newItemMapper = NewItemMapperRepo(managedContext: privateManagedObjectContext)
        if !newItemMapper.deleteNewItem() {
            isSyncError = true
        }
        
        if !newItemMapper.createNewItem(newItemArray: data ?? []) {
            isSyncError = true
        }
    }
    
    private func storeDirectoryDisplayTypeData(data: [Dictionary<String,AnyObject>]?){
        let directoryDisplayType = DirectoryDisplayTypeRepo(managedContext: privateManagedObjectContext)
        if !directoryDisplayType.deletedirectoryDisplayType() {
            isSyncError = true
        }
        
        if !directoryDisplayType.createDirectoryDisplayType(directoryDisplayTypeArray: data ?? []) {
            isSyncError = true
        }
    }
    
    private func storePosterTextElementsRepoData(data: [Dictionary<String,AnyObject>]?){
        let posterTextElements = PosterTextElementsRepo(managedContext: privateManagedObjectContext)
        if !posterTextElements.deletePosterTextElements() {
            isSyncError = true
        }
        
        if !posterTextElements.createPosterTextElements(posterTextElementArray: data ?? []) {
            isSyncError = true
        }
    }
    
    private func storePosterImageElementsRepoData(data: [Dictionary<String,AnyObject>]?){
        let posterImageElements = PosterImageElementsRepo(managedContext: privateManagedObjectContext)
        if !posterImageElements.deletePosterImageElements() {
            isSyncError = true
        }
        
        if !posterImageElements.createPosterImageElements(posterTextElementArray: data ?? []) {
            isSyncError = true
        }
    }
    
    private func storeUserDirectoryContentMapperData(data: [Dictionary<String,AnyObject>]?){
        let userDirectoryContentMapper = UserDirectoryContentMapperRepo(managedContext: privateManagedObjectContext)
        if !userDirectoryContentMapper.deleteUserDirectoryContents() {
            isSyncError = true
        }
        
        if !userDirectoryContentMapper.createUserDirectoryContent(userDirectoryContentArray: data ?? [], userTypeId: userTypeId) {
            isSyncError = true
        }
    }
    
    private func storeUserHomeDirectoryContentMapperData(data: [Dictionary<String,AnyObject>]?){
        let userHomeDirectoryContentMapper = UserHomeDirectoryContentMapperRepo(managedContext: privateManagedObjectContext)
        if !userHomeDirectoryContentMapper.deleteUserHomeDirectoryContents() {
            isSyncError = true
        }
        
        if !userHomeDirectoryContentMapper.createUserHomeDirectoryContent(userHomeDirectoryContentArray: data ?? [], userTypeId: userTypeId) {
            isSyncError = true
        }
    }
    
    private func storeMmAchievementsData(data: [Dictionary<String,AnyObject>]?){
        let mmAchievement = AchievementRepo(managedContext: privateManagedObjectContext)
        if !mmAchievement.deleteAchievements() {
            isSyncError = true
        }
        
        if mmAchievement.createAchievements(achievementArray: data ?? [], type: .marketingMaterial) {
            isSyncError = true
        }
    }
    
    private func storeFsAchievementsData(data: [Dictionary<String,AnyObject>]?){
        let fsAchievement = AchievementRepo(managedContext: privateManagedObjectContext)
        if fsAchievement.createAchievements(achievementArray: data ?? [], type: .fundSelector) {
            isSyncError = true
        }
    }
    
    private func storeMappingUserHomePage(data: [Dictionary<String,AnyObject>]?){
        let userHomePageMapperRepo = UserHomePageMapperRepo(managedContext: privateManagedObjectContext)
        if !userHomePageMapperRepo.deleteUserHomePage() {
            isSyncError = true
        }
        if userHomePageMapperRepo.createUserHomePage(inputArray: data ?? [], userTypeId: userTypeId){
            isSyncError = true
        }
    }
    
    private func storeMappingUserHomeBanner(data: [Dictionary<String,AnyObject>]?){
        let userHomeBannerRepo = UserHomeBannerMapperRepo(managedContext: privateManagedObjectContext)
        if !userHomeBannerRepo.deleteUserHomeBanner() {
            isSyncError = true
        }
        if userHomeBannerRepo.createUserHomeBanner(inputArray: data ?? [], userTypeId: userTypeId) {
            isSyncError = true
        }
    }
    
    private func updateUIThread(isStatus:Bool, isForbidden:Bool, errorTitle:String?, errorMessage:String?){
        DispatchQueue.main.async{
            self.delegate?.metaDataSyncDone(isStatus:isStatus, isForbidden: isForbidden, errorTitle: errorTitle, errorMessage: errorMessage)
        }
    }
    
}
