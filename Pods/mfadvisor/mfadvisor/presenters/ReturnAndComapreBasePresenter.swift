//
//  ReturnAndComapreBasePresenter.swift
//  mfadvisor
//
//  Created by Apple on 12/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

/**
 ReturnAndComapreBasePresenter returns, ratios and compare funds common methods to generate views
 */
class ReturnAndComapreBasePresenter: NSObject {

    func topImageView(parentFrame:CGRect, bundle:Bundle, image:String) -> TopImageView {
        let topImageView = bundle.loadNibNamed("TopImageView", owner: self, options: nil)?[0] as! TopImageView
        topImageView.frame = CGRect(x: 0, y: 0, width: parentFrame.size.width , height: (parentFrame.size.width * 9/16))
        topImageView.topImageView.image = UIImage(named: image, in: bundle, compatibleWith: nil) ?? UIImage()
        topImageView.titleLabel.isHidden = true
        topImageView.titleLabel.text = ""
        return topImageView
    }
    
    func fundInfoView(frame:CGRect, title:String, fundName:String) -> UIView {
        let view = UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height))
        view.backgroundColor = MFColors.GRAY_COLOR
        
        let titleLabel = UILabel(frame: CGRect(x: view.frame.origin.x + 10, y: 6, width: view.frame.size.width - 20, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.white
        titleLabel.text = title
        view.addSubview(titleLabel)
        
        let fundNameLabel = UILabel(frame: CGRect(x: view.frame.origin.x + 10, y: titleLabel.frame.origin.y + titleLabel.frame.size.height + 2, width: view.frame.size.width - 20, height: 30))
        fundNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        fundNameLabel.textColor = UIColor.white
        fundNameLabel.text = fundName
        view.addSubview(fundNameLabel)
        
        return view
    }
    
    func getReturnTableFirstRow(frame:CGRect, noOfColumn:Int,fundDataLive:MetaFundDataLive, bundle:Bundle, rowData:TableRowData) ->  TableRowView {
        let titleRow = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        titleRow.frame = frame
        titleRow.rowBackgroundColor(color: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR))
        titleRow.rowTextColor(color: UIColor.white)
        titleRow.addBorder(borderWidth: 0.5, borderColor: UIColor.white)
        let edgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        titleRow.firstColumn.edgeInsets = edgeInsets
        titleRow.secondColumn.edgeInsets = edgeInsets
        titleRow.thirdColumn.edgeInsets = edgeInsets
        titleRow.fourthColumn.edgeInsets = edgeInsets
        setColumnData(rowView: titleRow, rowData: rowData)
        return titleRow
    }
    
    func getSIPReturnTableFirstRowData(date:Date) -> TableRowData{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return TableRowData(firstColumn: "SIP Returns as on \(dateFormatter.string(from: date))",secondColumn: "1_YEAR".localized,thirdColumn: "3_YEAR".localized, fourthColumn: "5_YEAR".localized)
    }
    
    func getReturnTableFirstRowData(date:Date) -> TableRowData{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return TableRowData(firstColumn: "Returns in % as on \(dateFormatter.string(from: date))",secondColumn: "1_YEAR".localized,thirdColumn: "3_YEAR".localized, fourthColumn: "5_YEAR".localized)
    }
    
    func getReturnTableFirstRowMonthsData(date:Date) -> TableRowData{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return TableRowData(firstColumn: "Returns in % as on \(dateFormatter.string(from: date))",secondColumn: "3_MONTHS".localized,thirdColumn: "6_MONTHS".localized, fourthColumn: "")
    }
    
    func setColumnData(rowView:TableRowView, rowData:TableRowData) {
        rowView.updateTitleColumn(message: rowData.firstColumn ?? "")
        rowView.secondColumn.text = rowData.secondColumn ?? ""
        rowView.thirdColumn.text = rowData.thirdColumn ?? ""
        rowView.fourthColumn.text = rowData.fourthColumn ?? ""
    }
    
    func shouldShowReturnYearsTable(selectedYears:(threeMonth:Bool, sixMonth:Bool, first:Bool, third:Bool, fifth:Bool)) -> Bool {
        return (selectedYears.first ||
            selectedYears.third ||
            selectedYears.fifth)
    }
    
    func shouldShowReturnMonthsTable(selectedYears:(threeMonth:Bool, sixMonth:Bool, first:Bool, third:Bool, fifth:Bool)) -> Bool {
        return (selectedYears.threeMonth ||
            selectedYears.sixMonth)
    }
    
    func getStringFromFloat(data:Float?) -> String {
        if data == nil || data == 0.0{
            return "NA"
        }
        return String(describing: data!)
    }
    
    func labelWithText(frame:CGRect, message:String, backgroundColor:UIColor, textColor:UIColor, font:UIFont = UIFont.systemFont(ofSize: 14)) -> CustomLabel {
        let label = CustomLabel(frame: frame)
        label.numberOfLines = 0
        label.font = font
        label.backgroundColor = backgroundColor
        label.textColor = textColor
        label.text = message
        label.frame.size.height = message.heightWithConstrainedWidth(frame.size.width, font: label.font) + 4
        return label
    }
    
    func numberOfColumnForMonthRetunsTable(selectedYears:(threeMonth:Bool, sixMonth:Bool, first:Bool, third:Bool, fifth:Bool)) -> Int {
        var noOfColumn = 1
        if selectedYears.threeMonth {
            noOfColumn += 1
        }
        if selectedYears.sixMonth {
            noOfColumn += 1
        }
        return noOfColumn
    }
    
    func numberOfColumnForRetunsTable(selectedYears:(threeMonth:Bool, sixMonth:Bool, first:Bool, third:Bool, fifth:Bool)) -> Int {
        var noOfColumn = 1
        if selectedYears.first {
            noOfColumn += 1
        }
        if selectedYears.third {
            noOfColumn += 1
        }
        if selectedYears.fifth {
            noOfColumn += 1
        }
        return noOfColumn
    }
}
