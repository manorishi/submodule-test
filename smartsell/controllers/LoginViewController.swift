//
//  LoginViewController.swift
//  licsuperagent
//
//  Created by Anurag Dake on 10/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

/**
 Display Login screen.
 */

import UIKit
import Core

protocol LoginProtocol {
    func shouldCharacterChange(mobileNumber: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    
    func clickedOnContinueButton(userName:String)
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    var eventHandler : LoginProtocol!
    var loginPresenter : LoginPresenter!
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseUI()
        loginPresenter = LoginPresenter(loginViewController: self)
        self.eventHandler = loginPresenter
        loginPresenter.configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mobileNumberTextField.becomeFirstResponder()
    }
    
    private func initialiseUI(){
        continueButton.isEnabled = false
        mobileNumberTextField.delegate = self
        mobileNumberTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return eventHandler.shouldCharacterChange(mobileNumber: textField.text, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    func textFieldDidChange(textField: UITextField){
        guard let userName = mobileNumberTextField.text else {
            return
        }
        loginPresenter.buttonState(button: continueButton, isEnabled: loginPresenter.isValidUsername(username: userName))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mobileNumberTextField.resignFirstResponder()
        return false
    }
    
    func showErrorMessage(errorTitle:String?,errorMsg:String?) {
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        alertViewHelper.showAlertView(title: errorTitle ?? "error_title".localized, message: errorMsg ?? "error_message".localized , cancelButtonTitle: "ok".localized)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func onContinueTap(_ sender: UIButton) {
        self.view.endEditing(true)
        eventHandler.clickedOnContinueButton(userName: self.mobileNumberTextField.text ?? "")
    }
    
}
