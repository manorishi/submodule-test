//
//  MFADataService.swift
//  mfadvisor
//
//  Created by kunal singh on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData
import Core

/**
 MFADataService provides single entry points for other classes to access database repos in MFAdvisor
 */
public class MFADataService {
    public let persistentStoreCoordinator : NSPersistentStoreCoordinator?
    private let databaseName: String = "mfadvisor"
    private let bundleIdentifier: String = "org.cocoapods.mfadvisor"
    
    public static let sharedInstance = MFADataService()
    
    private init() {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let applicationDocumentsDirectoryurls: NSURL = urls[urls.count - 1] as NSURL
        let mfaBundle = Bundle(identifier: bundleIdentifier)
        let managedObjectModel = NSManagedObjectModel(contentsOf: mfaBundle!.url(forResource: databaseName, withExtension: "momd")!)!
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = applicationDocumentsDirectoryurls.appendingPathComponent(databaseName + ".sqlite")
        do {
            try persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let  error as NSError {
            logToConsole(printObject: error.localizedDescription)
            abort()
        }
    }
    
    public func metaCategoryMasterRepo(context: NSManagedObjectContext) -> MetaCategoryMasterRepo{
        return MetaCategoryMasterRepo.init(managedContext: context)
    }
    
    public func metaPopularFundsConfigRepo(context: NSManagedObjectContext) -> MetaPopularFundsConfigRepo{
        return MetaPopularFundsConfigRepo.init(managedContext: context)
    }
    
    public func metaCategoryQuestionsRepo(context: NSManagedObjectContext) -> MetaCategoryQuestionsRepo {
        return MetaCategoryQuestionsRepo.init(managedContext: context)
    }
    
    public func metaOtherFundDataRepo(context: NSManagedObjectContext) -> MetaOtherFundDataRepo {
        return MetaOtherFundDataRepo.init(managedContext: context)
    }
    
    public func metaOtherFundMasterRepo(context: NSManagedObjectContext) -> MetaOtherFundMasterRepo {
        return MetaOtherFundMasterRepo.init(managedContext: context)
    }
    
    public func metaFundMasterRepo(context: NSManagedObjectContext) -> MetaFundMasterRepo{
        return MetaFundMasterRepo.init(managedContext: context)
    }
    
    public func metaFundNameLookupRepo(context: NSManagedObjectContext) -> MetaFundNameLookupRepo{
        return MetaFundNameLookupRepo.init(managedContext: context)
    }
    
    public func metaMutualFundSelectionRepo(context: NSManagedObjectContext) -> MetaMutualFundSelectionRepo {
        return MetaMutualFundSelectionRepo.init(managedContext: context)
    }
    
    public func metaPresentationDisplayDataRepo(context: NSManagedObjectContext) -> MetaPresentationDisplayDataRepo {
        return MetaPresentationDisplayDataRepo.init(managedContext: context)
    }
    
    public func metaMutualFundMinInvestmentRepo(context: NSManagedObjectContext) -> MetaMutualFundMinInvestmentRepo {
        return MetaMutualFundMinInvestmentRepo.init(managedContext: context)
    }
    
    public func metaImageHerolineSelectionRepo(context: NSManagedObjectContext) -> MetaImageHerolineSelectionRepo {
        return MetaImageHerolineSelectionRepo.init(managedContext: context)
    }
    
    public func metaFundDataRepo(context: NSManagedObjectContext) -> MetaFundDataRepo{
        return MetaFundDataRepo.init(managedContext: context)
    }
    
    public func metaFundQuestionsRepo(context: NSManagedObjectContext) -> MetaFundQuestionsRepo {
        return MetaFundQuestionsRepo.init(managedContext: context)
    }
    
    public func metaFundDataLiveRepo(context: NSManagedObjectContext) -> MetaFundDataLiveRepo {
        return MetaFundDataLiveRepo.init(managedContext: context)
    }
    
    public func mfNavDataRepo(context: NSManagedObjectContext) -> MFNavDataRepo {
        return MFNavDataRepo.init(managedContext: context)
    }
    
}
