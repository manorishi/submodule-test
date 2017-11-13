//
//  RegistrationPresenter.swift
//  smartsell
//
//  Created by Apple on 06/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

/**
 Used to configure Registeration screen and validate user input fileds.
 */

class RegistrationPresenter:SmartSellBasePresenter, RegistrationProtocol {
    
    weak var registrationViewController: RegistrationViewController!
    var registrationInteractor: RegistrationInteractor!
    private let PRIVACY_POLICY = "Privacy Policy"
    private let LICENSE_AGREEMENT = "License Agreement(EULA)"
    private let NAME_MIN_LENGTH = 3
    
    init(registrationViewController: RegistrationViewController) {
        self.registrationViewController = registrationViewController
        registrationInteractor = RegistrationInteractor()
    }

    /**
     Create bold and underlined attribute string.
     */
    func boldUnderLineString(string:String, attributedString:NSAttributedString?, range:NSRange,font:UIFont) -> NSAttributedString {
        let fontSize = font.pointSize
        let boldAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)),
                              NSForegroundColorAttributeName: UIColor.white]
        var attrString:NSMutableAttributedString? = nil
        if attributedString == nil {
            let nonboldAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(fontSize)),
                                  NSForegroundColorAttributeName: UIColor.white]
            attrString = NSMutableAttributedString(string: string)
            attrString?.setAttributes(nonboldAttributes, range: NSRange(location: 0, length: attrString?.length ?? 0 ))
        }
        else {
            attrString = NSMutableAttributedString(attributedString: attributedString!)
        }
        attrString?.setAttributes(boldAttributes, range: range)
        attrString?.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        var value = (string as NSString).substring(with: range)
        value = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        attrString?.addAttribute(NSLinkAttributeName, value: value, range: range)
        return attrString!
    }
    
    /**
     Show loading indicator and call interactor method to update user data on server.
     */
    func updateUserData(fullName:String?, designation:String?,location:String?) {
        if isRegistrationFormComplete(fullName: fullName, designation: designation, location: location) {
            let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
            let loadingController = alertViewHelper.loadingAlertViewController(title: "Updating...", message: "\n\n")
            registrationViewController.present(loadingController, animated: true, completion: nil)
            registrationInteractor.updateUserDetailsOnServer(name: fullName ?? "", designation: designation ?? "", location: location ?? "", completionHandler: {[weak self] (status,errorTitle,errorMsg) in
                
                DispatchQueue.main.async {
                    self?.registrationViewController.dismiss(animated: false, completion: {
                        if status {
                            self?.gotoHomeScreenController()
                        }
                        else{
                            self?.registrationViewController.showErrorMessage(errorTitle: errorTitle, errorMsg: errorMsg)
                        }
                    })
                }
            })
        }
        else{
            self.registrationViewController.showErrorMessage(errorTitle: "error_title".localized, errorMsg: "incomplete_registration_error".localized)
        }
    }
    
    /**
     Redirect to home screen.
     */
    func gotoHomeScreenController() {
        
        let initialViewController = registrationViewController.storyboard?.instantiateViewController(withIdentifier: LICConfiguration.HOMESCREEN_TABBAR_CONTROLLER) as! UITabBarController
        if let homeNC = initialViewController.viewControllers?.first as? UINavigationController,let homeVC = homeNC.viewControllers.first as? HomeScreenViewController {
            homeVC.isFromRegistration = true
        }
        
        UIApplication.shared.delegate?.window??.rootViewController = initialViewController
    }
    
    
    func isRegistrationFormComplete(fullName:String?, designation:String?, location:String?) -> Bool{
        if isValidFullName(fullName:fullName) && isValidDesignation(designation:designation) && !(location?.isEmpty ?? true) {
            return true
        }
        else {
            return false
        }
    }
    
    func isValidFullName(fullName:String?) -> Bool{
        let name = fullName?.trimmingCharacters(in: .whitespacesAndNewlines)
        if !(name?.isEmpty ?? true){
            return true
        }
        else {
            return false
        }
    }
    
    func isValidDesignation(designation:String?) -> Bool{
        let desig = designation?.trimmingCharacters(in: .whitespacesAndNewlines)
        if !(desig?.isEmpty ?? true){
            return true
        }
        else {
            return false
        }
    }
    
    /**
     Validate all user input fileds.
     */
    func validateRegistrationForm(fullName:String?, designation:String?) {
        
        if (fullName?.characters.count ?? 0) < NAME_MIN_LENGTH {
            registrationViewController.registrationValidationError(errorTitle: "error_title".localized, errorMessage: "fullname_min_length_error".localized)
            return
        }
        if (designation?.characters.count ?? 0) < NAME_MIN_LENGTH {
            registrationViewController.registrationValidationError(errorTitle: "error_title".localized, errorMessage: "designation_min_length_error".localized)
            return
        }
        registrationViewController.registrationValidationSuccess()
    }
    
    //Email Field validations
    func isValidEmail(email: String) -> Bool {
        
        let stricterFilterString = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest: NSPredicate = NSPredicate(format:"SELF MATCHES %@", stricterFilterString)
        return emailTest.evaluate(with: email)
        
    }
    
    func locationData() -> [String] {
        return registrationInteractor.locationData()
    }
    
}
