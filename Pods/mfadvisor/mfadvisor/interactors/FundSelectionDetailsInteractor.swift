//
//  FundSelectionDetailsInteractor.swift
//  mfadvisor
//
//  Created by Anurag Dake on 03/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData

/**
 FundSelectionDetailsInteractor fetches selected funds details to display on FundSelectionDetails screen
 */
class FundSelectionDetailsInteractor{
    
    ///Fetch fund details from db to return MFSelectionItem
    func getFundData(managedObjectContext: NSManagedObjectContext, fundsWithAllocation: [String : Float], maxDuration: Int, riskAppetite: String) -> MFSelectionItem{
        let mfaDataService = MFADataService.sharedInstance
        let mfSelectionItem = MFSelectionItem()
        var metaFunds = [MetaFundData]()
        var metaFundsMaster = [MetaFundMaster]()
        let heroLineSelectionItem = mfaDataService.metaImageHerolineSelectionRepo(context: managedObjectContext).heroLineSelectionItem(durationUpto: maxDuration, risk: riskAppetite)
        
        let presentationDisplayData = mfaDataService.metaPresentationDisplayDataRepo(context: managedObjectContext).allPresentationDisplayData().first
        mfSelectionItem.tenureIcon = presentationDisplayData?.tenure_icon
        mfSelectionItem.tenureHeading = presentationDisplayData?.tenure_heading
        mfSelectionItem.tenureInfo = presentationDisplayData?.tenure_intro
        mfSelectionItem.liquidityIcon = presentationDisplayData?.liquidity_icon
        mfSelectionItem.liquidityHeading = presentationDisplayData?.liquidity_heading
        mfSelectionItem.liquidityInfo = presentationDisplayData?.liquidity_intro
        mfSelectionItem.presentationPage3Disclaimer = presentationDisplayData?.presentation_page3_disclaimer
        
        if fundsWithAllocation.count > 1{
            for fundItem in fundsWithAllocation{
                if let fundData = fund(with: fundItem.key, mfaDataService: mfaDataService, managedObjectContext: managedObjectContext){
                    metaFunds.append(fundData)
                }
                if let fundData = fundMaster(with: fundItem.key, mfaDataService: mfaDataService, managedObjectContext: managedObjectContext){
                    metaFundsMaster.append(fundData)
                }
            }
            mfSelectionItem.page1TopImage = heroLineSelectionItem?.image
        }else{
            if let fundData = fund(with: fundsWithAllocation.first?.key ?? "", mfaDataService: mfaDataService, managedObjectContext: managedObjectContext){
                metaFunds.append(fundData)
            }
            if let fundData = fundMaster(with: fundsWithAllocation.first?.key ?? "", mfaDataService: mfaDataService, managedObjectContext: managedObjectContext){
                metaFundsMaster.append(fundData)
            }
            mfSelectionItem.page1TopImage = metaFunds.first?.top_image1
        }
        
        mfSelectionItem.page1Heroline = heroLineSelectionItem?.hero_line
        mfSelectionItem.fundItems = selectionFundItem(metaFunds: metaFunds, metaFundsMaster: metaFundsMaster, fundsWithAllocation: fundsWithAllocation)
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
    
    ///Generates SelectionFundItem list
    private func selectionFundItem(metaFunds: [MetaFundData], metaFundsMaster: [MetaFundMaster], fundsWithAllocation: [String : Float]) -> [SelectionFundItem]{
        var selectionFundItems = [SelectionFundItem]()
        
        for metaFund in metaFunds{
            let selectionFundItem = SelectionFundItem()
            if let metaFundMaster: MetaFundMaster = metaFundsMaster.first(where: { $0.fund_id == metaFund.fund_id  }){
                selectionFundItem.fundId = metaFund.fund_id
                selectionFundItem.fundName = metaFundMaster.fund_name
                selectionFundItem.fundInitials = metaFundMaster.fund_initials
                selectionFundItem.fundDescription = metaFund.fund_description ?? ""
                selectionFundItem.fundAllocation = fundsWithAllocation[metaFund.fund_id ?? ""]
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
    
}
