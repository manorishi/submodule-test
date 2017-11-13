//
//  ReturnAndRatioPresenter.swift
//  mfadvisor
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core
import CoreData

/**
 ReturnAndRatioPresenter handle UI logic for ReturnAndRatioViewController to generate pages
 */
class ReturnAndRatioPresenter: ReturnAndComapreBasePresenter {
    
    weak var returnAndRatioViewController:ReturnAndRatioViewController!
    var returnAndRatioInteractor:ReturnAndRatioInteractor!
    
    init(returnAndRatioViewController:ReturnAndRatioViewController) {
        self.returnAndRatioViewController = returnAndRatioViewController
        self.returnAndRatioInteractor = ReturnAndRatioInteractor()
    }
    
    func getFundData(fundId:String, managedObjectContext: NSManagedObjectContext) -> MetaFundData? {
        return returnAndRatioInteractor.fundData(fundId: fundId, managedObjectContext: managedObjectContext)
    }
    
    func getFundDataLive(fundId:String, managedObjectContext: NSManagedObjectContext) -> MetaFundDataLive? {
        return returnAndRatioInteractor.fundDataLive(fundId: fundId, managedObjectContext: managedObjectContext)
    }
    
    func addSIPReturnTable(pageView:UIView, frame:CGRect, fundDataLive:MetaFundDataLive, bundle: Bundle, fundName:String) -> CGRect {
        var rowFrame = frame
        if shouldShowReturnYearsTable(selectedYears: returnAndRatioViewController.selectedYears) {
            let originX:CGFloat = 8
            let rowDefaultHeight:CGFloat = 45
            let noOfColumn = numberOfColumnForRetunsTable(selectedYears: returnAndRatioViewController.selectedYears)
            let titleRow = getReturnTableFirstRow(frame: rowFrame, noOfColumn: noOfColumn, fundDataLive: fundDataLive, bundle: bundle, rowData: getSIPReturnTableFirstRowData(date: (fundDataLive.as_on_date_sip as Date?) ?? Date()))
            titleRow.updateColumnWidth(numberOfColumn: noOfColumn, visibleColumns: (first: true, second: returnAndRatioViewController.selectedYears.first, third: returnAndRatioViewController.selectedYears.third, fourth: returnAndRatioViewController.selectedYears.fifth))
            titleRow.updateRowHeight(height: titleRow.getMaxHeight())
            pageView.addSubview(titleRow)
            
            rowFrame = CGRect(x: originX, y: titleRow.frame.origin.y + titleRow.frame.size.height, width: titleRow.frame.size.width, height: rowDefaultHeight)
            let secondRow = getReturnTableSecondRow(frame: rowFrame, noOfColumn: noOfColumn, fundName: fundName, bundle: bundle, data: (fundDataLive.sip_return1_year, fundDataLive.sip_return3_year, fundDataLive.sip_return5_year))
            pageView.addSubview(secondRow)
            
            rowFrame = CGRect(x: originX, y: secondRow.frame.origin.y + secondRow.frame.size.height, width: titleRow.frame.size.width, height: rowDefaultHeight)
            let thirdRow = getReturnTableThirdRow(frame: rowFrame, noOfColumn: noOfColumn, fundId: fundDataLive.fund_id!, bundle: bundle, data: (fundDataLive.sip_benchmark1_year_return, fundDataLive.sip_benchmark3_year_return, fundDataLive.sip_benchmark5_year_return))
            pageView.addSubview(thirdRow)
            rowFrame = CGRect(x: originX, y: thirdRow.frame.origin.y + thirdRow.frame.height + 8, width: pageView.frame.size.width - (2 * originX), height: 0)
        }
        return rowFrame
    }
    
    func createSecondPage(frame:CGRect,fundData:MetaFundData, fundDataLive:MetaFundDataLive, fundName:String) -> UIView {
        let pageView = UIView()
        pageView.backgroundColor = UIColor.white
        pageView.frame = frame
        
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else {
            return pageView
        }
        let originX:CGFloat = 8
        var viewFrame = CGRect(x: originX, y: 16, width: frame.size.width - 2 * originX, height: 0)
        
        viewFrame = addSIPReturnTable(pageView: pageView, frame: viewFrame, fundDataLive: fundDataLive, bundle: bundle, fundName: fundName)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let keyParameter = labelWithText(frame: viewFrame, message: "Key parameters as on \(dateFormatter.string(from: (fundDataLive.as_on_date_parameters as Date?) ?? Date()))", backgroundColor: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR), textColor: UIColor.white)
        keyParameter.edgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        keyParameter.frame.size.height += 10
        
        pageView.addSubview(keyParameter)
        
        viewFrame = CGRect(x: originX, y: keyParameter.frame.origin.y + keyParameter.frame.size.height , width: frame.size.width - 2 * originX, height: 35)
        let expenseView = expenseRatioView(frame: viewFrame, fundDataLive: fundDataLive, bundle: bundle)
        pageView.addSubview(expenseView)
        
        viewFrame = CGRect(x: originX, y: viewFrame.origin.y + viewFrame.size.height , width: frame.size.width - 2 * originX, height: 45)
        let exitLoad = exitLoadView(frame: viewFrame, fundData: fundData, bundle: bundle)
        pageView.addSubview(exitLoad)
        
        viewFrame = CGRect(x: originX + exitLoad.firstColumnWidth.constant, y: exitLoad.frame.origin.y + exitLoad.frame.size.height, width: exitLoad.secondColumnWidth.constant, height: 45)
        let keyRatiosTitleView = keyRatiosTitle(frame: viewFrame, fundData: fundData, bundle: bundle)
        pageView.addSubview(keyRatiosTitleView)
        
        viewFrame = CGRect(x: originX + exitLoad.firstColumnWidth.constant, y: keyRatiosTitleView.frame.origin.y + keyRatiosTitleView.frame.size.height, width: exitLoad.secondColumnWidth.constant, height: 45)
        let keyRatioValueView = keyRatioValue(frame: viewFrame, fundData: fundData, fundDataLive: fundDataLive, bundle: bundle)
        pageView.addSubview(keyRatioValueView)
        
        viewFrame = CGRect(x: originX, y: keyRatiosTitleView.frame.origin.y, width: exitLoad.firstColumnWidth.constant, height: 45)
        
        let keyRatio = keyRatioView(frame: viewFrame, bundle: bundle)
        keyRatio.updateRowHeight(height: keyRatiosTitleView.frame.size.height + keyRatioValueView.frame.size.height)
        
        pageView.addSubview(keyRatio)
        viewFrame.size.height = keyRatio.frame.origin.y + keyRatio.frame.height + 8
        if frame.height < viewFrame.height {
            pageView.frame.size.height = viewFrame.height
        }

        return pageView
    }
    
    func createThirdPage(frame:CGRect,fundData:MetaFundData) -> UIView {
        let pageView = UIView()
        pageView.backgroundColor = UIColor.white
        pageView.frame = frame
        
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else {
            return pageView
        }
        let originX:CGFloat = 8
        var viewFrame = CGRect(x: originX, y: 16, width: frame.size.width - 2 * originX, height: 0)
       
        let riskometer = riskometerView(frame: viewFrame, fundData: fundData, bundle: bundle)
        pageView.addSubview(riskometer)
        
        viewFrame = CGRect(x: originX, y: riskometer.frame.origin.y + riskometer.frame.height + 8, width: pageView.frame.size.width - (2 * originX), height: 0)
        let disclaimerLabel = labelWithText(frame: viewFrame, message: fundData.disclaimer1 ?? "", backgroundColor: UIColor.clear, textColor: UIColor.gray, font: UIFont.systemFont(ofSize: 11))
        pageView.addSubview(disclaimerLabel)
        
        viewFrame = CGRect(x: originX, y: disclaimerLabel.frame.origin.y + disclaimerLabel.frame.height + 8, width: pageView.frame.size.width - (2 * originX), height: 0)
        let productLabelDisclaimer = labelWithText(frame: viewFrame, message: fundData.product_label_disclaimer ?? "", backgroundColor: UIColor.clear, textColor: UIColor.gray, font: UIFont.systemFont(ofSize: 10))
        pageView.addSubview(productLabelDisclaimer)
        
        viewFrame.size.height = productLabelDisclaimer.frame.origin.y + productLabelDisclaimer.frame.height + 8
        if frame.height < viewFrame.height {
            pageView.frame.size.height = viewFrame.height
        }
        
        return pageView
    }
    
    func riskometerView(frame:CGRect, fundData:MetaFundData, bundle:Bundle) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        var viewframe = CGRect(x: 0, y: 0, width: frame.size.width, height: 0)
        let topImage = UIImageView(image: UIImage(named: fundData.riskometer ?? "", in: bundle, compatibleWith: nil))
        topImage.frame.origin = CGPoint.zero
        topImage.frame.size.width = frame.size.width * 0.4
        topImage.frame.size.height = topImage.frame.size.width * 3 / 4
        view.addSubview(topImage)
        
        viewframe = CGRect(x: topImage.frame.origin.x + topImage.frame.size.width, y: topImage.frame.origin.y, width: frame.size.width * 0.6, height: 0)
        let productLabel = labelWithText(frame: viewframe, message: fundData.product_label ?? "", backgroundColor: UIColor.clear, textColor: UIColor.black)
        productLabel.text = nil
        productLabel.edgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        productLabel.font = UIFont.systemFont(ofSize: 10)
        productLabel.attributedText = htmlFromString(htmlText: fundData.product_label ?? "", fontColor: productLabel.textColor, font: productLabel.font)
        productLabel.sizeToFit()
        let rowHeight = productLabel.frame.size.height
        view.addSubview(productLabel)
        
        view.frame.size.height = topImage.frame.size.height > rowHeight ? topImage.frame.size.height : rowHeight
        return view
    }
    
    func keyRatioView(frame:CGRect, bundle:Bundle) -> TableRowView {
        let rowView = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        rowView.frame = frame
        rowView.updateColumnWidth(first: 1.0, second: 0, third: 0, fourth: 0)
        let rowData = TableRowData(firstColumn: NSLocalizedString("KEY_RATIOS", tableName: nil, bundle: bundle, value: "", comment: ""),
                                   secondColumn: "",
                                   thirdColumn: "",
                                   fourthColumn: "")
        setColumnData(rowView: rowView, rowData: rowData)
        return rowView
    }
    
    func keyRatioValue(frame:CGRect, fundData:MetaFundData, fundDataLive:MetaFundDataLive, bundle:Bundle) -> TableRowView {
        let rowView = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        rowView.frame = frame
        rowView.updateColumnWidth(first: 0.33, second: 0.33, third: 0.34, fourth: 0)
        rowView.firstColumn.textAlignment = .center
        let fundType = FundType(rawValue: fundData.fund_type1?.lowercased() ?? "")
        
        let rowData = TableRowData()
        if fundType == .equity {
            rowData.firstColumn = getStringFromFloat(data: fundDataLive.beta)
            rowData.secondColumn = getStringFromFloat(data: fundDataLive.fund_sharpe)
            rowData.thirdColumn = getStringFromFloat(data: fundDataLive.alpha)
        }
        else {
            rowData.firstColumn = getStringFromFloat(data: fundDataLive.fund_ytm)
            rowData.secondColumn = getStringFromFloat(data: Float(fundDataLive.fund_modified_duration))
            rowData.thirdColumn = getStringFromFloat(data: fundDataLive.fund_avg_maturity)
        }
        setColumnData(rowView: rowView, rowData: rowData)
        let height = rowView.getMaxHeight()
        rowView.updateRowHeight(height: height)
        return rowView
        
    }
    
    func keyRatiosTitle(frame:CGRect, fundData:MetaFundData, bundle:Bundle) -> TableRowView {
        let rowView = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        rowView.frame = frame
        rowView.updateColumnWidth(first: 0.33, second: 0.33, third: 0.34, fourth: 0)
        rowView.firstColumn.textAlignment = .center
        rowView.rowBackgroundColor(color: MFColors.GRAY_COLOR)
        rowView.rowTextColor(color: UIColor.white)
        rowView.addBorder(borderWidth: 0.5, borderColor: UIColor.white)
        let rowData = TableRowData(firstColumn: fundData.key_ratio_label1 ?? "",
                                   secondColumn: fundData.key_ratio_label2 ?? "",
                                   thirdColumn: fundData.key_ratio_label3 ?? "",
                                   fourthColumn: "")
        setColumnData(rowView: rowView, rowData: rowData)
        let height = rowView.getMaxHeight()
        rowView.updateRowHeight(height: height)
        return rowView
    }
    
    func expenseRatioView(frame:CGRect, fundDataLive:MetaFundDataLive, bundle:Bundle) -> TableRowView {
        let rowView = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        rowView.frame = frame
        
        let rowData = TableRowData(firstColumn: NSLocalizedString("EXPENSE_RATIO", tableName: nil, bundle: bundle, value: "", comment: ""),
                                   secondColumn: "\(fundDataLive.expense_ratio)%",
                                   thirdColumn: "",
                                   fourthColumn: "")
        setColumnData(rowView: rowView, rowData: rowData)
        rowView.updateColumnWidth(first: 0.3, second: 0.7, third: 0, fourth: 0)
        rowView.firstColumn.font = UIFont.systemFont(ofSize: 13)
        rowView.secondColumn.edgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        rowView.secondColumn.font = UIFont.systemFont(ofSize: 13)
        rowView.secondColumn.textAlignment = .left
        rowView.updateRowHeight(height: 35)
        return rowView
    }
    
    func exitLoadView(frame:CGRect, fundData:MetaFundData, bundle:Bundle) -> TableRowView {
        let rowView = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        rowView.frame = frame
        
        let rowData = TableRowData(firstColumn: NSLocalizedString("EXIT_LOAD", tableName: nil, bundle: bundle, value: "", comment: ""),
                                   secondColumn: "",
                                   thirdColumn: "",
                                   fourthColumn: "")
        setColumnData(rowView: rowView, rowData: rowData)
        rowView.updateColumnWidth(first: 0.3, second: 0.7, third: 0, fourth: 0)
        rowView.secondColumn.edgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        rowView.secondColumn.font = UIFont.systemFont(ofSize: 13)
        rowView.secondColumn.attributedText = htmlFromString(htmlText: fundData.exit_load ?? "", fontColor: UIColor.black, font: rowView.secondColumn.font)
        var rowHeight = rowView.secondColumn.attributedText?.heightWithConstrainedWidth(rowView.secondColumnWidth.constant - (rowView.secondColumn.edgeInsets.left + rowView.secondColumn.edgeInsets.right), font: rowView.secondColumn.font) ?? 55
        rowHeight = rowHeight <= 39 ? 55 : rowHeight + 16
        rowView.updateRowHeight(height: rowHeight)
        return rowView
    }
    
    func addReturnsTableInView(pageView:UIView, frame:CGRect, fundDataLive:MetaFundDataLive, bundle: Bundle, fundName:String) -> CGRect{
        var rowFrame = frame
        let originX:CGFloat = 8
        let rowDefaultHeight:CGFloat = 45
        if shouldShowReturnYearsTable(selectedYears: returnAndRatioViewController.selectedYears) {
            let noOfColumn = numberOfColumnForRetunsTable(selectedYears: returnAndRatioViewController.selectedYears)
            let titleRow = getReturnTableFirstRow(frame: rowFrame, noOfColumn: noOfColumn, fundDataLive: fundDataLive, bundle: bundle, rowData: getReturnTableFirstRowData(date: (fundDataLive.as_on_date as Date?) ?? Date()))
            titleRow.updateColumnWidth(numberOfColumn: noOfColumn, visibleColumns: (first: true, second: returnAndRatioViewController.selectedYears.first, third: returnAndRatioViewController.selectedYears.third, fourth: returnAndRatioViewController.selectedYears.fifth))
            titleRow.updateRowHeight(height: titleRow.getMaxHeight())
            pageView.addSubview(titleRow)
            
            rowFrame = CGRect(x: originX, y: titleRow.frame.origin.y + titleRow.frame.size.height, width: titleRow.frame.size.width, height: rowDefaultHeight)
            let secondRow = getReturnTableSecondRow(frame: rowFrame, noOfColumn: noOfColumn, fundName: fundName, bundle: bundle, data: (fundDataLive.return1_year, fundDataLive.return3_year, fundDataLive.return5_year))
            pageView.addSubview(secondRow)
            
            rowFrame = CGRect(x: originX, y: secondRow.frame.origin.y + secondRow.frame.size.height, width: titleRow.frame.size.width, height: rowDefaultHeight)
            let thirdRow = getReturnTableThirdRow(frame: rowFrame, noOfColumn: noOfColumn, fundId: fundDataLive.fund_id!, bundle: bundle, data: (fundDataLive.benchmark1_year_return, fundDataLive.benchmark3_year_return, fundDataLive.benchmark5_year_return))
            pageView.addSubview(thirdRow)
            rowFrame = CGRect(x: originX, y: thirdRow.frame.origin.y + thirdRow.frame.height + 8, width: pageView.frame.size.width - (2 * originX), height: 0)
        }
        if shouldShowReturnMonthsTable(selectedYears: returnAndRatioViewController.selectedYears) {
            let noOfColumn = numberOfColumnForMonthRetunsTable(selectedYears: returnAndRatioViewController.selectedYears)
            let titleRow = getReturnTableFirstRow(frame: rowFrame, noOfColumn: noOfColumn, fundDataLive: fundDataLive, bundle: bundle, rowData: getReturnTableFirstRowMonthsData(date: (fundDataLive.as_on_date as Date?) ?? Date()))
            titleRow.updateColumnWidth(numberOfColumn: noOfColumn, visibleColumns: (first: true, second: returnAndRatioViewController.selectedYears.threeMonth, third: returnAndRatioViewController.selectedYears.sixMonth, fourth: false))
            titleRow.updateRowHeight(height: titleRow.getMaxHeight())
            pageView.addSubview(titleRow)
            
            rowFrame = CGRect(x: originX, y: titleRow.frame.origin.y + titleRow.frame.size.height, width: titleRow.frame.size.width, height: rowDefaultHeight)
            let secondRow = getReturnTableMonthSecondRow(frame: rowFrame, noOfColumn: noOfColumn, fundName: fundName, fundDataLive: fundDataLive, bundle: bundle)
            pageView.addSubview(secondRow)
            
            rowFrame = CGRect(x: originX, y: secondRow.frame.origin.y + secondRow.frame.size.height, width: titleRow.frame.size.width, height: rowDefaultHeight)
            let thirdRow = getReturnTableMonthsThirdRow(frame: rowFrame, noOfColumn: noOfColumn, fundDataLive: fundDataLive, fundId: fundDataLive.fund_id! , bundle: bundle)
            pageView.addSubview(thirdRow)
        }
        
        return rowFrame
    }
    
    func createFirstPage(frame:CGRect, fundData:MetaFundData, fundDataLive:MetaFundDataLive,fundName:String, fundId:String) -> UIView {
        
        let pageView = UIView()
        pageView.backgroundColor = UIColor.white
        pageView.frame = frame
        
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else {
            return pageView
        }
        let topImage = topImageView(parentFrame: pageView.frame,bundle: bundle, image: fundData.top_image1 ?? "")
        pageView.addSubview(topImage)
        
        let fundInfo = fundInfoView(frame: CGRect(x:0, y: topImage.frame.size.height, width: pageView.frame.size.width, height: 60) , title: NSLocalizedString("PERFORMANCE_SNAPSHOT", tableName: nil, bundle: bundle, value: "", comment: ""), fundName: fundName)
        
        pageView.addSubview(fundInfo)
        let originX:CGFloat = 8
        let rowDefaultHeight:CGFloat = 45
        
        var rowFrame = CGRect(x: originX, y: fundInfo.frame.origin.y + fundInfo.frame.size.height + 8, width: pageView.frame.size.width - (2 * originX), height: rowDefaultHeight)
        
        rowFrame = addReturnsTableInView(pageView: pageView, frame: rowFrame, fundDataLive: fundDataLive, bundle: bundle, fundName: fundName)
        var labelFrame = CGRect(x: originX, y: rowFrame.origin.y + rowFrame.size.height + 2, width: pageView.frame.size.width - (2 * originX), height: 0)
        let disclaimerLabel = labelWithText(frame: labelFrame, message: fundData.disclaimer1 ?? "", backgroundColor: UIColor.clear, textColor: UIColor.gray, font: UIFont.systemFont(ofSize: 11))
        pageView.addSubview(disclaimerLabel)
        
        labelFrame = CGRect(x: 0, y: disclaimerLabel.frame.origin.y + disclaimerLabel.frame.size.height + 4, width: pageView.frame.size.width , height: 0)
        
        let inceptionLabel = labelWithText(frame: labelFrame, message: getReturnInceptionLabelText(fundDataLive: fundDataLive), backgroundColor: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR), textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 13))
        inceptionLabel.frame.size.height += 25
        inceptionLabel.textAlignment = .center
        pageView.addSubview(inceptionLabel)
        
        let pageHeight = inceptionLabel.frame.origin.y + inceptionLabel.frame.size.height
        if pageHeight >= frame.size.height {
            pageView.frame.size.height = pageHeight
        }
        else {
            inceptionLabel.frame.origin.y = frame.size.height - inceptionLabel.frame.size.height
        }
        return pageView
    }
    
    func getReturnInceptionLabelText(fundDataLive:MetaFundDataLive) -> String{
        let fundInceptionDate = returnAndRatioInteractor.fundInceptionDateHaving(fundId: fundDataLive.fund_id!, managedObjectContext: returnAndRatioViewController.managedObjectContext!) ?? NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let inceptionLabelString = "Returns since fund launch on \(dateFormatter.string(from: fundInceptionDate as Date)): \(getStringFromFloat(data: fundDataLive.return_since_inception))\nNAV as on \(dateFormatter.string(from: (fundDataLive.as_on_date_performance as Date?) ?? Date())): \(getStringFromFloat(data: fundDataLive.nav))"
        return inceptionLabelString
    }
    
    func getReturnTableSecondRow(frame:CGRect, noOfColumn:Int, fundName:String, bundle:Bundle, data:(firstRow:Float?, secondRow:Float?, thirdRow:Float?)) -> TableRowView {
        let secondRow = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        secondRow.frame = frame
        secondRow.updateColumnWidth(numberOfColumn: noOfColumn, visibleColumns: (first: true, second: returnAndRatioViewController.selectedYears.first, third: returnAndRatioViewController.selectedYears.third, fourth: returnAndRatioViewController.selectedYears.fifth))
        secondRow.rowTextColor(color: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR))
        let rowData = TableRowData(firstColumn: fundName, secondColumn: getStringFromFloat(data: data.firstRow), thirdColumn: getStringFromFloat(data: data.secondRow), fourthColumn: getStringFromFloat(data: data.thirdRow))
        setColumnData(rowView: secondRow, rowData: rowData)
        
        return secondRow
    }
    
    func getReturnTableMonthSecondRow(frame:CGRect, noOfColumn:Int, fundName:String, fundDataLive:MetaFundDataLive, bundle:Bundle) -> TableRowView {
        let secondRow = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        secondRow.frame = frame
        secondRow.updateColumnWidth(numberOfColumn: noOfColumn, visibleColumns: (first: true, second: returnAndRatioViewController.selectedYears.threeMonth, third: returnAndRatioViewController.selectedYears.sixMonth, fourth: false))
        secondRow.rowTextColor(color: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR))
        let rowData = TableRowData(firstColumn: fundName, secondColumn: getStringFromFloat(data: fundDataLive.return3_months), thirdColumn: getStringFromFloat(data: fundDataLive.return6_months), fourthColumn: "")
        setColumnData(rowView: secondRow, rowData: rowData)
        return secondRow
    }
    
    func getReturnTableMonthsThirdRow(frame:CGRect, noOfColumn:Int, fundDataLive:MetaFundDataLive, fundId:String, bundle:Bundle) -> TableRowView {
        let thirdRow = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        thirdRow.frame = frame
        thirdRow.updateColumnWidth(numberOfColumn: noOfColumn, visibleColumns: (first: true, second: returnAndRatioViewController.selectedYears.threeMonth, third: returnAndRatioViewController.selectedYears.sixMonth, fourth: false))
        
        let benchmarkName = returnAndRatioInteractor.fundBenchmarkOneHaving(fundId: fundId, managedObjectContext: returnAndRatioViewController.managedObjectContext!)
        let rowData = TableRowData(firstColumn: "Benchmark - \(benchmarkName ?? "")", secondColumn: getStringFromFloat(data: fundDataLive.benchmark3_months_return), thirdColumn: getStringFromFloat(data: fundDataLive.benchmark6_months_return), fourthColumn: "")
        setColumnData(rowView: thirdRow, rowData: rowData)
        return thirdRow
    }
    
    func getReturnTableThirdRow(frame:CGRect, noOfColumn:Int, fundId:String, bundle:Bundle, data:(firstRow:Float?, secondRow:Float?, thirdRow:Float?)) -> TableRowView{
        let thirdRow = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        thirdRow.frame = frame
        thirdRow.updateColumnWidth(numberOfColumn: noOfColumn, visibleColumns: (first: true, second: returnAndRatioViewController.selectedYears.first, third: returnAndRatioViewController.selectedYears.third, fourth: returnAndRatioViewController.selectedYears.fifth))
        
        let benchmarkName = returnAndRatioInteractor.fundBenchmarkOneHaving(fundId: fundId, managedObjectContext: returnAndRatioViewController.managedObjectContext!)
        let rowData = TableRowData(firstColumn: "Benchmark - \(benchmarkName ?? "")", secondColumn: getStringFromFloat(data: data.firstRow), thirdColumn: getStringFromFloat(data: data.secondRow), fourthColumn: getStringFromFloat(data: data.thirdRow))
        setColumnData(rowView: thirdRow, rowData: rowData)
        
        return thirdRow
    }
    
    func seperatorView(frame:CGRect) -> UIView{
        let seperatorView = UIView(frame: frame)
        seperatorView.backgroundColor = UIColor.lightGray
        return seperatorView
    }
    
}
