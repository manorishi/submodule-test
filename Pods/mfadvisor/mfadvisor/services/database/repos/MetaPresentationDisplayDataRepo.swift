//
//  MetaPresentationDisplayDataRepo.swift
//  mfadvisor
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 MetaPresentationDisplayDataRepo contains CRUD operations related to MetaPresentationDisplayData table
 */
public class MetaPresentationDisplayDataRepo: MFABaseRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "MetaPresentationDisplayData"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func presentationDisplayDataFromDictionary(contentData: Dictionary<String, Any>) -> MetaPresentationDisplayData {
        let contentManagedObject = MetaPresentationDisplayData(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        
        if let generalPresentationTopImage1 = contentData["general_presentation_top_image1"] {
            contentManagedObject.general_presentation_top_image1 = generalPresentationTopImage1 as? String ?? ""
        }
        
        if let presentationPage2Disclaimer = contentData["presentation_page2_disclaimer"] {
            contentManagedObject.presentation_page2_disclaimer = presentationPage2Disclaimer as? String ?? ""
        }
        
        if let presentationPage3Disclaimer = contentData["presentation_page3_disclaimer"] {
            contentManagedObject.presentation_page3_disclaimer = presentationPage3Disclaimer as? String ?? ""
        }
        
        if let presentationPage2Heading = contentData["presentation_page2_heading"] {
            contentManagedObject.presentation_page2_heading = presentationPage2Heading as? String ?? ""
        }
        
        if let presentationPage3Heading = contentData["presentation_page3_heading"] {
            contentManagedObject.presentation_page3_heading = presentationPage3Heading as? String ?? ""
        }
        
        if let tenureIcon = contentData["tenure_icon"] {
            contentManagedObject.tenure_icon = tenureIcon as? String ?? ""
        }
        
        if let liquidityIcon = contentData["liquidity_icon"] {
            contentManagedObject.liquidity_icon = liquidityIcon as? String ?? ""
        }
        
        if let productLabelIcon = contentData["product_label_icon"] {
            contentManagedObject.product_label_icon = productLabelIcon as? String ?? ""
        }
        
        if let selectionPage1Disclaimer = contentData["selection_page1_disclaimer"] {
            contentManagedObject.selection_page1_disclaimer = selectionPage1Disclaimer as? String ?? ""
        }
        
        if let selectionPage2Disclaimer = contentData["selection_page2_disclaimer"] {
            contentManagedObject.selection_page2_disclaimer = selectionPage2Disclaimer as? String ?? ""
        }
        
        if let selectionPage3Disclaimer = contentData["selection_page3_disclaimer"] {
            contentManagedObject.selection_page3_disclaimer = selectionPage3Disclaimer as? String ?? ""
        }
        
        if let tenureHeading = contentData["tenure_heading"] {
            contentManagedObject.tenure_heading = tenureHeading as? String ?? ""
        }
        
        if let tenureIntro = contentData["tenure_intro"] {
            contentManagedObject.tenure_intro = tenureIntro as? String ?? ""
        }
        
        if let liquidityHeading = contentData["liquidity_heading"] {
            contentManagedObject.liquidity_heading = liquidityHeading as? String ?? ""
        }
        
        if let liquidityIntro = contentData["liquidity_intro"] {
            contentManagedObject.liquidity_intro = liquidityIntro as? String ?? ""
        }
        
        if let suggestionHeading = contentData["suggestion_heading"] {
            contentManagedObject.suggestion_heading = suggestionHeading as? String ?? ""
        }
        
        return contentManagedObject
    }
    
    func createPresentationDisplayData(contentArray: [Dictionary<String, Any>]) -> Bool {
        for content:Dictionary in contentArray {
            if !createEntry(object: presentationDisplayDataFromDictionary(contentData: content)){
                return false
            }
        }
        return true
    }
    
    public func allPresentationDisplayData() -> [MetaPresentationDisplayData] {
        return readAllEntries(entity: entityName, context: managedContext) as? [MetaPresentationDisplayData] ?? []
    }
    
    func deleteContentType() -> Bool {
        return deleteEntry(entityName: entityName, context: managedContext)
    }
}
