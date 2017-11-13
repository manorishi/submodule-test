//
//  QuizBaseViewController.swift
//  quiz
//
//  Created by Sunil Sharma on 9/11/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit
import Core

public class QuizBaseViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onError(errorStatus: ResponseStatus, errorTitle: String, errorMessage: String) {
        if errorStatus == .forbidden {
            sendForbiddenNotification()
        } else {
            UIAlertView.init(title: errorTitle, message: errorMessage, delegate: nil, cancelButtonTitle: "ok".localized).show()
        }
    }
    
    func sendForbiddenNotification() {
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: AppNotificationConstants.QUIZ_FORBBIDDEN_NOTIFICATION, object: nil)
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
