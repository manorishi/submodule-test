//
//  FundDetailInteractor.swift
//  mfadvisor
//
//  Created by Apple on 07/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core

/**
 FundDetailInteractor fetches fund details data from db
 */
class FundDetailInteractor {

    func fundNameFrom(fundId:String, managedObjectContext: NSManagedObjectContext) -> String? {
        let metaFundMasterRepo = MFADataService.sharedInstance.metaFundMasterRepo(context: managedObjectContext)
        let fundData = metaFundMasterRepo.fundHavingId(fundId: fundId)
        return fundData?.fund_name
    }
    
}
