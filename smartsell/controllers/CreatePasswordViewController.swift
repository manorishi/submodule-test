//
//  CreatePasswordViewController.swift
//  smartsell
//
//  Created by Anurag Dake on 04/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

class CreatePasswordViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var passwordTestField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var username: String?
    var securityKey: String?
    var registeredStatus: Int?
    var createPasswordPresenter: CreatePasswordPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPasswordPresenter = CreatePasswordPresenter(createPasswordViewController: self)
        initialise()
    }
        
    func initialise(){
        createPasswordPresenter.buttonState(button: submitButton, isEnabled: false)
        passwordTestField.delegate = self
        confirmPasswordTextField.delegate = self
    }

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        guard let passwordText = passwordTestField.text, let confirmPasswordText = confirmPasswordTextField.text else {
            return
        }
        createPasswordPresenter.buttonState(button: submitButton, isEnabled: passwordText.characters.count >= 6 && confirmPasswordText.characters.count >= 6)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTestField:
            confirmPasswordTextField.becomeFirstResponder()
            
        case confirmPasswordTextField:
            confirmPasswordTextField.resignFirstResponder()
        default:
            return true
        }
        return true
    }
    
    @IBAction func onSubmitButtonTap(_ sender: UIButton) {
        guard let passwordText = passwordTestField.text, let confirmPasswordText = confirmPasswordTextField.text else {
            return
        }
        if passwordText == confirmPasswordText{
            createPasswordPresenter.updateUserPassword(userName: username, securityKey: securityKey, password: passwordText, registeredStatus: registeredStatus)
        }else{
            createPasswordPresenter.showAlertMessage(title: nil, message: "password_mismatch".localized)
        }
    }
    
    @IBAction func onNotThisUserTap(_ sender: UIButton) {
        for controller in self.navigationController?.viewControllers ?? []{
            if controller is LoginViewController{
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    
}
