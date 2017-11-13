//
//  MFBasePresenter.swift
//  mfadvisor
//
//  Created by Anurag Dake on 08/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core

/**
 MFBasePresenter generates pages and views which are common in fund details viewcontroller and fund presentation view controller
 */
class MFBasePresenter: NSObject{
    
    ///Generates fund info page
    func pageFundView(fundItem: SelectionFundItem, scrollView: UIScrollView, pageWidth: CGFloat, pageHeight: CGFloat, pageNumber: Int) -> UIView{
        let fundPage = UIView()
        fundPage.backgroundColor = UIColor.white
        fundPage.frame = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder ) else {
            return fundPage
        }
        
        let topImageView = bundle.loadNibNamed("TopImageView", owner: self, options: nil)?[0] as! TopImageView
        topImageView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: (pageWidth*9/16))
        topImageView.topImageView.image = UIImage(named: fundItem.fundTopImage2 ?? "", in: bundle, compatibleWith: nil) ?? UIImage()
        topImageView.titleLabel.text = fundItem.fundName ?? ""
        fundPage.addSubview(topImageView)
        
        let herolineView = bundle.loadNibNamed("HerolineView", owner: self, options: nil)?[0] as! HerolineView
        herolineView.frame = CGRect(x: 0, y: topImageView.frame.maxY, width: pageWidth, height: 50)
        herolineView.heroLineLabel.text = fundItem.fundDescription ?? ""
        fundPage.addSubview(herolineView)
        
        let specialityLineView1 = specialityView(bundle: bundle, viewJustAbove: herolineView, pageWidth: pageWidth, specialityIcon: fundItem.specialityIcon1, specialityLine: fundItem.specialityLine1)
        let specialityLineView2 = specialityView(bundle: bundle, viewJustAbove: specialityLineView1, pageWidth: pageWidth, specialityIcon: fundItem.specialityIcon2, specialityLine: fundItem.specialityLine2)
        let specialityLineView3 = specialityView(bundle: bundle, viewJustAbove: specialityLineView2, pageWidth: pageWidth, specialityIcon: fundItem.specialityIcon3, specialityLine: fundItem.specialityLine3)
        
        if fundItem.specialityLine1 != nil{
            fundPage.addSubview(specialityLineView1)
        }
        
        if fundItem.specialityLine2 != nil{
            fundPage.addSubview(specialityLineView2)
        }
        
        if fundItem.specialityLine3 != nil{
            fundPage.addSubview(specialityLineView3)
        }
        
        let pageNoLabel = pageNumberLabel(pageNo: pageNumber, pageWidth: pageWidth, pageHeight: pageHeight)
        fundPage.addSubview(pageNoLabel)
        
        let disclaimerView = disclaimerLabel(disclaimertext: fundItem.specialityDisclaimer, pageWidth: pageWidth, pageNumberLabelY: pageNoLabel.frame.origin.y)
        fundPage.addSubview(disclaimerView)
        return fundPage
    }
    
    ///Generates tenure an dliquidity details page
    func tenureAndLiquidityPageView(mFSelectionItem: MFSelectionItem, scrollView: UIScrollView, pageWidth: CGFloat, pageHeight: CGFloat, pageNumber: Int) -> UIView {
        let tenureAndLiquidityPage = UIView()
        tenureAndLiquidityPage.backgroundColor = UIColor.white
        tenureAndLiquidityPage.frame = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let isSingleFund = mFSelectionItem.fundItems.count == 1
        
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder ) else {
            return tenureAndLiquidityPage
        }
        
        let tenureView = bundle.loadNibNamed("TenureLiquidityView", owner: self, options: nil)?[0] as! TenureLiquidityView
        tenureView.frame = CGRect(x: 16, y: 20, width: pageWidth - 32, height: 70)
        tenureView.tenureLiquidityImageView.image = UIImage(named: mFSelectionItem.tenureIcon ?? "", in: bundle, compatibleWith: nil) ?? UIImage()
        tenureView.tenureLiquidityTitleLabel.text = mFSelectionItem.tenureHeading
        tenureView.tenureLiquidityInfoLabel.text = mFSelectionItem.tenureInfo
        tenureAndLiquidityPage.addSubview(tenureView)
        
        var viewJustAbove : UIView = tenureView
        for (index, fund) in mFSelectionItem.fundItems.enumerated() {
            let tenureFundInfoView = bundle.loadNibNamed("TenureLiquidityInfoView", owner: self, options: nil)?[0] as! TenureLiquidityInfoView
            tenureFundInfoView.frame = CGRect(x: 16, y: viewJustAbove.frame.maxY, width: pageWidth - 32, height: 50)
            tenureFundInfoView.fundInitialsLabel.text = fund.fundInitials ?? ""
            tenureFundInfoView.tenureLiquidityLineLabel.htmlFromString(htmlText: fund.tenureLine ?? "")
            tenureFundInfoView.backgroundColor = index % 2 == 0 ? UIColor.white : hexStringToUIColor(hex: "#EAEAEA")
            tenureAndLiquidityPage.addSubview(tenureFundInfoView)
            viewJustAbove = tenureFundInfoView
        }
        
        let liquidityView = bundle.loadNibNamed("TenureLiquidityView", owner: self, options: nil)?[0] as! TenureLiquidityView
        liquidityView.frame = CGRect(x: 16, y: viewJustAbove.frame.maxY + (isSingleFund ? 8 : 20), width: pageWidth - 32, height: isSingleFund ? 60 : 70)
        liquidityView.tenureLiquidityImageView.image = UIImage(named: mFSelectionItem.liquidityIcon ?? "", in: bundle, compatibleWith: nil) ?? UIImage()
        liquidityView.tenureLiquidityTitleLabel.text = mFSelectionItem.liquidityHeading
        liquidityView.tenureLiquidityInfoLabel.text = mFSelectionItem.liquidityInfo
        tenureAndLiquidityPage.addSubview(liquidityView)
        
        viewJustAbove = liquidityView
        for (index, fund) in mFSelectionItem.fundItems.enumerated() {
            let liquidityFundInfoView = bundle.loadNibNamed("TenureLiquidityInfoView", owner: self, options: nil)?[0] as! TenureLiquidityInfoView
            liquidityFundInfoView.frame = CGRect(x: 16, y: viewJustAbove.frame.maxY, width: pageWidth - 32, height: 50)
            liquidityFundInfoView.fundInitialsLabel.text = fund.fundInitials ?? ""
            liquidityFundInfoView.tenureLiquidityLineLabel.htmlFromString(htmlText: fund.liquidityLine ?? "")
            liquidityFundInfoView.backgroundColor = index % 2 == 0 ? UIColor.white : hexStringToUIColor(hex: "#EAEAEA")
            tenureAndLiquidityPage.addSubview(liquidityFundInfoView)
            viewJustAbove = liquidityFundInfoView
        }
        var updatePageHeight = pageHeight
        if mFSelectionItem.fundItems.count == 1{
            if let fund = mFSelectionItem.fundItems.first{
                let riskometer = riskometerView(fund: fund, bundle: bundle, y: viewJustAbove.frame.maxY, pageWidth: pageWidth, riskometerHeight: 150)
                riskometer.updateViewHeight()
                let riskAndExtraHeight = (mFSelectionItem.presentationPage3Disclaimer?.heightWithConstrainedWidth(pageWidth - 32, font:UIFont.systemFont(ofSize: 10)) ?? 0) + 30 + riskometer.frame.origin.y + riskometer.frame.height
                updatePageHeight = pageHeight < riskAndExtraHeight ? riskAndExtraHeight : pageHeight
                tenureAndLiquidityPage.frame.size.height = updatePageHeight
                tenureAndLiquidityPage.addSubview(riskometer)
            }
        }
        
        let pageNoLabel = pageNumberLabel(pageNo: pageNumber, pageWidth: pageWidth, pageHeight: updatePageHeight)
        tenureAndLiquidityPage.addSubview(pageNoLabel)
        
        let disclaimerView = disclaimerLabel(disclaimertext: mFSelectionItem.presentationPage3Disclaimer, pageWidth: pageWidth, pageNumberLabelY: pageNoLabel.frame.origin.y)
        tenureAndLiquidityPage.updateConstraints()
        tenureAndLiquidityPage.addSubview(disclaimerView)
        return tenureAndLiquidityPage
    }
    
    ///Generates riskometer details page
    func riskometerPageView(mFSelectionItem: MFSelectionItem, scrollView: UIScrollView, pageWidth: CGFloat, pageHeight: CGFloat, pageNumber: Int) -> UIView{
        let riskometerPage = UIView()
        riskometerPage.backgroundColor = UIColor.white
        riskometerPage.frame = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder ) else {
            return riskometerPage
        }
        
        var viewJustAbove : UIView!
        for (index, fund) in mFSelectionItem.fundItems.enumerated() {
            let y = index == 0 ? 20 : (viewJustAbove.frame.maxY + 20)
            let riskometer = riskometerView(fund: fund, bundle: bundle, y: CGFloat(y), pageWidth: pageWidth, riskometerHeight: 170)
            riskometer.updateViewHeight()
            riskometerPage.addSubview(riskometer)
            viewJustAbove = riskometer
        }
        
        let eodLabel = UILabel(frame: CGRect(x: 16, y: viewJustAbove.frame.maxY + 16, width: pageWidth, height: 30))
        eodLabel.text = "End of Document"
        eodLabel.font = UIFont.boldSystemFont(ofSize: 15)
        riskometerPage.addSubview(eodLabel)
        
        riskometerPage.addSubview(pageNumberLabel(pageNo: pageNumber, pageWidth: pageWidth, pageHeight: pageHeight))
        return riskometerPage
    }
    
    ///Generates riskometer view
    func riskometerView(fund: SelectionFundItem, bundle: Bundle, y: CGFloat, pageWidth: CGFloat, riskometerHeight: CGFloat) -> RiskometerView{
        let riskometerView = bundle.loadNibNamed("RiskometerView", owner: self, options: nil)?[0] as! RiskometerView
        riskometerView.frame = CGRect(x: 8, y: y, width: pageWidth - 16, height: riskometerHeight)
        riskometerView.fundNameLabel.text = fund.fundName ?? ""
        riskometerView.productLabel.htmlFromString(htmlText: fund.productLabel ?? "")
        riskometerView.productDisclaimerLabel.text = fund.productLabelDisclaimer ?? ""
        riskometerView.riskometerImageView.image = UIImage(named: fund.riskometerImage ?? "", in: bundle, compatibleWith: nil) ?? UIImage()
        return riskometerView
    }
    
    ///Generates speciality view
    func specialityView(bundle: Bundle, viewJustAbove: UIView, pageWidth: CGFloat, specialityIcon: String?, specialityLine: String?) -> SpecialityLineView{
        let specialityLineView = bundle.loadNibNamed("SpecialityLineView", owner: self, options: nil)?[0] as! SpecialityLineView
        specialityLineView.frame = CGRect(x: 0, y: viewJustAbove.frame.maxY + 8, width: pageWidth, height: 60)
        specialityLineView.specialityIconImageView.image = UIImage(named: specialityIcon ?? "", in: bundle, compatibleWith: nil) ?? UIImage()
        specialityLineView.specialityTextLabel.htmlFromString(htmlText: specialityLine ?? "")
        return specialityLineView
    }
    
    ///Generates seperator view
    func seperatorView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat = 8) -> UIView{
        let seperatorView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        seperatorView.backgroundColor = UIColor.lightGray
        return seperatorView
    }
    
    ///Generates page number label
    func pageNumberLabel(pageNo: Int, pageWidth: CGFloat, pageHeight: CGFloat) -> UILabel{
        let pageNoLabel = UILabel(frame: CGRect(x: pageWidth - 66, y: pageHeight - 30, width: 50, height: 30))
        pageNoLabel.text = "Pg. \(pageNo)"
        pageNoLabel.textAlignment = .right
        pageNoLabel.textColor = UIColor.darkGray
        pageNoLabel.font = UIFont.systemFont(ofSize: 13)
        return pageNoLabel
    }
    
    ///Generates disclaimer label
    func disclaimerLabel(disclaimertext: String?, pageWidth: CGFloat, pageNumberLabelY: CGFloat) -> UILabel{
        let disclaimerLabel = UILabel(frame: CGRect(x: 16, y: 0, width: pageWidth - 32, height: 0))
        disclaimerLabel.font = UIFont.systemFont(ofSize: 10)
        disclaimerLabel.numberOfLines = 0
        disclaimerLabel.text = disclaimertext ?? ""
        disclaimerLabel.sizeToFit()
        let disclaimerHeight = disclaimerLabel.frame.height
        disclaimerLabel.frame.size.height = disclaimerHeight
        disclaimerLabel.frame.origin.y = pageNumberLabelY - disclaimerHeight
        disclaimerLabel.textColor = UIColor.darkGray
        return disclaimerLabel
    }
    
}
