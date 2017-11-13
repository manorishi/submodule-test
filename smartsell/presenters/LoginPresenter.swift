//
//  LoginPresenter.swift
//  licsuperagent
//
//  Created by kunal singh on 12/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Foundation
import UIKit
import Core

/**
 LoginPresenter is used to congiure Login screen.
 */

class LoginPresenter: SmartSellBasePresenter, LoginProtocol, UIAlertViewCallbackProtocol {
    weak var loginViewController: LoginViewController!
    var loginInteractor: LoginInteractor!
    
    init(loginViewController: LoginViewController) {
        self.loginViewController = loginViewController
        loginInteractor = LoginInteractor()
    }
    
    /**
     Login view configuration.
     */
    func configView() {
        buttonState(button: loginViewController.continueButton, isEnabled: false)
    }
    
    /**
     Called when clicked on continue button in LoginViewController.
     */
    func clickedOnContinueButton(userName : String) {
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        let loadingController = alertViewHelper.loadingAlertViewController(title: "Loading...", message: "\n\n")
        loginViewController.present(loadingController, animated: true, completion: nil)
        loginInteractor.verifyUserName(userName: userName) {[weak self] (status, email, registeredStatus, errorTitle, errorMsg) in
            DispatchQueue.main.async {
                self?.loginViewController.dismiss(animated: false, completion: { 
                    if status{
                        if registeredStatus == 0{
                            guard let securityVerificationVC = self?.loginViewController.storyboard?.instantiateViewController(withIdentifier: "SecurityKeyVerificationViewController") as? SecurityKeyVerificationViewController else{
                                return
                            }
                            securityVerificationVC.email = email
                            securityVerificationVC.username = userName
                            securityVerificationVC.registeredStatus = registeredStatus
                            self?.loginViewController.navigationController?.pushViewController(securityVerificationVC, animated: true)
                        }else if registeredStatus == 1{
                            guard let passwordVC = self?.loginViewController.storyboard?.instantiateViewController(withIdentifier: "PasswordViewController") as? PasswordViewController else{
                                return
                            }
                            passwordVC.userName = userName
                            passwordVC.email = email
                            passwordVC.registeredStatus = registeredStatus
                            self?.loginViewController.navigationController?.pushViewController(passwordVC, animated: true)
                        }
                    }else {
                        self?.loginViewController.showErrorMessage(errorTitle: errorTitle, errorMsg: errorMsg)
                    }
                })
            
            }
        }
    }
    
    func shouldCharacterChange(mobileNumber: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return ValidationUtils.mobileTextfield(mobileNumber: mobileNumber, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    func isValidUsername(username: String) -> Bool{
        return username.characters.count >= 1
    }
}
