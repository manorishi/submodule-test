//
//  ReturnAndRatioInteractor.swift
//  mfadvisor
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core
import CoreData

/**
 ReturnAndRatioInteractor fetches fund returns and ratios data from db
 */
class ReturnAndRatioInteractor {
    
    func fundData(fundId:String, managedObjectContext: NSManagedObjectContext) -> MetaFundData? {
        let metaFundDataRepo = MFADataService.sharedInstance.metaFundDataRepo(context: managedObjectContext)
        return metaFundDataRepo.contentHavingId(fundId: fundId)
    }
    
    func fundDataLive(fundId:String, managedObjectContext: NSManagedObjectContext) -> MetaFundDataLive? {
        let metaFundDataLiveRepo = MFADataService.sharedInstance.metaFundDataLiveRepo(context: managedObjectContext)
        return metaFundDataLiveRepo.fundDataLiveHaving(fundId: fundId)
    }
    
    func fundBenchmarkOneHaving(fundId:String, managedObjectContext: NSManagedObjectContext) -> String? {
        let metaFundMasterRepo = MFADataService.sharedInstance.metaFundMasterRepo(context: managedObjectContext)
        let fundData = metaFundMasterRepo.fundHavingId(fundId: fundId)
        return fundData?.fund_benchmark_1
    }

    func fundInceptionDateHaving(fundId:String, managedObjectContext: NSManagedObjectContext) -> NSDate? {
        let metaFundMasterRepo = MFADataService.sharedInstance.metaFundMasterRepo(context: managedObjectContext)
        let fundData = metaFundMasterRepo.fundHavingId(fundId: fundId)
        return fundData?.fund_inception_date
    }
    
}
