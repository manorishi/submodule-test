//
//  PdfPresenter.swift
//  pdf
//
//  Created by Anurag Dake on 20/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

/**
 PdfPresenter handles UI for PdfViewController such as accessing pdf url from AssetDownloaderService, display share controller
 */
class PdfPresenter{
    
    weak var pdfViewController: PdfViewController!
    var pdfInteractor: PdfInteractor!
    
    init(pdfViewController: PdfViewController) {
        self.pdfViewController = pdfViewController
        pdfInteractor = PdfInteractor()
    }
    
    /**
     Show share controller.
     */

    func pdfFullUrl(pdfFileName: String) -> URL?{
        return AssetDownloaderService.sharedInstance.corePdfDownloader.retrievePdf(filename: pdfFileName)
    }
    
    /**
     Show share controller.
     */
    func showShareActivityController(shareUrl: URL) {
        let activityViewController = UIActivityViewController(activityItems: [shareUrl], applicationActivities: [])
        activityViewController.excludedActivityTypes = [.assignToContact]
        pdfViewController.present(activityViewController, animated: true)
        updateShareCount()
    }
    
    /**
     Handle pdf share count
     */
    func updateShareCount(){
        pdfInteractor.incrementPdfShareCount {[weak self] (responseStatus, responseData) in
            DispatchQueue.main.async {
                switch responseStatus{
                case .success:
                    if let shareCount: Int = responseData?["pdfs_shared"] as? Int{
                        self?.pdfInteractor.updatePdfShareCount(count: shareCount)
                        self?.pdfInteractor.deletePendingShareCount()
                        self?.sendShareCountUpdateNotification()
                    }
                case .error:
                    self?.pdfInteractor.updatePdfsToShareCount()
                    self?.sendShareCountUpdateNotification()
                    
                case .forbidden: break
                default: break
                }
            }
        }
    }
    
    /**
     Send notification to inform share count update
     */
    private func sendShareCountUpdateNotification(){
        NotificationCenter.default.post(name: AppNotificationConstants.SHARE_COUNT_UPDATE_NOTIFICATION, object: nil)
    }
}
