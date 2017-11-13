//
//  SecurityKeyVerificationViewController.swift
//  smartsell
//
//  Created by Anurag Dake on 01/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

class SecurityKeyVerificationViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var securityKeyView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailSentLabel: UILabel!
    
    var email: String?
    var username: String?
    var registeredStatus: Int?
    var securityKeyVerificationViewPresenter: SecurityKeyVerificationViewPresenter!
    let SECURITY_KEY_LENGTH = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        securityKeyVerificationViewPresenter = SecurityKeyVerificationViewPresenter(securityKeyVerificationViewController: self)
        initialise()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        securityKeyVerificationViewPresenter.focusFirstTextField(view: securityKeyView)
    }
    
    func initialise(){
        securityKeyVerificationViewPresenter.addTextfields(in: securityKeyView, number: SECURITY_KEY_LENGTH)
        securityKeyVerificationViewPresenter.buttonState(button: submitButton, isEnabled: false)
        securityKeyVerificationViewPresenter.updateEmailSentLabel(label: emailSentLabel, email: email)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return securityKeyVerificationViewPresenter.shouldChangeCharactersIn(textField: textField, range: range, replacementString: string)
    }
    
    
    @IBAction func onSubmitButtonTap(_ sender: UIButton) {
        let securityKey = securityKeyVerificationViewPresenter.securityKey(in: securityKeyView)
        print(securityKey)
        securityKeyVerificationViewPresenter.verifySecurityKey(userName: username, securityKey: securityKey, registeredStatus: registeredStatus)
    }
    
    @IBAction func onResendSecurityKeyTap(_ sender: UIButton) {
        securityKeyVerificationViewPresenter.resendSecurityKey(userName: username)
    }
    
    @IBAction func onNotThisUserTap(_ sender: UIButton) {
        for controller in self.navigationController?.viewControllers ?? []{
            if controller is LoginViewController{
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
}
