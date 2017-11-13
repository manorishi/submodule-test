//
//  MFNavDataSyncer.swift
//  mfadvisor
//
//  Created by Akash Tiwari on 03/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core

@objc public protocol MFANavDataSyncerDelegate {
    func mfaNavDataUpdateStatus(status:Bool, isForbidden:Bool, errorTitle:String?, errorMessage:String?)
}

public class MFANavDataSyncer: Operation {
    weak var delegate: MFANavDataSyncerDelegate?
    let mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext!
    private var isSyncError = false
    
    public init(managedObjectContext: NSManagedObjectContext, syncDelegate: MFANavDataSyncerDelegate?) {
        mainManagedObjectContext = managedObjectContext
        delegate = syncDelegate
        _ = MFADataService.sharedInstance
        super.init()
    }
    
    override public func main() {
        if self.isCancelled { return }
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
        updateMFANavDataFromServer()
    }
    
    func getMaxNavDataId() -> Int64 {
        let mFNavDataRepo = MFNavDataRepo(managedContext: self.privateManagedObjectContext)
        return mFNavDataRepo.getMaxNavDataId()
    }
    
    /**
     Api call to fetch data for fund lookup
     */
    private func updateMFANavDataFromServer(){
        let networkClient = NetworkService.sharedInstance.networkClient
        networkClient?.doPOSTRequestWithTokens(requestURL: MFUrlConstants.navDataUrl, params: nil,httpBody:["id":getMaxNavDataId() as AnyObject], completionHandler: { (status, response) -> Void in
            switch status {
            case .success:
                self.saveMFNavData(response: response)
                self.checkForSyncError()
                self.mfaNavDataUpdateStatus(status: true, isForbidden: false, errorTitle: nil, errorMessage: nil)
            case .error:
                self.mfaNavDataUpdateStatus(status: false, isForbidden: false, errorTitle: NetworkUtils.errorTitle(response: response), errorMessage: NetworkUtils.errorMessage(response: response))
            case .forbidden:
                self.mfaNavDataUpdateStatus(status: false, isForbidden: true, errorTitle: nil, errorMessage: nil)
            default:
                self.mfaNavDataUpdateStatus(status: false, isForbidden: false, errorTitle: NetworkUtils.errorTitle(response: response), errorMessage: NetworkUtils.errorMessage(response: response))
            }
        })
    }
    
    private func mfaNavDataUpdateStatus(status:Bool, isForbidden:Bool, errorTitle:String?, errorMessage:String?) {
        DispatchQueue.main.async {
            self.saveDBContext()
            self.delegate?.mfaNavDataUpdateStatus(status:status, isForbidden: isForbidden, errorTitle: errorTitle, errorMessage: errorMessage)
        }
    }
    
    func saveDBContext(){
        mainManagedObjectContext.performAndWait {
            do {
                try self.mainManagedObjectContext.save()
            }catch let error {
                print(error)
            }
        }
    }
    
    /**
     Store data from api response into respective tables in mfadvisor database
     */
    func saveMFNavData(response:[String:AnyObject]?) {
        privateManagedObjectContext.performAndWait {
            self.saveMFANavData(data: response?["data"] as? [Dictionary<String, AnyObject>])
        }
    }
    
    private func checkForSyncError(){
        if isSyncError {
            privateManagedObjectContext.rollback()
        }
    }
    
    func saveMFANavData(data:[Dictionary<String,AnyObject>]?) {
        
        let mFNavDataRepo = MFNavDataRepo(managedContext: self.privateManagedObjectContext)
        
//        if !mFNavDataRepo.deleteContentType() {
//            self.isSyncError = true
//        }
        
        if !mFNavDataRepo.createMFNavData(contentArray: data ?? []) {
            self.isSyncError = true
        }
    }
    
}
