//
//  FundCompareDetailInteractor.swift
//  mfadvisor
//
//  Created by Apple on 12/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core

/**
 FundCompareDetailInteractor fetches fund compare details data from db
 */
class FundCompareDetailInteractor {

    func fundDataLive(fundId:String, managedObjectContext: NSManagedObjectContext) -> MetaFundDataLive? {
        let metaFundDataLiveRepo = MFADataService.sharedInstance.metaFundDataLiveRepo(context: managedObjectContext)
        return metaFundDataLiveRepo.fundDataLiveHaving(fundId: fundId)
    }
    
    func otherFundsDataHaving(fundIds:[String], managedObjectContext: NSManagedObjectContext) -> [MetaOtherFundData] {
        let metaOtherFundDataRepo = MFADataService.sharedInstance.metaOtherFundDataRepo(context: managedObjectContext)
        return metaOtherFundDataRepo.otherFundDataHaving(fundIds:fundIds)
    }
    
    func fundData(fundId:String, managedObjectContext: NSManagedObjectContext) -> MetaFundData? {
        let metaFundDataRepo = MFADataService.sharedInstance.metaFundDataRepo(context: managedObjectContext)
        return metaFundDataRepo.contentHavingId(fundId: fundId)
    }
    
    func metaFundMasterData(fundId:String, managedObjectContext: NSManagedObjectContext) -> MetaFundMaster? {
        let metaFundMasterDataRepo = MFADataService.sharedInstance.metaFundMasterRepo(context: managedObjectContext)
        return metaFundMasterDataRepo.fundHavingId(fundId: fundId)
    }
    
    
}
