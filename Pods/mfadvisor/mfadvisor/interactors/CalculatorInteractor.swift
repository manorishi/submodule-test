//
//  CalculatorInteractor.swift
//  mfadvisor
//
//  Created by Anurag Dake on 05/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import Core
import CoreData

class CalculatorInteractor{
    
    func fundNAVData(fundId: String, managedObjectContext: NSManagedObjectContext) -> [MFNavData]{
        let navDataRepo = MFADataService.sharedInstance.mfNavDataRepo(context: managedObjectContext)
        return navDataRepo.navDataHaving(fundId: Int64(fundId) ?? 0).sorted{
            ($0.year, $0.month, $0.day) <
                ($1.year, $1.month, $1.day)
        }
    }
    
    func startAndEndDate(navData: [MFNavData]) -> (startNav: MFNavData?, endNav: MFNavData?){
        let sortedNavData = navData.sorted{
            ($0.year, $0.month, $0.day) <
                ($1.year, $1.month, $1.day)
        }
//        for entry in sortedNavData{
//            print("\(entry.fund_id) \(entry.day) \(entry.month) \(entry.year)")
//        }
        return (sortedNavData.first, sortedNavData.last)
    }
    
    
}
