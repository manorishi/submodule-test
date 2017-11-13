//
//  MFADataSyncer.swift
//  mfadvisor
//
//  Created by Apple on 27/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData
import Core

/**
 MFADataSyncerDelegate notifies once data syncing is completed with success/failure
 */

@objc public protocol MFADataSyncerDelegate {
    func mfaDataUpdateStatus(status:Bool, isForbidden:Bool, errorTitle:String?, errorMessage:String?)
}

/**
 MFADataSyncer makes api call to fetch fund lookup data and stores in MFAdvisor database
 */
public class MFADataSyncer: Operation {
    weak var delegate: MFADataSyncerDelegate?
    let mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext!
    private var isSyncError = false
    private var mfAdvisorUrlString = ""
    
    public init(managedObjectContext: NSManagedObjectContext, urlString:String, syncDelegate: MFADataSyncerDelegate?) {
        mainManagedObjectContext = managedObjectContext
        delegate = syncDelegate
        mfAdvisorUrlString = urlString
        _ = MFADataService.sharedInstance
        super.init()
    }
    
    override public func main() {
        if self.isCancelled { return }
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
        updateMFAdvisorDataFromServer()
    }
    
    /**
     Api call to fetch data for fund lookup
     */
    private func updateMFAdvisorDataFromServer(){
        let networkClient = NetworkService.sharedInstance.networkClient
        networkClient?.doGETRequest(requestURL: mfAdvisorUrlString, params: nil,httpBody:nil, completionHandler: { (status, response) -> Void in
            switch status {
            case .success:
                //print("mfa \(response?["lookup_image_heroline_selection"])")
                self.saveMFAdvisorData(response: response)
                self.checkForSyncError()
                self.mfaDataUpdateStatus(status: true, isForbidden: false, errorTitle: nil, errorMessage: nil)
            case .error:
                self.mfaDataUpdateStatus(status: false, isForbidden: false, errorTitle: NetworkUtils.errorTitle(response: response), errorMessage: NetworkUtils.errorMessage(response: response))
            case .forbidden:
                self.mfaDataUpdateStatus(status: false, isForbidden: true, errorTitle: nil, errorMessage: nil)
            default:
                self.mfaDataUpdateStatus(status: false, isForbidden: false, errorTitle: NetworkUtils.errorTitle(response: response), errorMessage: NetworkUtils.errorMessage(response: response))
            }
        })
    }
    
    private func mfaDataUpdateStatus(status:Bool, isForbidden:Bool, errorTitle:String?, errorMessage:String?) {
        DispatchQueue.main.async {
            self.saveDBContext()
            self.delegate?.mfaDataUpdateStatus(status:status, isForbidden: isForbidden, errorTitle: errorTitle, errorMessage: errorMessage)
        }
    }
    
    /**
     Store data from api response into respective tables in mfadvisor database
     */
    func saveMFAdvisorData(response:[String:AnyObject]?) {
        privateManagedObjectContext.performAndWait {
            self.saveCategoryMaster(data: response?["lookup_category_master"] as? [Dictionary<String, AnyObject>])
            self.saveCategoryQuestions(data: response?["lookup_category_questions"] as? [Dictionary<String, AnyObject>])
            self.saveFundData(data: response?["lookup_fund_data"] as? [Dictionary<String, AnyObject>])
            self.saveFundDataLive(data: response?["lookup_fund_data_live"] as? [Dictionary<String, AnyObject>])
            self.saveFundMaster(data: response?["lookup_fund_master"] as? [Dictionary<String, AnyObject>])
            self.saveFundNameLookup(data: response?["lookup_fund_name"] as? [Dictionary<String, AnyObject>])
            self.saveFundQuestions(data: response?["lookup_fund_questions"] as? [Dictionary<String, AnyObject>])
            self.saveImageHerolineSelection(data: response?["lookup_image_heroline_selection"] as? [Dictionary<String, AnyObject>])
            self.saveMutualFundMinInvestment(data: response?["lookup_mutual_fund_min_investment"] as? [Dictionary<String, AnyObject>])
            self.saveMutualFundSelection(data: response?["lookup_mutual_fund_selection"] as? [Dictionary<String, AnyObject>])
            self.saveOtherFundData(data: response?["lookup_other_fund_data"] as? [Dictionary<String, AnyObject>])
            self.saveOtherFundMaster(data: response?["lookup_other_fund_master"] as? [Dictionary<String, AnyObject>])
            self.savePopularFundsConfig(data: response?["lookup_popular_funds_config"] as? [Dictionary<String, AnyObject>])
            self.savePresentationDisplayData(data: response?["lookup_presentation_display_data"] as? [Dictionary<String, AnyObject>])
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
    
    private func checkForSyncError(){
        if isSyncError{
            privateManagedObjectContext.rollback()
        }
    }
    
    func saveCategoryMaster(data:[Dictionary<String,AnyObject>]?) {
        let categoryMasterRepo = MetaCategoryMasterRepo(managedContext: privateManagedObjectContext)
        
        if !categoryMasterRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !categoryMasterRepo.createCategoryMaster(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func savePopularFundsConfig(data:[Dictionary<String,AnyObject>]?) {
        let popularFundsConfigRepo = MetaPopularFundsConfigRepo(managedContext: privateManagedObjectContext)
        
        if !popularFundsConfigRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !popularFundsConfigRepo.createPopularFundsConfig(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func saveCategoryQuestions(data:[Dictionary<String,AnyObject>]?) {
        let categoryQuestionsRepo = MetaCategoryQuestionsRepo(managedContext: privateManagedObjectContext)
        
        if !categoryQuestionsRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !categoryQuestionsRepo.createCategoryQuestionsFromDictionary(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func saveOtherFundData(data:[Dictionary<String,AnyObject>]?) {
        let otherFundDataRepo = MetaOtherFundDataRepo(managedContext: privateManagedObjectContext)
        
        if !otherFundDataRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !otherFundDataRepo.createOtherFundDataFromDictionary(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func saveOtherFundMaster(data:[Dictionary<String,AnyObject>]?) {
        let otherFundMasterRepo = MetaOtherFundMasterRepo(managedContext: privateManagedObjectContext)
        
        if !otherFundMasterRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !otherFundMasterRepo.createOtherFundMaster(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func saveFundMaster(data:[Dictionary<String,AnyObject>]?) {
        let fundMasterRepo = MetaFundMasterRepo(managedContext: privateManagedObjectContext)
        
        if !fundMasterRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !fundMasterRepo.createFundMaster(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func saveFundNameLookup(data:[Dictionary<String,AnyObject>]?) {
        let fundNameLookupRepo = MetaFundNameLookupRepo(managedContext: privateManagedObjectContext)
        
        if !fundNameLookupRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !fundNameLookupRepo.createFundNameLookup(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func saveMutualFundSelection(data:[Dictionary<String,AnyObject>]?) {
        let mutualFundSelectionRepo = MetaMutualFundSelectionRepo(managedContext: privateManagedObjectContext)
        
        if !mutualFundSelectionRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !mutualFundSelectionRepo.createMutualFundSelection(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func savePresentationDisplayData(data:[Dictionary<String,AnyObject>]?) {
        let presentationDisplayDataRepo = MetaPresentationDisplayDataRepo(managedContext: privateManagedObjectContext)
        
        if !presentationDisplayDataRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !presentationDisplayDataRepo.createPresentationDisplayData(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func saveMutualFundMinInvestment(data:[Dictionary<String,AnyObject>]?) {
        let mutualFundMinInvestmentRepo = MetaMutualFundMinInvestmentRepo(managedContext: privateManagedObjectContext)
        
        if !mutualFundMinInvestmentRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !mutualFundMinInvestmentRepo.createMutualFundMinInvestment(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func saveImageHerolineSelection(data:[Dictionary<String,AnyObject>]?) {
        let imageHerolineSelectionRepo = MetaImageHerolineSelectionRepo(managedContext: privateManagedObjectContext)
        
        if !imageHerolineSelectionRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !imageHerolineSelectionRepo.createImageHerolineSelection(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func saveFundData(data:[Dictionary<String,AnyObject>]?) {
        let fundDataRepo = MetaFundDataRepo(managedContext: privateManagedObjectContext)
        
        if !fundDataRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !fundDataRepo.createFundData(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func saveFundQuestions(data:[Dictionary<String,AnyObject>]?) {
        let fundQuestionsRepo = MetaFundQuestionsRepo(managedContext: privateManagedObjectContext)
        
        if !fundQuestionsRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !fundQuestionsRepo.createFundQuestions(contentArray: data ?? []) {
            isSyncError = true
        }
    }
    
    func saveFundDataLive(data:[Dictionary<String,AnyObject>]?) {
        let fundDataLiveRepo = MetaFundDataLiveRepo(managedContext: privateManagedObjectContext)
        
        if !fundDataLiveRepo.deleteContentType() {
            isSyncError = true
        }
        
        if !fundDataLiveRepo.createFundDataLive(contentArray: data ?? []) {
            isSyncError = true
        }
    }
}
