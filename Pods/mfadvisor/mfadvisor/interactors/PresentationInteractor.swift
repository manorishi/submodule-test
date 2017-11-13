//
//  PresentationInteractor.swift
//  mfadvisor
//
//  Created by Apple on 07/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core
import CoreData

/**
 PresentationInteractor fetches fund presentation data from db
 */
class PresentationInteractor {
    
    func getMutualFundMinInvestmentData(fundId:String, managedObjectContext:NSManagedObjectContext) -> MetaMutualFundMinInvestment? {
        let metaFundMasterRepo = MFADataService.sharedInstance.metaMutualFundMinInvestmentRepo(context: managedObjectContext)
        return metaFundMasterRepo.contentHavingId(fundId: fundId)
    }
    
    func getMFSelectionItemDataWith(fundId:String, managedObjectContext: NSManagedObjectContext, bundle:Bundle) -> MFSelectionItem {
        let mfaDataService = MFADataService.sharedInstance
        let mfSelectionItem = MFSelectionItem()
        var metaFunds = [MetaFundData]()
        var metaFundsMaster = [MetaFundMaster]()
        
        let presentationDisplayData = mfaDataService.metaPresentationDisplayDataRepo(context: managedObjectContext).allPresentationDisplayData().first
        mfSelectionItem.tenureIcon = presentationDisplayData?.tenure_icon
        mfSelectionItem.tenureHeading = presentationDisplayData?.tenure_heading
        mfSelectionItem.tenureInfo = presentationDisplayData?.tenure_intro
        mfSelectionItem.liquidityIcon = presentationDisplayData?.liquidity_icon
        mfSelectionItem.liquidityHeading = presentationDisplayData?.liquidity_heading
        mfSelectionItem.liquidityInfo = presentationDisplayData?.liquidity_intro
        mfSelectionItem.presentationPage3Disclaimer = presentationDisplayData?.presentation_page3_disclaimer
        
        if let fundData = fund(with: fundId, mfaDataService: mfaDataService, managedObjectContext: managedObjectContext){
            metaFunds.append(fundData)
        }
        if let fundData = fundMaster(with: fundId, mfaDataService: mfaDataService, managedObjectContext: managedObjectContext){
            metaFundsMaster.append(fundData)
        }
        mfSelectionItem.page1TopImage = metaFunds.first?.top_image1
        mfSelectionItem.page1Heroline = NSLocalizedString("PAGE1_HEROLINE", tableName: nil, bundle: bundle, value: "", comment: "")
        mfSelectionItem.fundItems = selectionFundItem(metaFunds: metaFunds, metaFundsMaster: metaFundsMaster)
        minMaxValuesForFunds(managedObjectContext: managedObjectContext, selectionFundItems: mfSelectionItem.fundItems)
        return mfSelectionItem
    }
    
    private func fund(with fundId: String, mfaDataService: MFADataService, managedObjectContext:NSManagedObjectContext) -> MetaFundData?{
        guard let fundData = mfaDataService.metaFundDataRepo(context: managedObjectContext).contentHavingId(fundId: fundId) else{
            return nil
        }
        return fundData
    }
    
    private func fundMaster(with fundId: String, mfaDataService: MFADataService, managedObjectContext:NSManagedObjectContext) -> MetaFundMaster?{
        guard let fundData = mfaDataService.metaFundMasterRepo(context: managedObjectContext).fundHavingId(fundId: fundId) else{
            return nil
        }
        return fundData
    }
    
    private func selectionFundItem(metaFunds: [MetaFundData], metaFundsMaster: [MetaFundMaster]) -> [SelectionFundItem]{
        var selectionFundItems = [SelectionFundItem]()
        
        for metaFund in metaFunds{
            let selectionFundItem = SelectionFundItem()
            if let metaFundMaster: MetaFundMaster = metaFundsMaster.first(where: { $0.fund_id == metaFund.fund_id  }){
                selectionFundItem.fundId = metaFund.fund_id
                selectionFundItem.fundName = metaFundMaster.fund_name
                selectionFundItem.fundInitials = metaFundMaster.fund_initials
                selectionFundItem.fundDescription = metaFund.fund_description ?? ""
                selectionFundItem.fundAllocation = 0
                selectionFundItem.fundTopImage1 = metaFund.top_image1
                selectionFundItem.fundTopImage2 = metaFund.top_image2
                selectionFundItem.specialityIcon1 = metaFund.specialty_icon1
                selectionFundItem.specialityIcon2 = metaFund.specialty_icon2
                selectionFundItem.specialityIcon3 = metaFund.specialty_icon3
                selectionFundItem.specialityLine1 = metaFund.specialty_line1
                selectionFundItem.specialityLine2 = metaFund.specialty_line2
                selectionFundItem.specialityLine3 = metaFund.specialty_line3
                selectionFundItem.specialityDisclaimer = metaFund.specialty_disclaimer
                selectionFundItem.tenureLine = metaFund.tenure_line
                selectionFundItem.liquidityLine = metaFund.liquidity_options
                selectionFundItem.productLabel = metaFund.product_label
                selectionFundItem.productLabelDisclaimer = metaFund.product_label_disclaimer
                selectionFundItem.riskometerImage = metaFund.riskometer
            }
            selectionFundItems.append(selectionFundItem)
        }
        return selectionFundItems
    }
    
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
