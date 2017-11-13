//
//  HomeScreenInteractor.swift
//  smartsell
//
//  Created by Anurag Dake on 17/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core
import CoreData
import mfadvisor

/**
 HomeScreenInteractor contains api calls and db operations to get required data on home screen
 */
class HomeScreenInteractor: SmartSellBaseInteractor, MetaDataSyncDelegate, MFADataSyncerDelegate, MFANavDataSyncerDelegate {

    private var dataSyncCount = 0, requiredDataSyncCount = 0
    private var serverContentVersion: (Int, Int) = (0, 0)
    private var dataSyncDelegateProtocol:DataSyncDelegateProtocol?
    
    
    func getNavDataFromServer(mfaManagedObjectContext: NSManagedObjectContext) {
        let navDataSyncOperation = MFANavDataSyncer(managedObjectContext: mfaManagedObjectContext, syncDelegate: self)
        OperationQueue().addOperation(navDataSyncOperation)
    }
    
    func mfaNavDataUpdateStatus(status:Bool, isForbidden:Bool, errorTitle:String?, errorMessage:String?) {
        dataSyncCount = dataSyncCount + 1
        dataSyncDone(status: status, isForbidden: isForbidden, errorTitle: errorTitle, errorMessage: errorMessage)
    }
    
    /**
     Get user data from keychain
     */
    func userData() -> UserData?{
        guard let userData = KeyChainService.sharedInstance.getData(key: ConfigKeys.USER_DATA_KEY),let userDataObj =  NSKeyedUnarchiver.unarchiveObject(with: userData) as? UserData else {
            return nil
        }
        return userDataObj
    }
    
    func checkifSyncingRequired(completion: @escaping((_ isRequired: Bool) -> ())){
        let buildVersion = appBuildVersion() ?? 0
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: AppUrlConstants.iOSAppDetails, params: nil, httpBody: ["app_version": buildVersion as AnyObject], completionHandler: { [weak self] (responseStatus, responseData) in
            DispatchQueue.main.async {
                switch responseStatus{
                case .success:
                    let localContentVersion = self?.localContentVersions() ?? (0, 0)
                    let serverContentVersion = self?.serverContentVersions(jsonResponse: responseData) ?? (0, 0)
                    let isApiCallrequiredForMetaDataSync = self?.isAPICallRequired(localVersion: localContentVersion.0, serverVersion: serverContentVersion.0)
                    let isApiCallrequiredForMfDataSync = self?.isAPICallRequired(localVersion: localContentVersion.1, serverVersion: serverContentVersion.1)
                    if isApiCallrequiredForMetaDataSync! || isApiCallrequiredForMfDataSync!{
                        completion(true)
                    }
                default:
                    return
                }
            }
        })
    }
    
    func startSyncingMetaData(managedObjectContext: NSManagedObjectContext, mfaManagedObjectContext: NSManagedObjectContext, dataSyncDelegate: DataSyncDelegateProtocol, userTypeId: Int16){
        
        requiredDataSyncCount = 1
        dataSyncCount = 0
        getNavDataFromServer(mfaManagedObjectContext: mfaManagedObjectContext)
        let buildVersion = appBuildVersion() ?? 0
        
        self.dataSyncDelegateProtocol = dataSyncDelegate
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: AppUrlConstants.iOSAppDetails, params: nil, httpBody: ["app_version": buildVersion as AnyObject], completionHandler: { [weak self] (responseStatus, responseData) in
            DispatchQueue.main.async {
                switch responseStatus{
                case .success:
                    let localContentVersion = self?.localContentVersions() ?? (0, 0)
                    let serverContentVersion = self?.serverContentVersions(jsonResponse: responseData) ?? (0, 0)
                    self?.serverContentVersion = serverContentVersion
                    let urlStrings = self?.contentUrlStrings(jsonResponse: responseData) ?? (nil, nil)
                    
                    if self?.isAPICallRequired(localVersion: localContentVersion.0, serverVersion: serverContentVersion.0) == true{
                        if let metaDataUrl = urlStrings.0{
                            self?.increaseRequiredDataSyncCount()
                            let metaSyncOperation = MetaDataSyncer(managedObjectContext: managedObjectContext, urlString: metaDataUrl, syncDelegate: self, userTypeId: userTypeId)
                            OperationQueue().addOperation(metaSyncOperation)
                        }
                    }
                    
                    if self?.isAPICallRequired(localVersion: localContentVersion.1, serverVersion: serverContentVersion.1) == true{
                        if let lookupDataUrl = urlStrings.1 {
                            self?.increaseRequiredDataSyncCount()
                            let mfaSyncOperation = MFADataSyncer(managedObjectContext: mfaManagedObjectContext, urlString: lookupDataUrl, syncDelegate: self)
                            OperationQueue().addOperation(mfaSyncOperation)
                        }
                    }
                    
                    if self?.requiredDataSyncCount == 0{
                        self?.dataSyncDelegateProtocol?.metaDataDownloadComplete()
                    }

                case .error:
                    dataSyncDelegate.dataSyncCompleteWithError(errorTitle: nil, errorMessage: responseData?["message"] as? String)
                case .forbidden:
                    dataSyncDelegate.dataSyncCompleteWithForbidden()
                default: break
                }
            }
        })
    }
    
    func getHomeScreenData(userTypeId: Int, managedObjectContext: NSManagedObjectContext) -> [[ListItemTypeProtocol]] {
        let userId = Int16(userTypeId)
        let homePageMapperRepo = CoreDataService.sharedInstance.userHomePageMapperRepo(context: managedObjectContext)
        let homePageBannerRepo = CoreDataService.sharedInstance.userHomeBannerMapperRepo(context: managedObjectContext)
        let homeScreenChallengeItem = HomeScreenChallengeItem()
        let homeScreenBannerItem = HomeScreenBannerItem()
        let homePageData = homePageMapperRepo.allUserHomePageOrderedBySequence(userTypeId: userId)
        var dataArray:[[ListItemTypeProtocol]] = []
        var sequenceDictionary:[Int16:Int16] = [:]
        var homePageFirstItemTypeData:[ListItemTypeProtocol] = []
        var homePageSecondItemTypeData:[ListItemTypeProtocol] = []
        var homePageThirdItemTypeData:[ListItemTypeProtocol] = []
        var homePageFourthItemTypeData:[ListItemTypeProtocol] = []
        
        //get the data of different home screen types
        for homePageItem in homePageData{
            switch homePageItem.item_type {
            case 1:
                homePageFirstItemTypeData = getCarouselData(userTypeId: userId, homePageBannerRepo: homePageBannerRepo)
                sequenceDictionary[1] = homePageItem.sequence
            case 2:
                if let data = homePageBannerRepo.userHomeBanner(userTypeId: userId, itemId: homePageItem.item_id){
                    homePageSecondItemTypeData.append(homeScreenChallengeItem.uiModelByParsingData(response: data) as! ListItemTypeProtocol)
                    sequenceDictionary[2] = homePageItem.sequence
                }
            case 3:
                homePageThirdItemTypeData = getGridData()
                sequenceDictionary[3] = homePageItem.sequence
            case 4:
                if let data = homePageBannerRepo.userHomeBanner(userTypeId: userId, itemId: homePageItem.item_id){
                    homePageFourthItemTypeData.append(homeScreenBannerItem.uiModelByParsingData(response: data) as! ListItemTypeProtocol)
                    sequenceDictionary[4] = homePageItem.sequence
                }
            default:
                return []
            }
        }
        
        //sort the sequence and add the elements to data array
        let sequenceTupleArray = sequenceDictionary.sorted{ $0.value < $1.value }
        for (item_type, _) in sequenceTupleArray {
            switch item_type {
            case 1:
                dataArray.append(homePageFirstItemTypeData)
            case 2:
                dataArray.append(homePageSecondItemTypeData)
            case 3:
                dataArray.append(homePageThirdItemTypeData)
            case 4:
                for bannerData in homePageFourthItemTypeData{
                    dataArray.append([bannerData])
                }
            default:
                 return []
            }
        }
        return dataArray
    }
    
    private func getGridData() -> [ListItemTypeProtocol]{
        var data:[ListItemTypeProtocol] = []
        let homeScreenGridItem = HomeScreenGridItem()
        data.append(homeScreenGridItem.uiModelByParsingData(backImage: "ic_home_fund_selector", title: HomeScreenGrid.Fund_Selector.description) as! ListItemTypeProtocol)
        data.append(homeScreenGridItem.uiModelByParsingData(backImage: "ic_home_fund_comparison", title: HomeScreenGrid.Fund_Comparison.description) as! ListItemTypeProtocol)
        data.append(homeScreenGridItem.uiModelByParsingData(backImage: "ic_home_sales_pitch", title: HomeScreenGrid.Sales_Pitch.description) as! ListItemTypeProtocol)
        data.append(homeScreenGridItem.uiModelByParsingData(backImage: "ic_home_fund_presentation", title: HomeScreenGrid.Fund_Presentation.description) as! ListItemTypeProtocol)
        data.append(homeScreenGridItem.uiModelByParsingData(backImage: "ic_home_detailed_performance", title: HomeScreenGrid.Detailed_performance.rawValue) as! ListItemTypeProtocol)
        data.append(homeScreenGridItem.uiModelByParsingData(backImage: "home_action_sip", title: HomeScreenGrid.SIP_Calculator.description) as! ListItemTypeProtocol)
        data.append(homeScreenGridItem.uiModelByParsingData(backImage: "home_action_swp", title: HomeScreenGrid.SWP_Calculator.description) as! ListItemTypeProtocol)
        data.append(homeScreenGridItem.uiModelByParsingData(backImage: "ic_home_one_page_posters", title: HomeScreenGrid.Sales_Content.description) as! ListItemTypeProtocol)
        data.append(homeScreenGridItem.uiModelByParsingData(backImage: "ic_favorite_shortcut", title: HomeScreenGrid.Your_Favorite.description) as! ListItemTypeProtocol)
        return data
    }
    
    private func getCarouselData(userTypeId: Int16, homePageBannerRepo: UserHomeBannerMapperRepo) -> [ListItemTypeProtocol]{
        var data:[ListItemTypeProtocol] = []
        let homePageBannerData = homePageBannerRepo.userHomeBanners(userTypeId: userTypeId, itemType: 1)
        let homeScreenCarouselItem = HomeScreenCarouselItem()
        for banner in homePageBannerData{
            data.append(homeScreenCarouselItem.uiModelByParsingData(response: banner) as! ListItemTypeProtocol)
        }
        return data
    }
    
    /**
     Called when meta data syncing is complete.
     */
    internal func metaDataSyncDone(isStatus: Bool, isForbidden: Bool, errorTitle: String?, errorMessage: String?) {
        dataSyncCount = dataSyncCount + 1
        if isStatus {
            (UIApplication.shared.delegate as? AppDelegate)?.saveDBContext()
            updateMetaContentVersion(version: serverContentVersion.0)
            
        }
        dataSyncDone(status: isStatus, isForbidden: isForbidden, errorTitle: errorTitle, errorMessage: errorMessage)
    }
    
    /**
     Called when fund lookup data syncing is complete.
     */
    internal func mfaDataUpdateStatus(status: Bool, isForbidden: Bool, errorTitle: String?, errorMessage: String?) {
        dataSyncCount = dataSyncCount + 1
        if status{
            updateLookupContentVersion(version: serverContentVersion.1)
        }
        dataSyncDone(status: status, isForbidden: isForbidden, errorTitle: errorTitle, errorMessage: errorMessage)
    }
    
    private func dataSyncDone(status: Bool, isForbidden: Bool, errorTitle: String?, errorMessage: String?){
        if status {
            if dataSyncCount == requiredDataSyncCount{
                sendNotificationForDataSync()
                dataSyncDelegateProtocol?.metaDataDownloadComplete()
            }
        }else{
            isForbidden ? dataSyncDelegateProtocol?.dataSyncCompleteWithForbidden() : dataSyncDelegateProtocol?.dataSyncCompleteWithError(errorTitle: errorTitle, errorMessage: errorMessage)
        }
    }
    
    private func increaseRequiredDataSyncCount(){
        requiredDataSyncCount = requiredDataSyncCount + 1
    }

    
    private func sendNotificationForDataSync(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ConfigKeys.DATA_SYNC_NOTIFICATION), object: nil)
    }
    
    private func appBuildVersion() -> Int?{
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return Int(version)
        }
        return nil
    }
    
    private func isAPICallRequired(localVersion: Int, serverVersion: Int) -> Bool{
        if serverVersion > localVersion || localVersion == 0{
            return true
        }
        return false
    }
    
    private func localContentVersions() -> (Int, Int){
        return (metaContentVersion(), lookupContentVersion())
    }
    
    private func serverContentVersions(jsonResponse: [String : AnyObject]?) -> (Int, Int){
        let apiMetaContentVersion = jsonResponse?["content_version"]?["meta_content_version"] as? Int ?? 0
        let apiLookupContentVersion = jsonResponse?["content_version"]?["lookup_content_version"] as? Int ?? 0
        return (apiMetaContentVersion, apiLookupContentVersion)
    }
    
    private func contentUrlStrings(jsonResponse: [String : AnyObject]?) -> (String?, String?){
        let metaContentUrl = jsonResponse?["app_data"]?["meta_db_path"] as? String
        let lookupContentUrl = jsonResponse?["app_data"]?["lookup_db_path"] as? String
        return (metaContentUrl, lookupContentUrl)
    }
    
    private func metaContentVersion() -> Int{
        return Int(KeyChainService.sharedInstance.getValue(key: ConfigKeys.META_CONTENT_VERSION_KEY) ?? "0") ?? 0
    }
    
    private func lookupContentVersion() -> Int{
        return Int(KeyChainService.sharedInstance.getValue(key: ConfigKeys.LOOKUP_CONTENT_VERSION_KEY) ?? "0") ?? 0
    }
    
    private func updateMetaContentVersion(version: Int){
        KeyChainService.sharedInstance.setValue(string: String(version), key: ConfigKeys.META_CONTENT_VERSION_KEY)
    }
    
    private func updateLookupContentVersion(version: Int){
        KeyChainService.sharedInstance.setValue(string: String(version), key: ConfigKeys.LOOKUP_CONTENT_VERSION_KEY)
    }
    
    
    //Announcements
    func announcementDataFromServer(completionHandler:@escaping (_ status:ResponseStatus, _ errorTitle:String?, _ errorMessage:String?) -> ()) {
        let userData = KeyChainService.sharedInstance.getData(key: ConfigKeys.USER_DATA_KEY)
        if let userDataObj = NSKeyedUnarchiver.unarchiveObject(with: userData ?? Data()) as? UserData {
            NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: AppUrlConstants.announcementData, params: nil, httpBody: ["user_type_id":userDataObj.userTypeId as AnyObject], completionHandler: {[weak self] (responseStatus, response) in
                DispatchQueue.main.async {
                    switch responseStatus {
                    case .success:
                        self?.saveAnnouncementData(response: response)
                        completionHandler(responseStatus, nil, nil)
                    default:
                        completionHandler(responseStatus, NetworkUtils.errorTitle(response: response),NetworkUtils.errorMessage(response: response))
                    }
                }
            })
        }
    }
    
    func updateLastAnnouncementShownDate() {
        if let data = KeyChainService.sharedInstance.getData(key: AppConstants.ANNOUNCEMENT_DATA_KEY){
            if let announcementDataObj = NSKeyedUnarchiver.unarchiveObject(with: data) as? AnnouncementData {
                announcementDataObj.lastShownDate = Date()
                let annoucement = NSKeyedArchiver.archivedData(withRootObject: announcementDataObj)
                KeyChainService.sharedInstance.setValue(data: annoucement, key: AppConstants.ANNOUNCEMENT_DATA_KEY)
            }
        }
    }
    
    func saveAnnouncementData(response:[String:AnyObject]?) {
        guard let announcementResponse = response
            else {
                return
        }
        let announcementDataObj = AnnouncementData(announcementData: announcementResponse)
        
        if let data = KeyChainService.sharedInstance.getData(key: AppConstants.ANNOUNCEMENT_DATA_KEY){
            if let savedAnnouncementDataObj = NSKeyedUnarchiver.unarchiveObject(with: data ) as? AnnouncementData {
                if savedAnnouncementDataObj.id == announcementDataObj.id {
                    return
                }
            }
        }
        let annoucement = NSKeyedArchiver.archivedData(withRootObject: announcementDataObj)
        KeyChainService.sharedInstance.setValue(data: annoucement, key: AppConstants.ANNOUNCEMENT_DATA_KEY)
    }
}
