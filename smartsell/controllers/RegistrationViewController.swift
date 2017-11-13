//
//  RegistrationViewController.swift
//  smartsell
//
//  Created by Apple on 06/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core
import DropDown

protocol RegistrationProtocol {
    func validateRegistrationForm(fullName:String?, designation:String?)
}

/**
 RegistrationViewController display registration screen and manage textfield and textview delegate methods.
 */
class RegistrationViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var scrollContentViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameCharactersCount: UILabel!
    @IBOutlet weak var designationChractersCount: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var designationTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var dropDown:DropDown? = nil
    var activeTextField:UITextField? = nil
    var userData:UserData? = nil
    var eventHandler : RegistrationProtocol!
    
    let FULL_NAME_MAX_LENGTH = 50
    let DESIGNATION_MAX_LENGTH = 50
    
    var registtrationPresenter: RegistrationPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registtrationPresenter = RegistrationPresenter(registrationViewController: self)
        self.eventHandler = registtrationPresenter
        configView()
        initialiseDropDown()
        updateUserData()
        
    }
    
    func updateUserData() {
        mobileNumberLabel.text = userData?.emailId
        fullNameTextField.text = userData?.name
        designationTextField.text = userData?.designation
        fullNameCharactersCount.text = "\(fullNameTextField.text?.characters.count ?? 0)/\(FULL_NAME_MAX_LENGTH)"
        designationChractersCount.text = "\(designationTextField.text?.characters.count ?? 0)/\(DESIGNATION_MAX_LENGTH)"
        enableDisableContinueButton()
    }
    
    /**
     Initialise drop down.
     */
    func initialiseDropDown(){
        dropDown  = DropDown()
        dropDown?.dataSource = registtrationPresenter.locationData()
        if let location = userData?.location {
            locationTextField.text = location
        }
        dropDown?.direction = .any
        dropDown?.dismissMode = .onTap
        //Set anchor view for dropdown
        dropDown?.anchorView = locationTextField
        dropDown?.bottomOffset = CGPoint(x: 0, y:(dropDown?.anchorView?.plainView.bounds.height)!)
        dropDown?.topOffset = CGPoint(x: 0, y:-(dropDown?.anchorView?.plainView.bounds.height ?? 0))
        dropDown?.cancelAction = { [] in
            self.dropDown?.hide()
        }
        dropDown?.selectionAction = {[weak self] (index: Int, item: String) in
            self?.locationTextField.text = item
            self?.enableDisableContinueButton()
            }
        }
    
    func addTapGestureRecogniser(){
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnScrollView(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(singleTapGesture)
    }
    
    func tappedOnScrollView(_ sender:UIGestureRecognizer) {
        self.view.endEditing(true)
    }

    func configView() {
        for textField in [fullNameTextField,designationTextField,locationTextField] {
            textField?.delegate = self
            textField?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
            textField?.underlined(underlineColor: UIColor.lightGray)
        }
        addTapGestureRecogniser()
        addDropDownIcon()
    }
    
    func addDropDownIcon() {
        let imageView = UIImageView(frame: CGRect(x: 5, y: 15, width: 20, height: 20))
        imageView.contentMode = .scaleToFill
        let image = UIImage(named: "ic_drop_down")
        imageView.image = image
        locationTextField.rightView = imageView
        locationTextField.rightViewMode = .always
    }
    
    func isTextFieldTextCountValid(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        
        switch textField {
        case fullNameTextField:
            return newLength <= FULL_NAME_MAX_LENGTH
            
        case designationTextField:
            return newLength <= DESIGNATION_MAX_LENGTH
            
        default: return true
        }
    }
    
    //TextView delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.underlined(underlineColor: UIColor.lightGray)
        activeTextField = nil
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == locationTextField {
            textField.endEditing(true)
            dropDown?.show()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.underlined(underlineColor: hexStringToUIColor(hex: Colors.COLOR_PRIMARY) )
        activeTextField = textField
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return isTextFieldTextCountValid(textField: textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    
    @objc private func textFieldDidChange(textField: UITextField){
        guard let charCount = textField.text?.characters.count else {
            return
        }
        switch textField {
        case fullNameTextField:
            fullNameCharactersCount.text = "\(charCount)/\(FULL_NAME_MAX_LENGTH)"
            
        case designationTextField:
            designationChractersCount.text = "\(charCount)/\(DESIGNATION_MAX_LENGTH)"
            
        default:
            break
        }
        enableDisableContinueButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fullNameTextField: designationTextField.becomeFirstResponder()
        case designationTextField: designationTextField.resignFirstResponder()
        default: return true
        }
        return true
    }
    
    func enableDisableContinueButton() {
        registtrationPresenter.buttonState(button: continueButton, isEnabled: registtrationPresenter.isRegistrationFormComplete(fullName: fullNameTextField.text, designation: designationTextField.text, location: locationTextField.text))
    }
    
    func showErrorMessage(errorTitle:String?,errorMsg:String?) {
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        alertViewHelper.showAlertView(title: errorTitle ?? "error_title".localized, message: errorMsg ?? "error_message".localized , cancelButtonTitle: "ok".localized)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        eventHandler.validateRegistrationForm(fullName: fullNameTextField.text, designation: designationTextField.text)
    }
    
    func registrationValidationError(errorTitle: String?, errorMessage: String?) {
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        alertViewHelper.showAlertView(title: errorTitle ?? "", message: errorMessage ?? "", cancelButtonTitle: "ok".localized)
    }
    
    func registrationValidationSuccess() {
       registtrationPresenter.updateUserData(fullName: fullNameTextField.text, designation: designationTextField.text, location: locationTextField.text)
    }
}
