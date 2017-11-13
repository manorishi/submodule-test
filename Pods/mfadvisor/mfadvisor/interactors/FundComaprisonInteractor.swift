//
//  FundComaprisonInteractor.swift
//  mfadvisor
//
//  Created by Apple on 07/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData

/**
 FundComaprisonInteractor fetches fund comparison data from db
 */
class FundComaprisonInteractor {
    func otherFunds(fundCategoryId:String, managedObjectContext: NSManagedObjectContext) -> [MetaOtherFundMaster] {
        let metaOtherFundMasterRepo = MFADataService.sharedInstance.metaOtherFundMasterRepo(context: managedObjectContext)
        return metaOtherFundMasterRepo.fundsOfCategory(categoryId: fundCategoryId)
    }
    
    func fundCategoryIdHaving(fundId:String, managedObjectContext: NSManagedObjectContext) -> String {
        let metaFundMasterRepo = MFADataService.sharedInstance.metaFundMasterRepo(context: managedObjectContext)
        return metaFundMasterRepo.fundHavingId(fundId: fundId)?.fund_category_id ?? ""
    }
}
