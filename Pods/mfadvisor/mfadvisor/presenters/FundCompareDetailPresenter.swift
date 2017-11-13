//
//  FundCompareDetailPresenter.swift
//  mfadvisor
//
//  Created by Apple on 12/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core
import CoreData

/**
 FundCompareDetailPresenter handle UI logic for FundCompareDetailViewController to generate fund compare pages and related views
 */
class FundCompareDetailPresenter: ReturnAndComapreBasePresenter {
    
    weak var fundCompareDetailViewController:FundCompareDetailViewController!
    var fundCompareDetailInteractor:FundCompareDetailInteractor!
    var metaFundMasterData:MetaFundMaster? = nil
    var otherFundDataMasterArray:[MetaOtherFundMaster] = []
    
    init(fundCompareDetailViewController:FundCompareDetailViewController) {
        self.fundCompareDetailViewController = fundCompareDetailViewController
        self.fundCompareDetailInteractor = FundCompareDetailInteractor()
    }
    
    func otherFundDataDictionary() -> [String:MetaOtherFundData]{
        let otherFundDataArray = fundCompareDetailInteractor.otherFundsDataHaving(fundIds: Array(fundCompareDetailViewController.otherFundsSelected.keys), managedObjectContext: fundCompareDetailViewController.managedObjectContext!)
        var otherFundDataDict:[String:MetaOtherFundData] = [:]
        for otherFundData in otherFundDataArray{
            otherFundDataDict[otherFundData.other_fund_id ?? ""] = otherFundData
        }
        return otherFundDataDict
    }
    
    func createFundComparePage(frame:CGRect,fundName:String,fundId:String, otherFundDataMasterArray:[MetaOtherFundMaster], managedObjectContext:NSManagedObjectContext) -> UIView {
        let pageView = UIView()
        pageView.backgroundColor = UIColor.white
        pageView.frame = frame
        let fundDataLive = fundCompareDetailInteractor.fundDataLive(fundId: fundId, managedObjectContext: managedObjectContext) ?? MetaFundDataLive()
        let otherFundDataDict = otherFundDataDictionary()
        metaFundMasterData = fundCompareDetailInteractor.metaFundMasterData(fundId: fundId, managedObjectContext: managedObjectContext)
        self.otherFundDataMasterArray = otherFundDataMasterArray
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else {
            return pageView
        }
        let topImage = topImageView(parentFrame: pageView.frame,bundle: bundle, image: "comparison_top")
        pageView.addSubview(topImage)
        
        let fundInfo = fundInfoView(frame: CGRect(x:0, y: topImage.frame.size.height, width: pageView.frame.size.width, height: 60) , title: NSLocalizedString("FUND_COMPARISON", tableName: nil, bundle: bundle, value: "", comment: ""), fundName: fundName)
        pageView.addSubview(fundInfo)
        
        let originX:CGFloat = 8
        var viewFrame = CGRect(x: originX, y: fundInfo.frame.origin.y + fundInfo.frame.size.height + 8, width: frame.size.width - 2 * originX , height: 0)
        let returnTableView = createReturnsTableView(frame: viewFrame, fundDataLive: fundDataLive, bundle: bundle, fundName: fundName, otherFundDataDict: otherFundDataDict)
        pageView.addSubview(returnTableView)
        
        viewFrame = CGRect(x: originX, y: returnTableView.frame.origin.y + returnTableView.frame.size.height + 10, width: frame.size.width - 2 * originX , height: 0)
        let fundData = fundCompareDetailInteractor.fundData(fundId: fundId, managedObjectContext: managedObjectContext) ?? MetaFundData()
        let ratioBetaView = createRatioBetaTable(frame: viewFrame, bundle: bundle, fundDataLive: fundDataLive, fundData: fundData, fundName: fundName, otherFundDataDict: otherFundDataDict)
        pageView.addSubview(ratioBetaView)
        viewFrame.size.height = ratioBetaView.frame.size.height
        
        viewFrame.origin.y += viewFrame.size.height + 10
        let exitLoadView = createExitLoadTable(frame: viewFrame, bundle: bundle, fundData: fundData, fundName: fundName, otherFundDataDict: otherFundDataDict)
        pageView.addSubview(exitLoadView)
        viewFrame.size.height = exitLoadView.frame.size.height
        
        viewFrame.origin.y += viewFrame.size.height + 10
        let expenseRatioView = createExpenseRatioTable(frame: viewFrame, bundle: bundle, fundDataLive: fundDataLive, fundName: fundName, otherFundDataDict: otherFundDataDict)
        pageView.addSubview(expenseRatioView)
        viewFrame.size.height = expenseRatioView.frame.size.height
        
        viewFrame.origin.y += viewFrame.size.height + 2
        let keyRatioLabel = createKeyRatiosDateView(frame: viewFrame, bundle: bundle, date: fundDataLive.as_on_date_parameters as Date? ?? Date())
        pageView.addSubview(keyRatioLabel)
        viewFrame.size.height = keyRatioLabel.frame.size.height
        
        viewFrame.origin.y += viewFrame.size.height + 6
        let pointFrame = CGRect(x: pageView.frame.origin.x, y: viewFrame.origin.y, width: pageView.frame.size.width, height: 0)
        let pointsToNoteView = createPointsToNoteView(frame: pointFrame, bundle: bundle, fundData: fundData)
        pageView.addSubview(pointsToNoteView)
        viewFrame.size.height = pointsToNoteView.frame.size.height
        
        viewFrame.origin.y += viewFrame.size.height + 4
        let disclaimerLabel = labelWithText(frame: viewFrame, message: fundData.disclaimer1 ?? "", backgroundColor: UIColor.clear, textColor: UIColor.gray, font: UIFont.systemFont(ofSize: 11))
        pageView.addSubview(disclaimerLabel)
        viewFrame.size.height = disclaimerLabel.frame.size.height
        
        pageView.frame.size.height = viewFrame.origin.y + viewFrame.size.height + 8
        return pageView
    }
    
    func createPointsToNoteView(frame:CGRect, bundle:Bundle, fundData:MetaFundData) -> UIView {
        let pointsToNoteView = UIView(frame: frame)
        var rowFrame:CGRect = CGRect(x: 8, y: 0, width: frame.size.width - 16, height: 0)
        let titleLabel = labelWithText(frame: rowFrame, message: NSLocalizedString("POINTS_TO_NOTE", tableName: nil, bundle: bundle, value: "", comment: ""), backgroundColor: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 15))
        titleLabel.edgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        titleLabel.frame.size.height += 14
        pointsToNoteView.addSubview(titleLabel)
        
        let pointsDataArray = pointsToNoteData(fundData: fundData)
        rowFrame.origin.y += titleLabel.frame.size.height + 10
        rowFrame.size.width = frame.size.width
        rowFrame.origin.x = 0
        for data in pointsDataArray {
            let view = bundle.loadNibNamed("FundAnswerTableViewCell", owner: self, options: nil)?[0] as! FundAnswerTableViewCell
            view.frame = rowFrame
            view.bottomLineView.isHidden = true
            view.backgroundColor = UIColor.white
            view.containerView.backgroundColor = UIColor.white
            view.setData(answerData: data, bundle: bundle, isCollapsed: false)
            var height = data.answer.heightWithConstrainedWidth(frame.size.width - 78, font: UIFont.systemFont(ofSize: 13))
            view.labelTopMarginConstraint.constant = 0
            height = height <= 32 ? 32 : height
            view.frame.size.height = height
            view.updateConstraints()
            view.setNeedsLayout()
            pointsToNoteView.addSubview(view)
            rowFrame.origin.y += (height + 10)
        }
        
        pointsToNoteView.frame.size.height = rowFrame.origin.y + 4
        return pointsToNoteView
    }
    
    func createExpenseRatioTable(frame:CGRect, bundle:Bundle, fundDataLive: MetaFundDataLive, fundName:String, otherFundDataDict:[String:MetaOtherFundData]) -> UIView {
        let expenseRatioView = UIView(frame: frame)
        var rowFrame:CGRect = CGRect(x: 0, y: 0, width: frame.size.width, height: 0)
        let titleLabel = labelWithText(frame: rowFrame, message: NSLocalizedString("EXPENSE_RATIO", tableName: nil, bundle: bundle, value: "", comment: ""), backgroundColor: MFColors.GRAY_COLOR, textColor: UIColor.white, font: UIFont.systemFont(ofSize: 15))
        titleLabel.edgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        titleLabel.frame.size.height += 14
        expenseRatioView.addSubview(titleLabel)
        rowFrame.size.height = titleLabel.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        let fundrowView = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        fundrowView.frame = rowFrame
        fundrowView.updateColumnWidth(first: 0.7, second: 0.3, third: 0, fourth: 0)
        fundrowView.rowTextColor(color: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR))
        fundrowView.firstColumn.textColor = UIColor.white
        fundrowView.firstColumn.backgroundColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
        fundrowView.firstColumn.layer.borderWidth = 0
        setColumnData(rowView: fundrowView, rowData: TableRowData(firstColumn: fundName, secondColumn: "\(getStringFromFloat(data: fundDataLive.expense_ratio))%", thirdColumn: "", fourthColumn: ""))
        fundrowView.updateRowHeight(height: fundrowView.getMaxHeight())
        expenseRatioView.addSubview(fundrowView)
        rowFrame.size.height = fundrowView.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        addSnapshotDataToView(rowView: fundrowView, snapshotMsg: metaFundMasterData?.fund_snapshot ?? "")
        
        //Add Other fund Expense ratio data
        for (key, value) in fundCompareDetailViewController.otherFundsSelected{
            if let otherFundData = otherFundDataDict[key] {
                let rowView = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
                rowView.frame = rowFrame
                rowView.updateColumnWidth(first: 0.7, second: 0.3, third: 0, fourth: 0)
                rowView.firstColumn.textColor = UIColor.white
                rowView.firstColumn.layer.borderColor = UIColor.white.cgColor
                rowView.firstColumn.backgroundColor = MFColors.GRAY_COLOR
                setColumnData(rowView: rowView, rowData: TableRowData(firstColumn: value, secondColumn: "\(getStringFromFloat(data: otherFundData.expense_ratio))%", thirdColumn: "", fourthColumn: ""))
                rowView.updateRowHeight(height: rowView.getMaxHeight())
                expenseRatioView.addSubview(rowView)
                
                rowFrame.size.height = rowView.frame.size.height
                rowFrame.origin.y += rowFrame.size.height
                if let otherFundMasterData = otherFundDataMasterArray.filter({$0.other_fund_id! == otherFundData.other_fund_id!}).first {
                    addSnapshotDataToView(rowView: rowView, snapshotMsg: otherFundMasterData.fund_snapshot ?? "")
                }
            }
        }
        
        expenseRatioView.frame.size.height = rowFrame.origin.y
        return expenseRatioView
    }
    
    func pointsToNoteData(fundData:MetaFundData) -> [AnswerData] {
        var pointsDataArray:[AnswerData] = []
        let fontSize:CGFloat = 13
        var data:AnswerData? = nil
        if let message = fundData.compare_point1, message.isEmpty == false  {
            data = AnswerData(icon: fundData.compare_icon1 ?? "", answer: htmlFromString(htmlText: message, fontColor: UIColor.black, font: UIFont.systemFont(ofSize: fontSize)) ?? NSAttributedString())
            pointsDataArray.append(data!)
        }
        if let message = fundData.compare_point2, message.isEmpty == false  {
            data = AnswerData(icon: fundData.compare_icon2 ?? "", answer: htmlFromString(htmlText: message, fontColor: UIColor.black, font: UIFont.systemFont(ofSize: fontSize)) ?? NSAttributedString())
            pointsDataArray.append(data!)
        }
        
        if let message = fundData.compare_point3, message.isEmpty == false {
            data = AnswerData(icon: fundData.compare_icon3 ?? "", answer: htmlFromString(htmlText: message, fontColor: UIColor.black, font: UIFont.systemFont(ofSize: fontSize)) ?? NSAttributedString())
            pointsDataArray.append(data!)
        }
        
        return pointsDataArray
    }
    
    func createKeyRatiosDateView(frame:CGRect, bundle:Bundle, date:Date) ->  CustomLabel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let keyRatioLabel = labelWithText(frame: frame, message: "Key Ratios as on \(dateFormatter.string(from: date))", backgroundColor: UIColor.clear, textColor: UIColor.gray)
        keyRatioLabel.frame.size.height += 10
        return keyRatioLabel
    }
    
    func createExitLoadTable(frame:CGRect, bundle:Bundle, fundData:MetaFundData, fundName:String, otherFundDataDict:[String:MetaOtherFundData]) -> UIView {
        let exitLoadView = UIView(frame: frame)
        var rowFrame:CGRect = CGRect(x: 0, y: 0, width: frame.size.width, height: 0)
        let titleLabel = labelWithText(frame: rowFrame, message: NSLocalizedString("EXIT_LOAD", tableName: nil, bundle: bundle, value: "", comment: ""), backgroundColor: MFColors.GRAY_COLOR, textColor: UIColor.white, font: UIFont.systemFont(ofSize: 15))
        titleLabel.edgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        titleLabel.frame.size.height += 14
        exitLoadView.addSubview(titleLabel)
        rowFrame.size.height = titleLabel.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        let fundrowView = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        fundrowView.frame = rowFrame
        addSnapshotDataToView(rowView: fundrowView, snapshotMsg: metaFundMasterData?.fund_snapshot ?? "")
        fundrowView.updateColumnWidth(first: 0.4, second: 0.6, third: 0, fourth: 0)
        fundrowView.rowTextColor(color: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR))
        fundrowView.firstColumn.textColor = UIColor.white
        fundrowView.firstColumn.backgroundColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
        fundrowView.firstColumn.layer.borderWidth = 0
        setExitLoadDataAndUpdateHeight(rowView: fundrowView, fundName: fundName, exitLoadString: fundData.exit_load ?? "")
        exitLoadView.addSubview(fundrowView)
        exitLoadView.bringSubview(toFront: fundrowView)
        rowFrame.size.height = fundrowView.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        //Add Other fund returns data
        for (key, value) in fundCompareDetailViewController.otherFundsSelected{
            if let otherFundData = otherFundDataDict[key] {
                let rowView = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
                rowView.frame = rowFrame
                rowView.updateColumnWidth(first: 0.4, second: 0.6, third: 0, fourth: 0)
                rowView.firstColumn.textColor = UIColor.white
                rowView.firstColumn.layer.borderColor = UIColor.white.cgColor
                rowView.firstColumn.backgroundColor = MFColors.GRAY_COLOR
                setExitLoadDataAndUpdateHeight(rowView: rowView, fundName: value, exitLoadString: otherFundData.exit_load ?? "")
                exitLoadView.addSubview(rowView)
                rowFrame.size.height = rowView.frame.size.height
                rowFrame.origin.y += rowFrame.size.height
                if let otherFundMasterData = otherFundDataMasterArray.filter({$0.other_fund_id! == otherFundData.other_fund_id!}).first {
                    addSnapshotDataToView(rowView: rowView, snapshotMsg: otherFundMasterData.fund_snapshot ?? "")
                }
            }
        }
        
        exitLoadView.frame.size.height = rowFrame.origin.y
        return exitLoadView
    }
    
    func setExitLoadDataAndUpdateHeight(rowView:TableRowView,fundName:String, exitLoadString:String) {
        
        rowView.firstColumn.text = fundName
        
        rowView.secondColumn.edgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        rowView.secondColumn.font = UIFont.systemFont(ofSize: 13)
        rowView.secondColumn.attributedText = htmlFromString(htmlText: exitLoadString, fontColor: UIColor.black, font: rowView.secondColumn.font)
        var secondColHieght = rowView.secondColumn.attributedText?.heightWithConstrainedWidth(rowView.secondColumnWidth.constant - (rowView.secondColumn.edgeInsets.left + rowView.secondColumn.edgeInsets.right), font: rowView.secondColumn.font) ?? 45
        secondColHieght = secondColHieght <= 29 ? 45 : secondColHieght + 16
        
        let firstColHeight = rowView.viewHeight(message: rowView.firstColumn.text ?? "", width: rowView.firstColumnWidth.constant - (rowView.firstColumn.edgeInsets.left + rowView.firstColumn.edgeInsets.right), font: rowView.firstColumn.font)
        
        rowView.updateRowHeight(height: firstColHeight > secondColHieght ? firstColHeight : secondColHieght)
    }
    
    func createRatioBetaTable(frame:CGRect, bundle:Bundle, fundDataLive: MetaFundDataLive, fundData:MetaFundData, fundName:String, otherFundDataDict:[String:MetaOtherFundData]) -> UIView {
        let fundType = FundType(rawValue: fundData.fund_type1?.lowercased() ?? "")
        if fundType == .debt {
            return createKeyRatiosTableView(frame: frame, bundle: bundle, fundDataLive: fundDataLive, fundData: fundData, fundName: fundName, otherFundDataDict: otherFundDataDict)
        } else {
            return createBetaTableView(frame: frame, bundle: bundle, fundDataLive: fundDataLive, fundName: fundName, otherFundDataDict: otherFundDataDict)
        }
    }
    
    func createBetaTableView(frame:CGRect, bundle:Bundle, fundDataLive: MetaFundDataLive, fundName:String, otherFundDataDict:[String:MetaOtherFundData]) -> UIView {
        let betaView = UIView(frame: frame)
        var rowFrame:CGRect = CGRect(x: 0, y: 0, width: frame.size.width, height: 0)
        let titleLabel = labelWithText(frame: rowFrame, message: NSLocalizedString("BETA", tableName: nil, bundle: bundle, value: "", comment: ""), backgroundColor: MFColors.GRAY_COLOR, textColor: UIColor.white, font: UIFont.systemFont(ofSize: 15))
        titleLabel.edgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        titleLabel.frame.size.height += 14
        betaView.addSubview(titleLabel)
        rowFrame.size.height = titleLabel.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        let fundrowView = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        fundrowView.frame = rowFrame
        fundrowView.updateColumnWidth(first: 0.7, second: 0.3, third: 0, fourth: 0)
        fundrowView.rowTextColor(color: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR))
        fundrowView.firstColumn.textColor = UIColor.white
        fundrowView.firstColumn.backgroundColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
        fundrowView.firstColumn.layer.borderWidth = 0
        setColumnData(rowView: fundrowView, rowData: TableRowData(firstColumn: fundName, secondColumn: getStringFromFloat(data: fundDataLive.beta), thirdColumn: "", fourthColumn: ""))
        fundrowView.updateRowHeight(height: fundrowView.getMaxHeight())
        betaView.addSubview(fundrowView)
        rowFrame.size.height = fundrowView.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        addSnapshotDataToView(rowView: fundrowView, snapshotMsg: metaFundMasterData?.fund_snapshot ?? "")
        
        //Add Other fund returns data
        for (key, value) in fundCompareDetailViewController.otherFundsSelected{
            if let otherFundData = otherFundDataDict[key] {
                let rowView = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
                rowView.frame = rowFrame
                rowView.updateColumnWidth(first: 0.7, second: 0.3, third: 0, fourth: 0)
                rowView.firstColumn.textColor = UIColor.white
                rowView.firstColumn.layer.borderColor = UIColor.white.cgColor
                rowView.firstColumn.backgroundColor = MFColors.GRAY_COLOR
                setColumnData(rowView: rowView, rowData: TableRowData(firstColumn: value, secondColumn: getStringFromFloat(data: otherFundData.beta), thirdColumn: "", fourthColumn: ""))
                rowView.updateRowHeight(height: rowView.getMaxHeight())
                betaView.addSubview(rowView)
                rowFrame.size.height = rowView.frame.size.height
                rowFrame.origin.y += rowFrame.size.height
                if let otherFundMasterData = otherFundDataMasterArray.filter({$0.other_fund_id! == otherFundData.other_fund_id!}).first {
                    addSnapshotDataToView(rowView: rowView, snapshotMsg: otherFundMasterData.fund_snapshot ?? "")
                }
            }
        }
        
        betaView.frame.size.height = rowFrame.origin.y
        return betaView
    }
    
    func createKeyRatiosTableView(frame:CGRect, bundle:Bundle, fundDataLive: MetaFundDataLive, fundData:MetaFundData, fundName:String, otherFundDataDict:[String:MetaOtherFundData]) -> UIView {
        let keyRatiosView = UIView(frame: frame)
        var rowFrame:CGRect = CGRect(x: 0, y: 0, width: frame.size.width, height: 0)
        let titleView = createKeyRatioTitleRow(frame: rowFrame, bundle: bundle, fundDataLive: fundDataLive, fundData: fundData)
        keyRatiosView.addSubview(titleView)
        rowFrame.size.height = titleView.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        
        let fundrowView = createReturnRowView(frame: rowFrame, noOfColumn: 4, bundle: bundle, visibleColumns: (true, true, true, true))
        fundrowView.rowTextColor(color: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR))
        fundrowView.firstColumn.textColor = UIColor.white
        fundrowView.firstColumn.backgroundColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
        setColumnData(rowView: fundrowView, rowData: getKeyRatiosData(fundName: fundName, fundDataLive: fundDataLive))
        fundrowView.firstColumn.layer.borderColor = UIColor.white.cgColor
        fundrowView.updateRowHeight(height: fundrowView.getMaxHeight())
        keyRatiosView.addSubview(fundrowView)
        rowFrame.size.height = fundrowView.frame.size.height
        rowFrame.origin.y += rowFrame.size.height
        addSnapshotDataToView(rowView: fundrowView, snapshotMsg: metaFundMasterData?.fund_snapshot ?? "")
        
        //Add Other fund returns data
        for (key, value) in fundCompareDetailViewController.otherFundsSelected{
            if let otherFundData = otherFundDataDict[key] {
                let rowView = createReturnRowView(frame: rowFrame, noOfColumn: 4, bundle: bundle, visibleColumns: (true, true, true, true))
                rowView.firstColumn.textColor = UIColor.white
                rowView.firstColumn.layer.borderColor = UIColor.white.cgColor
                rowView.firstColumn.backgroundColor = MFColors.GRAY_COLOR
                setColumnData(rowView: rowView, rowData: getOtherFundRatioData(fundName: value, otherFundData: otherFundData))
                rowView.updateRowHeight(height: rowView.getMaxHeight())
                keyRatiosView.addSubview(rowView)
                rowFrame.size.height = rowView.frame.size.height
                rowFrame.origin.y += rowFrame.size.height
                if let otherFundMasterData = otherFundDataMasterArray.filter({$0.other_fund_id! == otherFundData.other_fund_id!}).first {
                    addSnapshotDataToView(rowView: rowView, snapshotMsg: otherFundMasterData.fund_snapshot ?? "")
                }
            }
        }
        keyRatiosView.frame.size.height = rowFrame.origin.y
        return keyRatiosView
    }
    
    func getOtherFundRatioData(fundName:String, otherFundData:MetaOtherFundData) -> TableRowData {
        let rowData = TableRowData()
        rowData.firstColumn = fundName
        rowData.secondColumn = getStringFromFloat(data: otherFundData.fund_ytm)
        rowData.thirdColumn = getStringFromFloat(data: Float(otherFundData.fund_modified_duration))
        rowData.fourthColumn = getStringFromFloat(data: otherFundData.fund_avg_maturity)
        return rowData
    }
    
    func getKeyRatiosData(fundName:String, fundDataLive:MetaFundDataLive) -> TableRowData {
        let rowData = TableRowData()
        rowData.firstColumn = fundName
        rowData.secondColumn = getStringFromFloat(data: fundDataLive.fund_ytm)
        rowData.thirdColumn = getStringFromFloat(data: Float(fundDataLive.fund_modified_duration))
        rowData.fourthColumn = getStringFromFloat(data: fundDataLive.fund_avg_maturity)
        return rowData
    }
    
    func createKeyRatioTitleRow(frame:CGRect, bundle:Bundle, fundDataLive: MetaFundDataLive, fundData:MetaFundData) -> UIView {
        let titleRow = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        titleRow.frame = frame
        titleRow.updateColumnWidth(numberOfColumn: 4, visibleColumns: (first: true, second: true, third: true, fourth: true))
        titleRow.rowBackgroundColor(color: MFColors.GRAY_COLOR)
        titleRow.rowTextColor(color: UIColor.white)
        titleRow.addBorder(borderWidth: 0.5, borderColor: UIColor.white)
        titleRow.secondColumn.font = UIFont.systemFont(ofSize:titleRow.secondColumn.font.pointSize - 1)
        titleRow.thirdColumn.font = UIFont.systemFont(ofSize:titleRow.thirdColumn.font.pointSize - 1)
        titleRow.fourthColumn.font = UIFont.systemFont(ofSize:titleRow.fourthColumn.font.pointSize - 1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let rowData = TableRowData(firstColumn: "Key Ratios as on \(dateFormatter.string(from: (fundDataLive.as_on_date_parameters as Date?) ?? Date()))",
            secondColumn: fundData.key_ratio_label1 ?? "",
            thirdColumn: fundData.key_ratio_label2 ?? "",
            fourthColumn: fundData.key_ratio_label3 ?? "")
        setColumnData(rowView: titleRow, rowData: rowData)
        let height = titleRow.getMaxHeight()
        titleRow.updateRowHeight(height: height)
        return titleRow
    }
    
    func getTableFirstRowArray(rowFrame:CGRect, fundDataLive: MetaFundDataLive, bundle:Bundle) -> [(tableRow:TableRowView, noOfColumn:Int, isYearTable:Bool)] {
        var tableFirstRowArray:[(tableRow:TableRowView, noOfColumn:Int, isYearTable:Bool)] = []
        if shouldShowReturnYearsTable(selectedYears: fundCompareDetailViewController.selectedYears) {
            let noOfColumn = numberOfColumnForRetunsTable(selectedYears: fundCompareDetailViewController.selectedYears)
            let titleRow = getReturnTableFirstRow(frame: rowFrame, noOfColumn: noOfColumn, fundDataLive: fundDataLive, bundle: bundle, rowData: getReturnTableFirstRowData(date: (fundDataLive.as_on_date as Date?) ?? Date()))
            titleRow.updateColumnWidth(numberOfColumn: noOfColumn, visibleColumns: (first: true, second: fundCompareDetailViewController.selectedYears.first, third: fundCompareDetailViewController.selectedYears.third, fourth: fundCompareDetailViewController.selectedYears.fifth))
            tableFirstRowArray.append((tableRow: titleRow, noOfColumn: noOfColumn, isYearTable: true))
        }
        
        if shouldShowReturnMonthsTable(selectedYears: fundCompareDetailViewController.selectedYears) {
            let noOfColumn = numberOfColumnForMonthRetunsTable(selectedYears: fundCompareDetailViewController.selectedYears)
            let titleRow = getReturnTableFirstRow(frame: rowFrame, noOfColumn: noOfColumn, fundDataLive: fundDataLive, bundle: bundle, rowData: getReturnTableFirstRowMonthsData(date: (fundDataLive.as_on_date as Date?) ?? Date()))
            titleRow.updateColumnWidth(numberOfColumn: noOfColumn, visibleColumns: (first: true, second: fundCompareDetailViewController.selectedYears.threeMonth, third: fundCompareDetailViewController.selectedYears.sixMonth, fourth: false))
            tableFirstRowArray.append((tableRow: titleRow, noOfColumn: noOfColumn, isYearTable: false))
        }
        
        return tableFirstRowArray
    }
    
    func createReturnsTableView(frame:CGRect, fundDataLive: MetaFundDataLive, bundle:Bundle, fundName:String, otherFundDataDict:[String:MetaOtherFundData]) -> UIView {
        let returnView = UIView(frame: frame)
        var rowFrame:CGRect = CGRect(x: 0, y: 0, width: frame.size.width, height: 0)
        let tableFirstRowArray = getTableFirstRowArray(rowFrame: rowFrame, fundDataLive: fundDataLive, bundle: bundle)
        
        for (index, firstRowData) in tableFirstRowArray.enumerated() {
            let titleRow = firstRowData.tableRow
            
            if index != 0 {
                rowFrame.origin.y += 8
                titleRow.frame = CGRect(x: 0, y: rowFrame.origin.y, width: frame.size.width, height: 0)
            }
            titleRow.updateRowHeight(height: titleRow.getMaxHeight())
            returnView.addSubview(titleRow)
            rowFrame.size.height = titleRow.frame.size.height
            rowFrame.origin.y += rowFrame.size.height
            
            let rowView = createReturnRowView(frame: rowFrame, noOfColumn: firstRowData.noOfColumn, bundle: bundle, visibleColumns: getReturnTableColumnVisibility(isYearData: firstRowData.isYearTable))
            rowView.rowTextColor(color: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR))
            
            setColumnData(rowView: rowView, rowData: getFundReturnData(fundName: fundName, fundDataLive: fundDataLive, isYearData: firstRowData.isYearTable))
            rowView.updateRowHeight(height: rowView.getMaxHeight())
            returnView.addSubview(rowView)
            rowFrame.size.height = rowView.frame.size.height
            rowFrame.origin.y += rowFrame.size.height
            addSnapshotDataToView(rowView: rowView, snapshotMsg: metaFundMasterData?.fund_snapshot ?? "")
            
            //Add Other fund returns data
            for (key, value) in fundCompareDetailViewController.otherFundsSelected {
                if let otherFundData = otherFundDataDict[key] {
                    
                let rowView = createReturnRowView(frame: rowFrame, noOfColumn: firstRowData.noOfColumn, bundle: bundle, visibleColumns: getReturnTableColumnVisibility(isYearData: firstRowData.isYearTable))
                    setColumnData(rowView: rowView, rowData: getOtherFundReturnData(fundName: value, otherfundData: otherFundData, isYearData: firstRowData.isYearTable))
                    rowView.updateRowHeight(height: rowView.getMaxHeight())
                    returnView.addSubview(rowView)
                    rowFrame.size.height = rowView.frame.size.height
                    rowFrame.origin.y += rowFrame.size.height
                    if let otherFundMasterData = otherFundDataMasterArray.filter({$0.other_fund_id! == otherFundData.other_fund_id!}).first {
                        addSnapshotDataToView(rowView: rowView, snapshotMsg: otherFundMasterData.fund_snapshot ?? "")
                    }
                }
            }
            returnView.frame.size.height = rowFrame.origin.y
        }
        return returnView
    }
    
    func addSnapshotDataToView(rowView:TableRowView, snapshotMsg:String) {
        rowView.fundSnapshotMessage = snapshotMsg
        rowView.addSnapshotMessage()
    }
    
    func getReturnTableColumnVisibility(isYearData:Bool) -> (first:Bool, second:Bool, third:Bool, fourth:Bool){
        if isYearData {
            return (true,fundCompareDetailViewController.selectedYears.first, fundCompareDetailViewController.selectedYears.third, fundCompareDetailViewController.selectedYears.fifth)
        } else {
            return (true,fundCompareDetailViewController.selectedYears.threeMonth, fundCompareDetailViewController.selectedYears.sixMonth, false)
        }
    }
    
    func getOtherFundReturnData(fundName:String, otherfundData:MetaOtherFundData, isYearData:Bool) -> TableRowData {
        let rowData = TableRowData()
        rowData.firstColumn = fundName
        if isYearData {
            rowData.secondColumn = getStringFromFloat(data: otherfundData.return1_year)
            rowData.thirdColumn = getStringFromFloat(data: otherfundData.return3_year)
            rowData.fourthColumn = getStringFromFloat(data: otherfundData.return5_year)
        } else {
            rowData.secondColumn = getStringFromFloat(data: otherfundData.return3_months)
            rowData.thirdColumn = getStringFromFloat(data: otherfundData.return6_months)
            rowData.fourthColumn = ""
        }
        return rowData
    }
    
    func getFundReturnData(fundName:String, fundDataLive:MetaFundDataLive, isYearData:Bool) -> TableRowData {
        let rowData = TableRowData()
        rowData.firstColumn = fundName
        if isYearData {
            rowData.secondColumn = getStringFromFloat(data: fundDataLive.return1_year)
            rowData.thirdColumn = getStringFromFloat(data: fundDataLive.return3_year)
            rowData.fourthColumn = getStringFromFloat(data: fundDataLive.return5_year)
        } else {
            rowData.secondColumn = getStringFromFloat(data: fundDataLive.return3_months)
            rowData.thirdColumn = getStringFromFloat(data: fundDataLive.return6_months)
            rowData.fourthColumn = ""
        }
        return rowData
    }
    
    func createReturnRowView(frame:CGRect, noOfColumn:Int, bundle:Bundle, visibleColumns:(first:Bool, second:Bool, third:Bool, fourth:Bool)) -> TableRowView {
        let secondRow = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        secondRow.frame = frame
        secondRow.updateColumnWidth(numberOfColumn: noOfColumn, visibleColumns: (first: visibleColumns.first, second: visibleColumns.second, third: visibleColumns.third, fourth: visibleColumns.fourth))
        return secondRow
    }
}
