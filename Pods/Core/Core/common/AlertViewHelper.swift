//
//  AlertViewHelper.swift
//  Core
//
//  Created by kunal singh on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 AlertViewHelper show alert view with loading indicator and message.
 */

import Foundation
import UIKit

public class AlertViewHelper {
    
    let alertViewCallbackProtocol: UIAlertViewCallbackProtocol?
    
    public init(alertViewCallbackProtocol: UIAlertViewCallbackProtocol?) {
        self.alertViewCallbackProtocol = alertViewCallbackProtocol
    }
    
    ///Simply show a alertview
    public func showAlertView(title: String, message: String, cancelButtonTitle: String = "OK"){
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
    }

    ///UIAlertController for loading view
    public func loadingAlertViewController(title: String, message: String) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.center = CGPoint(x: 130, y: 65)
        loadingIndicator.color = UIColor.black
        loadingIndicator.startAnimating();
        alertController.view.addSubview(loadingIndicator)
        return alertController
    }
    
    public func alertControllerWithProgressBarData(title: String, message: String, cancelText: String) -> (UIAlertController, UIProgressView, UILabel, UILabel){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let progressBar : UIProgressView = UIProgressView(progressViewStyle: .default)
        progressBar.setProgress(0, animated: true)
        progressBar.frame = CGRect(x: 10, y: 65, width: 230, height: 0)
        progressBar.center = CGPoint(x: 130, y: 65)
        alertController.view.addSubview(progressBar)
        
        let percentLabel = UILabel(frame: CGRect(x: progressBar.frame.origin.x, y: 70, width: 100, height: 21))
        percentLabel.text = "0%"
        percentLabel.font = percentLabel.font.withSize(14)
        alertController.view.addSubview(percentLabel)
        
        let downloadedCountLabel = UILabel(frame: CGRect(x: progressBar.frame.width + progressBar.frame.origin.x - 100, y: 70, width: 100, height: 21))
        downloadedCountLabel.textAlignment = .right
        downloadedCountLabel.text = "1/10"
        downloadedCountLabel.font = downloadedCountLabel.font.withSize(14)
        alertController.view.addSubview(downloadedCountLabel)
        
        let cancelAction = UIAlertAction(title: cancelText, style: .default) { (result : UIAlertAction) in
            self.alertViewCallbackProtocol?.cancelButtonPressed?()
        }
        alertController.addAction(cancelAction)
        
        return (alertController, progressBar, percentLabel, downloadedCountLabel)
    }
    
    
}

