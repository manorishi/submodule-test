//
//  BaseHomeScreenTableViewCell.swift
//  smartsell
//
//  Created by kunal singh on 12/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

class BaseHomeScreenTableViewCell: UITableViewCell{
    
    
    func postNotification(type: AnyObject, subtype: AnyObject?, data: AnyObject){
        let userInfoData:Dictionary<String , AnyObject> = ["type": type, "subtype": subtype ?? "" as AnyObject, "data": data]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstants.TABLE_VIEW_SELECTION_NOTIFICATION), object: nil, userInfo: userInfoData)
    }
}
