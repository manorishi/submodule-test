//
//  SalesPitchPresenter.swift
//  mfadvisor
//
//  Created by Apple on 06/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData

/**
 SalesPitchPresenter handle UI logic for SalesPitchViewController such as calculating heights for views
 */
class SalesPitchPresenter {
    
    weak var salesPitchViewController: SalesPitchViewController!
    var salesPitchInteractor: SalesPitchInteractor!
    
    init(salesPitchViewController: SalesPitchViewController) {
        self.salesPitchViewController = salesPitchViewController
        salesPitchInteractor = SalesPitchInteractor()
    }
    
    func getFundSalesPitchData(fundId:String, managedObjectContext: NSManagedObjectContext) -> [SalesPitchData]{
        return salesPitchInteractor.getFundsQuestionsData(fundId: fundId, managedObjectContext: managedObjectContext)
    }
    
    func fundNameFrom(fundId:String, managedObjectContext: NSManagedObjectContext) -> String? {
        return salesPitchInteractor.fundNameFrom(fundId: fundId, managedObjectContext: managedObjectContext)
    }
    
    /// Calculate and return image height for tableview cell. Maintain 16:9 ratio
    func answerImageHeight(imageName:String?, collapsed:Bool) -> CGFloat{
        if imageName != nil && !collapsed {
            return (((UIScreen.main.bounds.size.width - 16) * 9) / 16) + 0.5
        }
        else {
            return 0
        }
    }
    
    /// Calculate and return header or footer height for tableview cell.
    func answerHeaderFooterHeight(message:String?, collapsed:Bool) -> CGFloat{
        if message != nil && !collapsed {
            let height = message?.heightWithConstrainedWidth(UIScreen.main.bounds.size.width - 32, font: UIFont.systemFont(ofSize: 14)) ?? 22
            return height <= 22 ? 40 : height + 18
        }
        else {
            return 0
        }
    }
    
    /// Calculate and return answer height for tableview cell.
    func answerHeight(answerData:AnswerData?, collapsed:Bool) -> CGFloat {
        if answerData != nil && !collapsed {
            let height = answerData?.answer.heightWithConstrainedWidth(UIScreen.main.bounds.size.width - 78, font: UIFont.systemFont(ofSize: 15)) ?? 24
            return height <= 24 ? 60 : height + 36
        }
        else {
            return 0
        }
    }
    
    func questionHeight(question:String, collapsed:Bool,questionLabelWidth:CGFloat) -> CGFloat{
        var width = questionLabelWidth
        var fontSize:CGFloat = 16
        if !collapsed {
            width = questionLabelWidth + 40
            fontSize = 17
        }
        
        let height = question.heightWithConstrainedWidth(width, font: UIFont.systemFont(ofSize: fontSize))
        return height <= 21 ? 60 : height + 39
    }
    
    /// Get section for collapsible cell
    func getSectionIndex(row: NSInteger,dataArray:[SalesPitchData]) -> Int {
        let indices = getHeaderIndices(dataArray: dataArray)
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        
        return -1
    }
    
    /// Get index for rows under collapsible view
    func getRowIndex(row: NSInteger, dataArray:[SalesPitchData]) -> Int {
        var index = row
        let indices = getHeaderIndices(dataArray: dataArray)
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        
        return index
    }
    
    /// Get Indices for headers in tableview
    func getHeaderIndices(dataArray:[SalesPitchData]) -> [Int] {
        var index = 0
        var indices: [Int] = []
        
        for answers in dataArray {
            indices.append(index)
            index += answers.answerCount + 1
        }
        
        return indices
    }
}
