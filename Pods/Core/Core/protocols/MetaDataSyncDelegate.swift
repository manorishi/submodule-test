//
//  CoreDataSyncDelegate.swift
//  Core
//
//  Created by kunal singh on 22/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 The delegate of a MetaDataSyncer helps to get status of data operations. If any error occur during data operation then pass error title and error message and 'isStatus ' is false.
 */

import Foundation

public protocol MetaDataSyncDelegate {
    func metaDataSyncDone(isStatus:Bool, isForbidden:Bool, errorTitle:String?, errorMessage:String?)
}

