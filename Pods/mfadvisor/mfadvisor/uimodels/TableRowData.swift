//
//  TableRowData.swift
//  mfadvisor
//
//  Created by Apple on 10/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

/**
 TableRowData contains data for one row in table
 */
class TableRowData {

    var firstColumn:String?
    var secondColumn:String?
    var thirdColumn:String?
    var fourthColumn:String?
    
    init() {
        
    }
    
    init(firstColumn:String?, secondColumn:String?, thirdColumn:String?, fourthColumn:String?) {
        self.firstColumn = firstColumn
        self.secondColumn = secondColumn
        self.thirdColumn = thirdColumn
        self.fourthColumn = fourthColumn
    }
}
