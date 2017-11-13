//
//  OTPPresenter.swift
//  smartsell
//
//  Created by Apple on 04/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core
import Firebase

/**
 Used to configure OTP screen and call OTPInteractor method to verify OTP and resend OTP.
 */
class OTPPresenter: OTPProtocol {
    
    weak var otpViewController: OTPViewController!
    var otpInteractor: OTPInteractor!
    
    init(otpViewController: OTPViewController) {
        self.otpViewController = otpViewController
        otpInteractor = OTPInteractor()
    }
    
    /**
     Call otpInteractor method to verify otp code.
     */
    func otpVerification(otpCode: String, mobileNo: String) {
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        let loadingController = alertViewHelper.loadingAlertViewController(title: "Checking...", message: "\n\n")
        otpViewController.present(loadingController, animated: true, completion: nil)
        otpInteractor.otpVerification(otpCode: otpCode, mobileNo: mobileNo, completionHandler: {[weak self] (status,userData,errorTitle,errorMsg) in
            DispatchQueue.main.async {
                self?.otpViewController.dismiss(animated: false, completion: {
                    if status {
                        self?.gotoController(userData: userData)
                    }
                    else{
                        self?.otpViewController.showErrorMessage(errorTitle: errorTitle, errorMsg: errorMsg)
                    }
                })
            }
        })
    }
    
    /**
     Redirect to Registration or HomeScreen controller based on registration status.
     */
    func gotoController(userData:UserData?) {
        if userData?.registrationStatus == true {
            let initialViewController = otpViewController.storyboard?.instantiateViewController(withIdentifier: LICConfiguration.HOMESCREEN_TABBAR_CONTROLLER) as! UITabBarController
            if let homeNC = initialViewController.viewControllers?.first as? UINavigationController,let homeVC = homeNC.viewControllers.first as? HomeScreenViewController {
                homeVC.isFromRegistration = true
            }
            
            UIApplication.shared.delegate?.window??.rootViewController = initialViewController
            UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        }
        else {
            if let nextViewController = self.otpViewController.storyboard?.instantiateViewController(withIdentifier: LICConfiguration.REGISTRATION_CONTROLLER) as? RegistrationViewController {
                nextViewController.userData = userData
                self.otpViewController.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
        PushNotificationService().updateFCMOnServer(completionHandler: nil)
    }
    
    /**
     Call OTPInteractor method to resend otp code.
     */
    func resendOTPButtonPress(mobileNo:String) {
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        let loadingController = alertViewHelper.loadingAlertViewController(title: "Checking...", message: "\n\n")
        otpViewController.present(loadingController, animated: true, completion: nil)
        otpInteractor.verifyMobileNumber(mobileNumber: mobileNo) {[weak self] (status,errorTitle,errorMsg) in
            DispatchQueue.main.async {
                self?.otpViewController.dismiss(animated: false, completion: {
                    if status {
                        self?.otpViewController.showOTPSuccessMsg()
                    }
                    else {
                        self?.otpViewController.showErrorMessage(errorTitle: errorTitle, errorMsg: errorMsg)
                    }
                })
            }
        }
    }
    
    func mobileTextfield(mobileNumber: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return ValidationUtils.mobileTextfield(mobileNumber: mobileNumber, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    func otpTextfield(otp: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return ValidationUtils.otpTextfield(otp: otp, shouldChangeCharactersIn: range, replacementString: string)
    }
    
}
