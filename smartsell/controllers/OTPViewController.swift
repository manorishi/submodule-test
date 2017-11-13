        //
//  OTPViewController.swift
//  smartsell
//
//  Created by Apple on 04/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core
        
protocol OTPProtocol {
    func resendOTPButtonPress(mobileNo:String)
    func otpVerification(otpCode:String,mobileNo:String)
    func mobileTextfield(mobileNumber: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func otpTextfield(otp: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

/**
OTPViewController display otp screen and manage view when keyboard appears.
*/
class OTPViewController: UIViewController,UITextFieldDelegate {

    var otpPresenter : OTPPresenter!
    var eventHandler : OTPProtocol!
    private let OTP_TEXTFIELD_PLACEHOLDER = "Enter OTP"
    private let MOBILE_TEXTFIELD_PLACEHOLDER = "Re-enter Mobile Number"
    
    @IBOutlet weak var resendOTPContainerView: UIView!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var resendMessageLabel: UILabel!
    @IBOutlet weak var scrollViewContentWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewContentHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var mobileNumber:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpPresenter = OTPPresenter(otpViewController: self)
        self.eventHandler = otpPresenter
        configView()
        addTapGestureRecogniser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    func addTapGestureRecogniser(){
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnScrollView(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(singleTapGesture)
    }
    
    func tappedOnScrollView(_ sender:UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    /**
     Unregister for keyboard notification.
     */
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /**
     Register for keyboard show/hide notification.
     */
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(OTPViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OTPViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /**
     Adjust view when keyboard appears.
     */
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardRect.size.height, 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            
            if mobileNumberTextField.isEditing == true {
                var aRect: CGRect = self.view.frame
                aRect.size.height -= keyboardRect.size.height
                if (!aRect.contains(CGPoint(x: resendOTPContainerView.frame.origin.x, y: resendOTPContainerView.frame.origin.y + mobileNumberTextField.frame.origin.y))) {
                    self.scrollView.scrollRectToVisible(resendOTPContainerView.frame, animated:true)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
            self.scrollView.contentInset = UIEdgeInsets.zero
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func updateResendMessage() {
        resendMessageLabel.text = "We have sent the OTP SMS to \(mobileNumber ?? "").\nIf this is wrong, please re-enter the correct mobile number to send OTP again."
    }
    
    func configView() {
        
        scrollViewContentWidth.constant = UIScreen.main.bounds.size.width
        scrollViewContentHeight.constant = UIScreen.main.bounds.size.height - UIApplication.shared.statusBarFrame.size.height
        updateResendMessage()
        resendOTPContainerView.backgroundColor = UIColor.clear
        blurView(resendOTPContainerView)
        continueButton.isHidden = true
        
        resendButton.setTitleColor(UIColor.gray, for: .normal)
        resendButton.clipsToBounds = true
        resendButton.layer.cornerRadius = 4
        resendButton.backgroundColor = hexStringToUIColor(hex: Colors.CONTINUE_DARK_BLUE)
        configTextField()
    }
    
    func configTextField() {
        otpTextField.attributedPlaceholder = NSAttributedString(string: OTP_TEXTFIELD_PLACEHOLDER ,attributes: [NSForegroundColorAttributeName: hexStringToUIColor(hex: Colors.TEXTFIELD_PLACEHOLDER_COLOR)])
        otpTextField.delegate = self
        otpTextField.addTarget(self, action: #selector(OTPViewController.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        mobileNumberTextField.delegate = self
        mobileNumberTextField.addTarget(self, action: #selector(OTPViewController.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        mobileNumberTextField.attributedPlaceholder = NSAttributedString(string: MOBILE_TEXTFIELD_PLACEHOLDER ,attributes: [NSForegroundColorAttributeName: UIColor.init(white: 1, alpha: 0.8)])
        mobileNumberTextField.underlined(underlineColor: UIColor.white)
    }
    
    /**
     Append blurred view in passed parameter view.
     */
    func blurView(_ view:UIView) {
        let blurEffect = UIBlurEffect(style:.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurEffectView)
        view.sendSubview(toBack: blurEffectView)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.otpTextField:
            return eventHandler.otpTextfield(otp: textField.text, shouldChangeCharactersIn: range, replacementString: string)
        case self.mobileNumberTextField:
            return eventHandler.mobileTextfield(mobileNumber: textField.text, shouldChangeCharactersIn: range, replacementString: string)
        default:
            return true
        }
    }
    
    func textFieldDidChange(textField: UITextField){
        switch textField {
        case self.mobileNumberTextField:
            if let mobileNumber = mobileNumberTextField.text {
            if ValidationUtils.isValidMobileNumber(mobileNumber: mobileNumber){
                resendButton.isEnabled = true
                resendButton.setTitleColor(UIColor.white, for: .normal)
            }
            else{
                resendButton.isEnabled = false
                resendButton.setTitleColor(UIColor.gray, for: .normal)
            }
        }
        case self.otpTextField:
            if let otp = otpTextField.text {
                if ValidationUtils.isValidOTP(otp:otp){
                    verifyOtp()
                }
            }
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func resendButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if let mobileNo = mobileNumberTextField.text {
            mobileNumber = mobileNo
            updateResendMessage()
        eventHandler.resendOTPButtonPress(mobileNo: mobileNo)
        }
    }
    
    func showOTPSuccessMsg() {
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        alertViewHelper.showAlertView(title: "", message: "otp_resend_success_msg".localized, cancelButtonTitle: "ok".localized)
    }
    
    func showErrorMessage(errorTitle:String?,errorMsg:String?) {
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        alertViewHelper.showAlertView(title: errorTitle ?? "error_title".localized, message: errorMsg ?? "error_message".localized , cancelButtonTitle: "ok".localized)
    }
    
    func verifyOtp() {
        self.view.endEditing(true)
        if let otpCode = otpTextField.text {
            eventHandler.otpVerification(otpCode: otpCode, mobileNo: mobileNumber ?? "")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
