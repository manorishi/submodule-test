//
//  MetaFundDataRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaFundDataRepo contains CRUD operations related to MetaFundData table
 */
public class MetaFundDataRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaFundData"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func fundDataFromDictionary(contentData: Dictionary<String, Any>) -> MetaFundData {
        let contentManagedObject = MetaFundData(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        
        if let id = contentData["fund_id"] {
            contentManagedObject.fund_id =  id as? String ?? ""
            
            if let fundDescription = contentData["fund_description"] {
                contentManagedObject.fund_description = fundDescription as? String ?? ""
            }
            
            if let specialtyIcon1 = contentData["specialty_icon1"] {
                contentManagedObject.specialty_icon1 = specialtyIcon1 as? String ?? ""
            }
            
            if let specialtyline1 = contentData["specialty_line1"] {
                contentManagedObject.specialty_line1 = specialtyline1 as? String ?? ""
            }
            
            if let specialtyIcon2 = contentData["specialty_icon2"] {
                contentManagedObject.specialty_icon2 = specialtyIcon2 as? String ?? ""
            }
            
            if let specialtyLine2 = contentData["specialty_line2"] {
                contentManagedObject.specialty_line2 = specialtyLine2 as? String ?? ""
            }
            
            if let specialtyIcon3 = contentData["specialty_icon3"] {
                contentManagedObject.specialty_icon3 = specialtyIcon3 as? String ?? ""
            }
            
            if let specialtyLine3 = contentData["specialty_line3"] {
                contentManagedObject.specialty_line3 = specialtyLine3 as? String ?? ""
            }
            
            if let specialtyDisclaimer = contentData["specialty_disclaimer"] {
                contentManagedObject.specialty_disclaimer = specialtyDisclaimer as? String ?? ""
            }
            
            if let exitload = contentData["exit_load"] {
                contentManagedObject.exit_load = exitload as? String ?? ""
            }
            
            if let lockinPeriod = contentData["lockin_period"] {
                contentManagedObject.lockin_period = lockinPeriod as? String ?? ""
            }
            
            if let tenureLine = contentData["tenure_line"] {
                contentManagedObject.tenure_line = tenureLine as? String ?? ""
            }
            
            if let liquidityOptions = contentData["liquidity_options"] {
                contentManagedObject.liquidity_options = liquidityOptions as? String ?? ""
            }
            
            if let riskoMeter = contentData["riskometer"] {
                contentManagedObject.riskometer = riskoMeter as? String ?? ""
            }
            
            if let productLabel = contentData["product_label"] {
                contentManagedObject.product_label = productLabel as? String ?? ""
            }
            
            if let productLabelDisclaimer = contentData["product_label_disclaimer"] {
                contentManagedObject.product_label_disclaimer = productLabelDisclaimer as? String ?? ""
            }
            
            if let fundType1 = contentData["fund_type1"] {
                contentManagedObject.fund_type1 = fundType1 as? String ?? ""
            }
            
            if let fundType2 = contentData["fund_type2"] {
                contentManagedObject.fund_type2 = fundType2 as? String ?? ""
            }
            
            if let keyRatioLabel1 = contentData["key_ratio_label1"] {
                contentManagedObject.key_ratio_label1 = keyRatioLabel1 as? String ?? ""
            }
            
            if let keyRatioLabel2 = contentData["key_ratio_label2"] {
                contentManagedObject.key_ratio_label2 = keyRatioLabel2 as? String ?? ""
            }
            
            if let keyRatioLabel3 = contentData["key_ratio_label3"] {
                contentManagedObject.key_ratio_label3 = keyRatioLabel3 as? String ?? ""
            }
            
            if let otherFund1Id = contentData["other_fund1_id"] {
                contentManagedObject.other_fund1_id = otherFund1Id as? String ?? ""
            }
            
            if let otherFund2Id = contentData["other_fund2_id"] {
                contentManagedObject.other_fund2_id = otherFund2Id as? String ?? ""
            }
            
            if let otherFund3Id = contentData["other_fund3_id"] {
                contentManagedObject.other_fund3_id = otherFund3Id as? String ?? ""
            }
            
            if let otherFund4Id = contentData["other_fund4_id"] {
                contentManagedObject.other_fund4_id = otherFund4Id as? String ?? ""
            }
            
            if let topImage1 = contentData["top_image1"] {
                contentManagedObject.top_image1 = topImage1 as? String ?? ""
            }
            
            if let topImage2 = contentData["top_image2"] {
                contentManagedObject.top_image2 = topImage2 as? String ?? ""
            }
            
            if let disclaimer1 = contentData["disclaimer1"] {
                contentManagedObject.disclaimer1 = disclaimer1 as? String ?? ""
            }
            
            if let compareIcon1 = contentData["compare_icon1"] {
                contentManagedObject.compare_icon1 = compareIcon1 as? String ?? ""
            }
            
            if let compareIcon2 = contentData["compare_icon2"] {
                contentManagedObject.compare_icon2 = compareIcon2 as? String ?? ""
            }
            
            if let compareIcon3 = contentData["compare_icon3"] {
                contentManagedObject.compare_icon3 = compareIcon3 as? String ?? ""
            }
            
            if let comparePoint1 = contentData["compare_point1"] {
                contentManagedObject.compare_point1 = comparePoint1 as? String ?? ""
            }
            
            if let comparePoint2 = contentData["compare_point2"] {
                contentManagedObject.compare_point2 = comparePoint2 as? String ?? ""
            }
            
            if let comparePoint3 = contentData["compare_point3"] {
                contentManagedObject.compare_point3 = comparePoint3 as? String ?? ""
            }
        }
        return contentManagedObject
    }
    
    func createFundData(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: fundDataFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func contentHavingId(fundId: String) -> MetaFundData? {
        return readEntry(condition: NSPredicate(format: "fund_id == %@", fundId), entity: entityName, context: managedContext) as? MetaFundData ?? nil
    }
}
