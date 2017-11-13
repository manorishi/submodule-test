//
//  PasswordViewController.swift
//  smartsell
//
//  Created by Anurag Dake on 04/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var userName: String?
    var email: String?
    var registeredStatus: Int?
    var passwordPresenter: PasswordPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordPresenter = PasswordPresenter(passwordViewController: self)
        initialise()
    }
    
    func initialise(){
        passwordPresenter.buttonState(button: submitButton, isEnabled: false)
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        guard let password = passwordTextField.text else {
            return
        }
        passwordPresenter.buttonState(button: submitButton, isEnabled: password.characters.count >= 6)
    }
    
    
    @IBAction func onSubmitButtonTap(_ sender: UIButton) {
        guard let password = passwordTextField.text else {
            return
        }
        passwordPresenter.verifyUserPassword(userName: userName, password: password)
    }
    
    
    @IBAction func onForgotPasswordTap(_ sender: UIButton) {
        passwordPresenter.resendSecurityKey(userName: userName, email: email, registeredStatus: registeredStatus)
    }
    
    @IBAction func onNotThisUserTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
