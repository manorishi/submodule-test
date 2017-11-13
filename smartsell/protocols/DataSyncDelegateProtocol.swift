//
//  DataSyncDelegateProtocol.swift
//  smartsell
//
//  Created by kunal singh on 10/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

protocol DataSyncDelegateProtocol:class {
    func metaDataDownloadComplete()
    func dataSyncCompleteWithError(errorTitle: String?, errorMessage: String?)
    func dataSyncCompleteWithForbidden()
}
