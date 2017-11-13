//
//  TableRowView.swift
//  mfadvisor
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

/**
 TableRowView difines the row view with all operations to calculate width, height, text customisationand adjust size according to texts and required number of column data
 */
class TableRowView: UIView {

    @IBOutlet weak var firstColumn: CustomLabel!
    @IBOutlet weak var firstColumnWidth: NSLayoutConstraint!
    @IBOutlet weak var secondColumn: CustomLabel!
    @IBOutlet weak var secondColumnWidth: NSLayoutConstraint!
    @IBOutlet weak var fourthColumn: CustomLabel!
    @IBOutlet weak var fourthColumnWidth: NSLayoutConstraint!
    @IBOutlet weak var thirdColumn: CustomLabel!
    @IBOutlet weak var thirdColumnWidth: NSLayoutConstraint!
    
    @IBOutlet weak var secondColumnHeight: NSLayoutConstraint!
    @IBOutlet weak var fourthColumnHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdColumnHeight: NSLayoutConstraint!
    @IBOutlet weak var firstColumnHeight: NSLayoutConstraint!
    
    var fundSnapshotMessage:String? = nil
    
    func addSnapshotMessage() {
        firstColumn.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSnapshotMessage(sender:)))
        tapGesture.numberOfTapsRequired = 1
        firstColumn.addGestureRecognizer(tapGesture)
    }
    
    func showSnapshotMessage(sender:UIGestureRecognizer) {
        UIAlertView(title: firstColumn.text ?? "", message: fundSnapshotMessage ?? "", delegate: nil, cancelButtonTitle: "Ok").show()
    }
    
    func updateColumnWidth(first:CGFloat, second:CGFloat, third:CGFloat, fourth:CGFloat) {
        firstColumnWidth.constant = self.frame.size.width * first
        secondColumnWidth.constant = self.frame.size.width * second
        thirdColumnWidth.constant = self.frame.size.width * third
        fourthColumnWidth.constant = self.frame.size.width * fourth
        self.layoutIfNeeded()
        self.updateConstraints()
    }
    
    func getMaxHeight() -> CGFloat {
        var maxHeight:CGFloat = 0
        var height = viewHeight(message: firstColumn.text ?? "", width: firstColumnWidth.constant - (firstColumn.edgeInsets.left + firstColumn.edgeInsets.right), font: firstColumn.font)
        maxHeight = height > maxHeight ? height : maxHeight
        
        height = viewHeight(message: secondColumn.text ?? "", width: secondColumnWidth.constant - (secondColumn.edgeInsets.left + secondColumn.edgeInsets.right), font: firstColumn.font)
        maxHeight = height > maxHeight ? height : maxHeight
        
        height = viewHeight(message: thirdColumn.text ?? "", width: thirdColumnWidth.constant - (thirdColumn.edgeInsets.left + thirdColumn.edgeInsets.right), font: firstColumn.font)
        maxHeight = height > maxHeight ? height : maxHeight
        
        height = viewHeight(message: fourthColumn.text ?? "", width: fourthColumnWidth.constant - (fourthColumn.edgeInsets.left + fourthColumn.edgeInsets.right), font: firstColumn.font)
        maxHeight = height > maxHeight ? height : maxHeight
        
        return ceil(maxHeight)
    }
    
    func updateColumnWidth(numberOfColumn:Int,visibleColumns:(first:Bool, second:Bool, third:Bool, fourth:Bool)) {
        switch numberOfColumn {
        case 1:
            firstColumnWidth.constant = visibleColumns.first ? self.frame.size.width : 0
            secondColumnWidth.constant = 0
            thirdColumnWidth.constant = 0
            fourthColumnWidth.constant = 0
        case 2:
            firstColumnWidth.constant = self.frame.size.width * 0.7
            secondColumnWidth.constant = visibleColumns.second ? self.frame.size.width * 0.3 : 0
            thirdColumnWidth.constant = visibleColumns.third ? self.frame.size.width * 0.3 : 0
            fourthColumnWidth.constant = visibleColumns.fourth ? self.frame.size.width * 0.3 : 0
        case 3:
            firstColumnWidth.constant = self.frame.size.width * 0.6
            secondColumnWidth.constant = visibleColumns.second ? self.frame.size.width * 0.2 : 0
            thirdColumnWidth.constant = visibleColumns.third ? self.frame.size.width * 0.2 : 0
            fourthColumnWidth.constant = visibleColumns.fourth ? self.frame.size.width * 0.2 : 0
        case 4:
            firstColumnWidth.constant = self.frame.size.width * 0.4
            secondColumnWidth.constant = visibleColumns.second ? self.frame.size.width * 0.2 : 0
            thirdColumnWidth.constant = visibleColumns.third ? self.frame.size.width * 0.2 : 0
            fourthColumnWidth.constant = visibleColumns.fourth ? self.frame.size.width * 0.2 : 0
        default:
            break
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = true
        addBorder(borderWidth: 0.5, borderColor: UIColor.lightGray)
        rowTextColor(color: UIColor.black)
        rowBackgroundColor(color: UIColor.white)
        firstColumn.edgeInsets.left = 5
        firstColumn.edgeInsets.right = 5
    }
    
    func rowBackgroundColor(color:UIColor) {
        firstColumn.backgroundColor = color
        secondColumn.backgroundColor = color
        thirdColumn.backgroundColor = color
        fourthColumn.backgroundColor = color
    }
    
    func rowTextColor(color:UIColor) {
        firstColumn.textColor = color
        secondColumn.textColor = color
        thirdColumn.textColor = color
        fourthColumn.textColor = color
    }
    
    func updateTitleColumn(message:String) {
        firstColumn.text = message
        let height = viewHeight(message: message, width: firstColumnWidth.constant - (firstColumn.edgeInsets.right + firstColumn.edgeInsets.left), font: firstColumn.font)
        updateRowHeight(height: height)
    }
    
    func updateRowHeight(height:CGFloat) {
        firstColumnHeight.constant = height
        secondColumnHeight.constant = height
        thirdColumnHeight.constant = height
        fourthColumnHeight.constant = height
        self.frame.size.height = height
    }
    
    func viewHeight(message:String, width:CGFloat, font:UIFont) -> CGFloat{
        let height = message.heightWithConstrainedWidth(width, font: font)
        return height <= firstColumnHeight.constant - 16 ? firstColumnHeight.constant : height + 16
    }
    
    func addBorder(borderWidth:CGFloat, borderColor:UIColor) {
        firstColumn.layer.borderWidth = borderWidth
        firstColumn.layer.borderColor = borderColor.cgColor
        secondColumn.layer.borderWidth = borderWidth
        secondColumn.layer.borderColor = borderColor.cgColor
        thirdColumn.layer.borderWidth = borderWidth
        thirdColumn.layer.borderColor = borderColor.cgColor
        fourthColumn.layer.borderWidth = borderWidth
        fourthColumn.layer.borderColor = borderColor.cgColor
    }
    
}
