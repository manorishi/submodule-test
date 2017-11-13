//
//  PasswordPresenter.swift
//  smartsell
//
//  Created by Anurag Dake on 04/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

class PasswordPresenter: SmartSellBasePresenter {
    
    weak var passwordViewController: PasswordViewController!
    var passwordInteractor: PasswordInteractor!
    
    init(passwordViewController: PasswordViewController) {
        self.passwordViewController = passwordViewController
        passwordInteractor = PasswordInteractor()
    }
    
    func verifyUserPassword(userName: String?, password: String){
        guard userName != nil else {
            return
        }
        showLoadingController()
        passwordInteractor.verifyUserPassword(userName: userName!, password: password) { [weak self] (status, userData, errorTitle, errorMessage) in
            DispatchQueue.main.async {
                self?.passwordViewController.dismiss(animated: false, completion: {
                    if status{
                        print("Success")
                        self?.gotoHomeScreen(userData: userData)
                        
                    }else{
                        self?.showAlertMessage(title: errorTitle, message: errorMessage)
                    }
                })
            }
        }
    }
    
    func resendSecurityKey(userName: String?, email: String?, registeredStatus: Int?){
        guard userName != nil && email != nil else {
            return
        }
        showLoadingController()
        passwordInteractor.resend(userName: userName!) { [weak self] (status, errorTitle, message) in
            DispatchQueue.main.async {
                self?.passwordViewController.dismiss(animated: false, completion: {
                    if status{
                        self?.gotoSecurityVerificationScreen(userName: userName, email: email, registeredStatus: registeredStatus)
                    }else{
                        self?.showAlertMessage(title: errorTitle, message: message)
                    }
                })
            }
        }
    }
    
    func gotoSecurityVerificationScreen(userName: String?, email: String?, registeredStatus: Int?){
        guard let securityVerificationVC = self.passwordViewController.storyboard?.instantiateViewController(withIdentifier: "SecurityKeyVerificationViewController") as? SecurityKeyVerificationViewController else{
            return
        }
        securityVerificationVC.email = email
        securityVerificationVC.username = userName
        securityVerificationVC.registeredStatus = registeredStatus
        self.passwordViewController.navigationController?.pushViewController(securityVerificationVC, animated: true)
    }
    
    func gotoHomeScreen(userData: UserData?){
        guard let initialViewController = passwordViewController.storyboard?.instantiateViewController(withIdentifier: LICConfiguration.HOMESCREEN_TABBAR_CONTROLLER) as? UITabBarController else{
            return
        }
        if let homeNC = initialViewController.viewControllers?.first as? UINavigationController,let homeVC = homeNC.viewControllers.first as? HomeScreenViewController {
            homeVC.isFromRegistration = true
        }
        UIApplication.shared.delegate?.window??.rootViewController = initialViewController
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
    
    func showLoadingController(){
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        let loadingController = alertViewHelper.loadingAlertViewController(title: "Loading...", message: "\n\n")
        passwordViewController.present(loadingController, animated: true, completion: nil)
    }
    
}

