//
//  SipCalDetailsPresenter.swift
//  mfadvisor
//
//  Created by Anurag Dake on 08/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

class SipCalDetailsPresenter: CalculatorDetailsBasePresenter{
    
    func calculationsView(sipoutput: SIPOutput, scrollView: UIScrollView, pageWidth: CGFloat, pageHeight: CGFloat) -> UIView{
        let calculationsView = UIView()
        calculationsView.backgroundColor = UIColor.white
        calculationsView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder ) else {
            return calculationsView
        }
        
        let topImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: pageWidth, height: (pageWidth * 272/720)))
        topImageView.contentMode = .scaleAspectFit
        topImageView.image = UIImage(named: "sip_calc_top_image", in: bundle, compatibleWith: nil) ?? UIImage()
        calculationsView.addSubview(topImageView)
        
        let herolineView = fundInfoView(frame: CGRect(x:0, y: topImageView.frame.size.height, width: calculationsView.frame.size.width, height: 60), title: "sip_calculations".localized, fundName: sipoutput.fundName)
        calculationsView.addSubview(herolineView)
        
        let padding: CGFloat = 4
        var viewFrame = CGRect(x: padding, y: herolineView.frame.origin.y + herolineView.frame.size.height + 8, width: pageWidth - 2 * padding , height: CGFloat(0))
        let highlightsTable = createHighlightsTable(frame: viewFrame, bundle: bundle, sipOutput: sipoutput)
        viewFrame.size.height = highlightsTable.frame.size.height
        viewFrame.origin.y += viewFrame.size.height + 8
        calculationsView.addSubview(highlightsTable)
        
        viewFrame = CGRect(x: 0, y: highlightsTable.frame.origin.y + highlightsTable.frame.size.height + 8, width: pageWidth , height: CGFloat(8))
        let seperator = seperatorView(frame: viewFrame)
        viewFrame.size.height = seperator.frame.size.height
        viewFrame.origin.y += viewFrame.size.height + 8
        calculationsView.addSubview(seperator)
        
        viewFrame.origin.x = padding
        viewFrame.size.width = pageWidth - 2 * padding
        let detailedTable = createDetailsTable(frame: viewFrame, bundle: bundle, sipCalculations: sipoutput.calculations)
        viewFrame.size.height = detailedTable.frame.size.height
        viewFrame.origin.y += viewFrame.size.height
        calculationsView.addSubview(detailedTable)
        
        calculationsView.frame.size.height = viewFrame.origin.y
        return calculationsView
    }
    
    func createDetailsTable(frame:CGRect, bundle:Bundle, sipCalculations: [SipSwpCalculation]) -> UIView{
        let detailsTableView = UIView(frame: frame)
        var rowFrame:CGRect = CGRect(x: 0, y: 0, width: frame.size.width, height: 0)
        let titleLabel = labelWithText(frame: rowFrame, message: localisedString(key: "detailed_table", bundle: bundle), backgroundColor: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 13))
        titleLabel.edgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        titleLabel.frame.size.height += 14
        detailsTableView.addSubview(titleLabel)
        rowFrame.size.height = titleLabel.frame.size.height
        rowFrame.origin.y += rowFrame.size.height

        let tableHeaderRowView = bundle.loadNibNamed("DetailsTableHeaderRow", owner: self, options: nil)?[0] as! DetailsTableHeaderRow
        tableHeaderRowView.valueTypeNameLabel.text = localisedString(key: "sip_value", bundle: bundle)
        rowFrame.size.height = tableHeaderRowView.frame.height
        tableHeaderRowView.frame = rowFrame
        detailsTableView.addSubview(tableHeaderRowView)
        rowFrame.origin.y += tableHeaderRowView.frame.size.height
        
        
        for calculationRow in sipCalculations{
            let rowView = bundle.loadNibNamed("CalculationDetailsTableRowView", owner: self, options: nil)?[0] as! CalculationDetailsTableRowView
            rowView.setCalculationData(calculation: calculationRow)
            rowFrame.size.height = rowView.frame.height
            rowView.frame = rowFrame
            detailsTableView.addSubview(rowView)
            rowFrame.origin.y += rowView.frame.size.height
        }
        
        detailsTableView.frame.size.height = rowFrame.origin.y
        return detailsTableView
    }
    
    func createHighlightsTable(frame:CGRect, bundle:Bundle, sipOutput: SIPOutput) -> UIView{
        let highlightsTableView = UIView(frame: frame)
        var rowFrame:CGRect = CGRect(x: 0, y: 0, width: frame.size.width, height: 0)
        let titleLabel = labelWithText(frame: rowFrame, message: NSLocalizedString("calculation_highilights", tableName: nil, bundle: bundle, value: "", comment: ""), backgroundColor: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 13))
        titleLabel.edgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        titleLabel.frame.size.height += 14
        highlightsTableView.addSubview(titleLabel)
        rowFrame.size.height = titleLabel.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        let firstrowView = highlightRowView(bundle: bundle, rowFrame: rowFrame, firstColumnText: localisedString(key: "sip_period", bundle: bundle), secondColumnText: sipOutput.investmentPeriod)
        highlightsTableView.addSubview(firstrowView)
        rowFrame.size.height = firstrowView.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        let secondrowView = highlightRowView(bundle: bundle, rowFrame: rowFrame, firstColumnText: localisedString(key: "sip_amount", bundle: bundle), secondColumnText: "\(currencyUnicode)\(getFormattedIntegerText(number: sipOutput.investAmount))")
        highlightsTableView.addSubview(secondrowView)
        rowFrame.size.height = secondrowView.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        let thirdRowView = highlightRowView(bundle: bundle, rowFrame: rowFrame, firstColumnText: localisedString(key: "total_investment", bundle: bundle), secondColumnText: "\(currencyUnicode)\(getFormattedIntegerText(number: sipOutput.investTotal))")
        highlightsTableView.addSubview(thirdRowView)
        rowFrame.size.height = thirdRowView.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        let schemeMarketValue = getTwoDecimalRoundedValue(number: sipOutput.calculations.last?.fundValue)
        let fourthRowView = highlightRowView(bundle: bundle, rowFrame: rowFrame, firstColumnText: localisedString(key: "scheme_market_value", bundle: bundle), secondColumnText: "\(currencyUnicode)\(getFormattedNumberText(number: schemeMarketValue))")
        fourthRowView.secondColumn.font = UIFont.boldSystemFont(ofSize: 10)
        highlightsTableView.addSubview(fourthRowView)
        rowFrame.size.height = fourthRowView.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        let schemeReturns = getTwoDecimalRoundedValue(number: sipOutput.annualIRR)
        let fifthRowView = highlightRowView(bundle: bundle, rowFrame: rowFrame, firstColumnText: localisedString(key: "scheme_returns", bundle: bundle), secondColumnText: "\(schemeReturns)%")
        highlightsTableView.addSubview(fifthRowView)
        rowFrame.size.height = fifthRowView.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        let benchmarkValue = getTwoDecimalRoundedValue(number: sipOutput.calculations.last?.indexFundValue)
        let sixthRowView = highlightRowView(bundle: bundle, rowFrame: rowFrame, firstColumnText: localisedString(key: "benchmark_value", bundle: bundle), secondColumnText: "\(currencyUnicode)\(getFormattedNumberText(number: benchmarkValue))")
        sixthRowView.secondColumn.font = UIFont.boldSystemFont(ofSize: 10)
        highlightsTableView.addSubview(sixthRowView)
        rowFrame.size.height = sixthRowView.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        let benchmarkReturns = getTwoDecimalRoundedValue(number: sipOutput.indexAnnualIRR)
        let seventhRowView = highlightRowView(bundle: bundle, rowFrame: rowFrame, firstColumnText: localisedString(key: "benchmark_returns", bundle: bundle), secondColumnText: "\(benchmarkReturns)%")
        highlightsTableView.addSubview(seventhRowView)
        rowFrame.size.height = seventhRowView.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        highlightsTableView.frame.size.height = rowFrame.origin.y
        return highlightsTableView
    }
    
}
