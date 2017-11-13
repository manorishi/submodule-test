//
//  FundSelectionFormInteractor.swift
//  mfadvisor
//
//  Created by Anurag Dake on 08/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 FundSelectionFormInteractor fetches fund validation values from db
 */
class FundSelectionFormInteractor {
    
    ///Fetch min max values for lumpsum/sip for given funds from db
    func minMaxValuesForFunds(managedObjectContext: NSManagedObjectContext, selectionFundItems: [SelectionFundItem]){
        
        for fundItem in selectionFundItems{
            if let fundMinValueSelectionItem = MFADataService.sharedInstance.metaMutualFundMinInvestmentRepo(context: managedObjectContext).contentHavingId(fundId: fundItem.fundId ?? ""){
                fundItem.lumpsumMinimum = fundMinValueSelectionItem.lumpsum_minimum
                fundItem.lumpsumMaximum = fundMinValueSelectionItem.lumpsum_maximum
                fundItem.lumpsumMultiple = fundMinValueSelectionItem.lumpsum_min_multiple
                fundItem.sipMinimum = fundMinValueSelectionItem.sip_minimum
                fundItem.sipMaximum = fundMinValueSelectionItem.sip_maximum
                fundItem.sipMultiple = fundMinValueSelectionItem.sip_min_multiple
            }
        }
        
    }
}
