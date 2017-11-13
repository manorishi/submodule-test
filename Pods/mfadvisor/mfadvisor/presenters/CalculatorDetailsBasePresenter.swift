//
//  CalculatorDetailsBasePresenter.swift
//  mfadvisor
//
//  Created by Anurag Dake on 12/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

class CalculatorDetailsBasePresenter: NSObject{
    
    let currencyUnicode = "\u{20B9}"
    
    func localisedString(key: String, bundle: Bundle) -> String{
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
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
    
    func setColumnData(rowView:TableRowView, rowData:TableRowData) {
        rowView.updateTitleColumn(message: rowData.firstColumn ?? "")
        rowView.secondColumn.text = rowData.secondColumn ?? ""
        rowView.thirdColumn.text = rowData.thirdColumn ?? ""
        rowView.fourthColumn.text = rowData.fourthColumn ?? ""
    }
    
    func seperatorView(frame: CGRect) -> UIView{
        let seperatorView = UIView(frame: frame)
        seperatorView.backgroundColor = UIColor.lightGray
        return seperatorView
    }

    func highlightRowView(bundle: Bundle, rowFrame: CGRect, firstColumnText: String, secondColumnText: String) -> TableRowView{
        let highlightRowView = bundle.loadNibNamed("TableRowView", owner: self, options: nil)?[0] as! TableRowView
        highlightRowView.frame = rowFrame
        highlightRowView.firstColumn.font = UIFont.systemFont(ofSize: 10)
        highlightRowView.secondColumn.font = UIFont.systemFont(ofSize: 10)
        highlightRowView.firstColumn.edgeInsets.left = 8
        highlightRowView.secondColumn.edgeInsets.left = 8
        highlightRowView.secondColumn.textAlignment = .left
        highlightRowView.updateColumnWidth(first: 0.6, second: 0.4, third: 0, fourth: 0)
        highlightRowView.rowTextColor(color: UIColor.black)
        setColumnData(rowView: highlightRowView, rowData: TableRowData(firstColumn: firstColumnText, secondColumn: secondColumnText, thirdColumn: "", fourthColumn: ""))
        highlightRowView.updateRowHeight(height: 30)
        return highlightRowView
    }
    
}
