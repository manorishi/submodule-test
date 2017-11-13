//
//  SecurityKeyVerificationViewPresenter.swift
//  smartsell
//
//  Created by Anurag Dake on 01/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

class SecurityKeyVerificationViewPresenter: SmartSellBasePresenter{
    
    weak var securityKeyVerificationViewController: SecurityKeyVerificationViewController!
    var securityKeyVerificationInteractor: SecurityKeyVerificationInteractor!
    var securityKeyLength = 1
    
    init(securityKeyVerificationViewController: SecurityKeyVerificationViewController) {
        self.securityKeyVerificationViewController = securityKeyVerificationViewController
        securityKeyVerificationInteractor = SecurityKeyVerificationInteractor()
    }
    
    func addTextfields(in view: UIView, number: Int){
        securityKeyLength = number
        let width : CGFloat = ((UIScreen.main.bounds.width - 32) - CGFloat((number - 1) * 4))/8
        var x: CGFloat = 0
        for i in 1...number{
            let textfield = SecurityKeyTextField(frame: CGRect(x: x, y: 0, width: width, height: width))
            textfield.tag = i
            textfield.delegate = securityKeyVerificationViewController
            view.addSubview(textfield)
            x = x + width + 4
        }
    }
    
    func focusFirstTextField(view: UIView){
        let field = view.viewWithTag(1)
        field?.becomeFirstResponder()
    }
    
    func updateEmailSentLabel(label: UILabel, email: String?){
        guard let userEmail = email else {
            return
        }
        label.text = "\(label.text ?? "") \(userEmail)"
    }
    
    func shouldChangeCharactersIn(textField: UITextField, range: NSRange, replacementString: String) -> Bool {
        guard  let text = textField.text else {
            return true
        }
        let superview = textField.superview
        if text.characters.count == 0 && replacementString.characters.count == 1{
            if let field = firstEmptyField(in: superview){
                field.text = replacementString
                field.becomeFirstResponder()
            }else{
                textField.text = replacementString
            }
            checkButtonState(textField: textField)
            return false
        }else if text.characters.count == 1 && replacementString.characters.count == 1{
            let nextTag = textField.tag + 1
            let nextResponder = superview?.viewWithTag(nextTag)
            if nextResponder != nil{
                (nextResponder as? UITextField)?.text = replacementString
                nextResponder?.becomeFirstResponder()
            }
            checkButtonState(textField: textField)
            return false
        }else if text.characters.count == 1 && replacementString.characters.count == 0{
            let previousTag = textField.tag - 1
            let previousResponder = superview?.viewWithTag(previousTag)
            if previousResponder != nil{
                previousResponder?.becomeFirstResponder()
            }
            textField.text = replacementString
            checkButtonState(textField: textField)
            return false
        }
        return true
    }
    
    func checkButtonState(textField: UITextField){
        buttonState(button: securityKeyVerificationViewController.submitButton, isEnabled: firstEmptyField(in: textField.superview) == nil)
    }
    
    func firstEmptyField(in superview: UIView?) -> UITextField?{
        for i in 1...securityKeyLength{
            if let field = superview?.viewWithTag(i) as? UITextField, let text = field.text{
                if text.isEmpty{
                    return field
                }
            }
        }
        return nil
    }
    
    func securityKey(in superview: UIView?) -> String{
        var securityKey = ""
        for i in 1...securityKeyLength{
            if let field = superview?.viewWithTag(i) as? UITextField, let text = field.text{
                securityKey = "\(securityKey)\(text)"
            }
        }
        return securityKey
    }
    
    func verifySecurityKey(userName: String?, securityKey: String, registeredStatus: Int?){
        guard userName != nil else {
            return
        }
        showLoadingController()
        securityKeyVerificationInteractor.verifyUserSecurity(userName: userName!, securityKey: securityKey) { [weak self] (status, errorTitle, errMessage) in
            DispatchQueue.main.async {
                self?.securityKeyVerificationViewController.dismiss(animated: false, completion: {
                    if status{
                        print("Success")
                        guard let createPasswordVC = self?.securityKeyVerificationViewController.storyboard?.instantiateViewController(withIdentifier: "CreatePasswordViewController") as? CreatePasswordViewController else{
                            return
                        }
                        createPasswordVC.securityKey = securityKey
                        createPasswordVC.username = userName
                        createPasswordVC.registeredStatus = registeredStatus
                        self?.securityKeyVerificationViewController.navigationController?.pushViewController(createPasswordVC, animated: true)
                    }else{
                        self?.showAlertMessage(title: nil, message: errMessage)
                    }
                })
            }
        }
    }
    
    func resendSecurityKey(userName: String?){
        guard userName != nil else {
            return
        }
        showLoadingController()
        securityKeyVerificationInteractor.resend(userName: userName!) { [weak self] (status, errorTitle, message) in
            DispatchQueue.main.async {
                self?.securityKeyVerificationViewController.dismiss(animated: false, completion: { 
                    if status{
                        self?.showAlertMessage(title: nil, message: message)
                    }else{
                        self?.showAlertMessage(title: errorTitle, message: message)
                    }
                })
            }
        }
    }
    
    func showLoadingController(){
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        let loadingController = alertViewHelper.loadingAlertViewController(title: "Loading...", message: "\n\n")
        securityKeyVerificationViewController.present(loadingController, animated: true, completion: nil)
    }
}
