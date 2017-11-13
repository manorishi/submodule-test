//
//  CreatePasswordPresenter.swift
//  smartsell
//
//  Created by Anurag Dake on 04/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Foundation
import Core

class CreatePasswordPresenter: SmartSellBasePresenter{
    
    weak var createPasswordViewController: CreatePasswordViewController!
    var createPasswordInteractor: CreatePasswordInteractor!
    
    init(createPasswordViewController: CreatePasswordViewController) {
        self.createPasswordViewController = createPasswordViewController
        createPasswordInteractor = CreatePasswordInteractor()
    }
    
    func updateUserPassword(userName: String?, securityKey: String?, password: String?, registeredStatus: Int?){
        guard userName != nil && securityKey != nil && password != nil else {
            return
        }
        showLoadingController()
        createPasswordInteractor.updateUserPassword(userName: userName!, securityKey: securityKey!, password: password!) {[weak self] (status, userData, errorTitle, errorMessage) in
            DispatchQueue.main.async {
                self?.createPasswordViewController.dismiss(animated: false, completion: { 
                    if status{
                        print("Success")
                        if registeredStatus == 1{
                            self?.gotoHomeScreenController()
                        }else{
                            guard let registrationVC = self?.createPasswordViewController.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController else{
                                return
                            }
                            registrationVC.userData = userData
                            self?.createPasswordViewController.navigationController?.pushViewController(registrationVC, animated: true)
                        }
                    }else{
                        self?.showAlertMessage(title: errorTitle, message: errorMessage)
                    }
                })
            }
        }
        
    }
    
    /**
     Redirect to home screen.
     */
    func gotoHomeScreenController() {
        let initialViewController = createPasswordViewController.storyboard?.instantiateViewController(withIdentifier: LICConfiguration.HOMESCREEN_TABBAR_CONTROLLER) as! UITabBarController
        if let homeNC = initialViewController.viewControllers?.first as? UINavigationController,let homeVC = homeNC.viewControllers.first as? HomeScreenViewController {
            homeVC.isFromRegistration = true
        }
        
        UIApplication.shared.delegate?.window??.rootViewController = initialViewController
    }
    
    func showLoadingController(){
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        let loadingController = alertViewHelper.loadingAlertViewController(title: "Loading...", message: "\n\n")
        createPasswordViewController.present(loadingController, animated: true, completion: nil)
    }
}
