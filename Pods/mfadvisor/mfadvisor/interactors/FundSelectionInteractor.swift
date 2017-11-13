//
//  FundSelectorInteractor.swift
//  mfadvisor
//
//  Created by Anurag Dake on 28/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Core
import CoreData

/**
 FundSelectionInteractor fetches funds from db according to given data
 */
class FundSelectionInteractor{
    
    ///Fetch funds with given slots from metaMutualFundSelection repo and metaFundNameLookup repo
    func fundsWithSlots(managedObjectContext:NSManagedObjectContext, minAge: Int, maxAge: Int?, minDuration: Int, maxDuration: Int?, riskAppetite: String, lockInFlag: String) -> [String:Float]{
        let mfaDataService = MFADataService.sharedInstance
        guard let fundSelectionItem = mfaDataService.metaMutualFundSelectionRepo(context: managedObjectContext).contentWith(minAge: minAge, maxAge: maxAge, minDuration: minDuration, maxDuration: maxDuration, riskAppetite: riskAppetite, lockInFlag: lockInFlag) else{
            return [:]
        }
        
        var funds = [String:Float]()
        for fundSlot in slots(fundSelectionItem: fundSelectionItem){
            if let fundId = mfaDataService.metaFundNameLookupRepo(context: managedObjectContext).fundIdHaving(slot: fundSlot.key){
                funds[fundId] = fundSlot.value
            }
        }
        return funds
    }
    
    private func slots(fundSelectionItem: MetaMutualFundSelection) -> [String:Float]{
        var slots = [String:Float]()
        if fundSelectionItem.slot1 != 0{
            slots["slot1"] = fundSelectionItem.slot1
        }
        if fundSelectionItem.slot2 != 0{
            slots["slot2"] = fundSelectionItem.slot2
        }
        if fundSelectionItem.slot3 != 0{
            slots["slot3"] = fundSelectionItem.slot3
        }
        if fundSelectionItem.slot4 != 0{
            slots["slot4"] = fundSelectionItem.slot4
        }
        if fundSelectionItem.slot5 != 0{
            slots["slot5"] = fundSelectionItem.slot5
        }
        if fundSelectionItem.slot6 != 0{
            slots["slot6"] = fundSelectionItem.slot6
        }
        return slots
    }
}
