//
//  PdfInteractor.swift
//  pdf
//
//  Created by Anurag Dake on 20/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import Core

/**
 PdfInteractor makes api call to increment pdf share count and updated in keychain
 */
class PdfInteractor{
    
    /**
     Make api call to increment pdf share count
     */
    func incrementPdfShareCount(completionHandler:@escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void){
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: PdfUrlConstants.UPDATE_PDF_SHARE_COUNT_URL, params: nil, httpBody: ["pdfs_shared": pdfCountToIncrement() as AnyObject], completionHandler: completionHandler)
    }
    
    /**
     Update pdf share count in keychain
     */
    func updatePdfShareCount(count: Int){
        KeyChainService.sharedInstance.setValue(string: String(count), key: ConfigKeys.PDF_COUNT_KEY)
    }
    
    /**
     Update share count of pdfs which is not synced with server - pending share count
     */
    func updatePdfsToShareCount(){
        let count = pdfCountToIncrement()
        KeyChainService.sharedInstance.setValue(string: String(count), key: ConfigKeys.PDFS_SHARE_COUNT_TO_UPDATE_KEY)
    }
    
    /**
     Delete pending share count of pdfs once synced with server
     */
    func deletePendingShareCount(){
        KeyChainService.sharedInstance.setValue(string: String(0), key: ConfigKeys.PDFS_SHARE_COUNT_TO_UPDATE_KEY)
    }
    
    /**
     Get pdf share count to update with server including pending share count
     */
    private func pdfCountToIncrement() -> Int{
        let shareCountToUpdate = KeyChainService.sharedInstance.getValue(key: ConfigKeys.PDFS_SHARE_COUNT_TO_UPDATE_KEY)
        return ((Int(shareCountToUpdate ?? "0") ?? 0) + 1)
    }
}
