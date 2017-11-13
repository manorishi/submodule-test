//
//  AppDelegateBackgroundFetchExtension.swift
//  smartsell
//
//  Created by kunal singh on 15/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//
import UIKit

extension AppDelegate{
    
    func addbackgroundFetchForMetaDataSyncing(){
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    }
    
    func syncMetaData(completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        homeScreenInteractor = HomeScreenInteractor()
        let userData = homeScreenInteractor?.userData()
        guard let userTypeId = userData?.userTypeId else {
            return
        }
        let metaDataSyncer = MetaDataSyncListener()
        metaDataSyncer.parent = self
        metaDataSyncer.backgroundFetchCompletionHandler = completionHandler
        homeScreenInteractor?.startSyncingMetaData(managedObjectContext: managedObjectContext, mfaManagedObjectContext: mfaManagedObjectContext, dataSyncDelegate: metaDataSyncer, userTypeId: Int16(userTypeId))
    }
    
    func finishBackgroundSync(backgroundFetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        homeScreenInteractor = nil
        backgroundFetchCompletionHandler(UIBackgroundFetchResult.newData)
    }
    
    class MetaDataSyncListener: DataSyncDelegateProtocol{
        weak var parent: AppDelegate! = nil
        var backgroundFetchCompletionHandler:((UIBackgroundFetchResult) -> Void)?
    
        func metaDataDownloadComplete() {
            finishSyncing()
        }
        
        func dataSyncCompleteWithForbidden() {
            finishSyncing()
        }
        
        func dataSyncCompleteWithError(errorTitle: String?, errorMessage: String?) {
            finishSyncing()
        }
        
        func finishSyncing(){
            if let completionhandler = backgroundFetchCompletionHandler{
                 parent.finishBackgroundSync(backgroundFetchCompletionHandler: completionhandler)
            }
        }
        
    }


}
