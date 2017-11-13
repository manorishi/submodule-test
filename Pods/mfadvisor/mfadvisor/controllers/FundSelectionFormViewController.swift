//
//  FundSelectionFormViewController.swift
//  mfadvisor
//
//  Created by Anurag Dake on 08/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core
import DropDown

/**
 FundSelectionFormViewController gives form to accept values for lumpsum and SIP.
 It also handle the validations and passes data for pdf generation page
 */
class FundSelectionFormViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var fundSelectionFormScrollView: UIScrollView!
    @IBOutlet weak var fundSelectionFormContentView: UIView!
    @IBOutlet weak var contentViewHeightConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var customerNameTextField: UITextField!
    
    @IBOutlet weak var fund1NameLabel: UILabel!
    @IBOutlet weak var fund1LumpsumTextField: UITextField!
    @IBOutlet weak var fund1SipAmountLabel: UILabel!
    @IBOutlet weak var fund1SipTextField: UITextField!
    @IBOutlet weak var fund1AddSipButton: UIButton!
    @IBOutlet weak var fund1ViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var fund2View: UIView!
    @IBOutlet weak var fund2NameLabel: UILabel!
    @IBOutlet weak var fund2LumpsumTextField: UITextField!
    @IBOutlet weak var fund2SipAmountLabel: UILabel!
    @IBOutlet weak var fund2SipTextField: UITextField!
    @IBOutlet weak var fund2AddSipButton: UIButton!
    @IBOutlet weak var fund2ViewHeight: NSLayoutConstraint!
    
    var fundSelectionFormPresenter: FundSelectionFormPresenter!
    var managedObjectContext: NSManagedObjectContext?
    var mFSelectionItem: MFSelectionItem?
    var activeTextField: UITextField?
    private var dropDown = DropDown()
    let ENTER_AMOUNT_ERROR = "Enter atleast one amount"
    let INVALID_RANGE_ERROR = "Valid range"
    let INVALID_MULTIPLE_ERROR = "Amount should be multiple of"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fundSelectionFormPresenter = FundSelectionFormPresenter(fundSelectionFormViewController: self)
        initialise()
        addTapGestureRecogniserToScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialiseUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    func addTapGestureRecogniserToScrollView(){
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnScrollView(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        self.fundSelectionFormScrollView.addGestureRecognizer(singleTapGesture)
    }
    
    func tappedOnScrollView(_ sender:UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func initialise(){
        if let selectionItem = mFSelectionItem, let managedObjContext = managedObjectContext{
            fundSelectionFormPresenter.minMaxValuesForFunds(managedObjectContext: managedObjContext, selectionFundItems: selectionItem.fundItems)
        }
        customerNameTextField.delegate = self
        fund1LumpsumTextField.delegate = self
        fund1SipTextField.delegate = self
        fund2LumpsumTextField.delegate = self
        fund2SipTextField.delegate = self
        setFundsdata()
        fundSelectionFormPresenter.initialiseDropDown(dropDown: dropDown)
    }
    
    func initialiseUI(){
        fundSelectionFormPresenter.underlineTextFields(textfields: [customerNameTextField, fund1LumpsumTextField, fund1SipTextField, fund2LumpsumTextField, fund2SipTextField])
        fundSelectionFormPresenter.addBorderToButtons(buttons: [fund1AddSipButton, fund2AddSipButton])
    }
    
    func setFundsdata(){
        guard let fundItems = mFSelectionItem?.fundItems else {
            return
        }
        if let fund = fundItems.first{
            fund1NameLabel.text = "\(fund.fundName ?? "") (\(String(format: "%.1f", fund.fundAllocation ?? 0))%)"
        }
        if fundItems.count > 1{
            fund2View.isHidden = false
            let fund = fundItems[1]
            fund2NameLabel.text = "\(fund.fundName ?? "") (\(String(format: "%.1f", fund.fundAllocation ?? 0))%)"
        }
    }
    
    
    @IBAction func onFund1AddSipTap(_ sender: UIButton) {
        fund1SipAmountLabel.isHidden = false
        fund1SipTextField.isHidden = false
        fund1AddSipButton.isHidden = true
        fund1ViewHeight.constant = 140
    }
    
    @IBAction func onFund2AddSipTap(_ sender: UIButton) {
        fund2SipAmountLabel.isHidden = false
        fund2SipTextField.isHidden = false
        fund2AddSipButton.isHidden = true
        fund2ViewHeight.constant = 140
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        fundSelectionFormPresenter.underLineTextField(textfield: textField, color: hexStringToUIColor(hex: "#AE275F"))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        fundSelectionFormPresenter.underLineTextField(textfield: textField, color: UIColor.darkGray)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == customerNameTextField{
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 40
        }
        return true
    }
    
    @IBAction func onCreatePresentationTap(_ sender: UIButton) {
        if isDataValid(){
            guard let fundItems = mFSelectionItem?.fundItems else{
                return
            }
            let fund1 = fundItems.first
            fund1?.lumpSum = Double(fund1LumpsumTextField.text ?? "")
            fund1?.sip = Float(fund1SipTextField.text ?? "")
            
            if fundItems.count > 1{
                let fund2 = fundItems[1]
                fund2.lumpSum = Double(fund2LumpsumTextField.text ?? "")
                fund2.sip = Float(fund2SipTextField.text ?? "")
            }
            
            fundSelectionFormPresenter.gotoFundPresentation(managedObjectContext: managedObjectContext, mFSelectionItem: mFSelectionItem, customerName: customerNameTextField.text)
        }
    }
    
    ///Checks for data validation
    func isDataValid() -> Bool{
        guard let fundItems = mFSelectionItem?.fundItems, let fund1 = fundItems.first else{
            return false
        }
        
        let fund1LumpSum = fund1LumpsumTextField.text ?? ""
        let fund1Sip = fund1SipTextField.text ?? ""
        let fund2LumpSum = fund2LumpsumTextField.text ?? ""
        let fund2Sip = fund2SipTextField.text ?? ""
        
        if fund1LumpSum == "" && fund1Sip == "" && fund2LumpSum == "" && fund2Sip == ""{
            displayError(anchorView: fund1LumpsumTextField, errorMessage: ENTER_AMOUNT_ERROR)
            return false
        }
        
        if fund1LumpSum != ""{
            let lumpSum = Double(fund1LumpSum) ?? 0
            if let maxLumpSum = fund1.lumpsumMaximum, let minLumpSum = fund1.lumpsumMinimum,  lumpSum < Double(minLumpSum) || lumpSum > maxLumpSum {
                displayError(anchorView: fund1LumpsumTextField, errorMessage: rangeErrorString(minValue: fund1.lumpsumMinimum, maxValue: fund1.lumpsumMaximum))
                return false
            }else{
                if let multiple = fund1.lumpsumMultiple, lumpSum.truncatingRemainder(dividingBy: Double(multiple)) != 0{
                    displayError(anchorView: fund1LumpsumTextField, errorMessage: multipleErrorString(multiple: fund1.lumpsumMultiple))
                    return false
                }
            }
        }
        
        if fund1Sip != ""{
            let sip = Double(fund1Sip) ?? 0
            if let maxSip = fund1.sipMaximum, let minSip = fund1.sipMinimum, sip < Double(minSip) || sip > maxSip{
                displayError(anchorView: fund1SipTextField, errorMessage: rangeErrorString(minValue: fund1.sipMinimum, maxValue: fund1.sipMaximum))
                return false
            }else{
                if let multiple = fund1.sipMultiple, sip.truncatingRemainder(dividingBy: Double(multiple)) != 0{
                    displayError(anchorView: fund1SipTextField, errorMessage: multipleErrorString(multiple: fund1.sipMultiple))
                    return false
                }
            }
        }
        
        if fundItems.count > 1{
            let fund2 = fundItems[1]
            
            if fund2LumpSum != ""{
                let lumpSum = Double(fund2LumpSum) ?? 0
                if let maxLumpSum = fund2.lumpsumMaximum, let minLumpSum = fund2.lumpsumMinimum, lumpSum < Double(minLumpSum) || lumpSum > maxLumpSum {
                    displayError(anchorView: fund2LumpsumTextField, errorMessage: rangeErrorString(minValue: fund2.lumpsumMinimum, maxValue: fund2.lumpsumMaximum))
                    return false
                }else{
                    if let multiple = fund2.lumpsumMultiple, lumpSum.truncatingRemainder(dividingBy: Double(multiple)) != 0{
                        displayError(anchorView: fund2LumpsumTextField, errorMessage: multipleErrorString(multiple: fund2.lumpsumMultiple))
                        return false
                    }
                }
            }
            
            if fund2Sip != ""{
                let sip = Double(fund2Sip) ?? 0
                if let maxSip = fund2.sipMaximum, let minSip = fund2.sipMinimum, sip < Double(minSip) || sip > maxSip{
                    displayError(anchorView: fund2SipTextField, errorMessage: rangeErrorString(minValue: fund2.sipMinimum, maxValue: fund2.sipMaximum))
                    return false
                }else{
                    if let multiple = fund2.sipMultiple, sip.truncatingRemainder(dividingBy: Double(multiple)) != 0{
                        displayError(anchorView: fund2SipTextField, errorMessage: multipleErrorString(multiple: fund2.sipMultiple))
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    ///Genarates the amount range error string
    func rangeErrorString(minValue: Float?, maxValue: Double?) -> String{
        return "\(INVALID_RANGE_ERROR) \(String(format: "%.1f", minValue ?? 0)) - \(String(format: "%.1f", maxValue ?? 0))"
    }
    
    ///Genarates the amount multiple error string
    func multipleErrorString(multiple: Float?) -> String{
        return "\(INVALID_MULTIPLE_ERROR) \(String(format: "%.1f", multiple ?? 0))"
    }
    
    ///Displays error as dropdoen
    func displayError(anchorView: UITextField, errorMessage: String){
        fundSelectionFormPresenter.underLineTextField(textfield: anchorView, color: UIColor.red)
        dropDown.dataSource.removeAll()
        dropDown.dataSource.append(errorMessage)
        fundSelectionFormPresenter.setDropDownAnchor(dropDown: dropDown, anchorView: anchorView)
        fundSelectionFormPresenter.setDropDownSelectionActions(dropDown: dropDown)
        dropDown.show()
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(FundSelectionFormViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FundSelectionFormViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardRect.size.height, 0.0)
            self.fundSelectionFormScrollView.contentInset = contentInsets
            self.fundSelectionFormScrollView.scrollIndicatorInsets = contentInsets
            
            if let activeTextField = activeTextField {
                var aRect: CGRect = self.view.frame
                aRect.size.height -= keyboardRect.size.height
                if (!aRect.contains(activeTextField.frame.origin)) {
                    self.fundSelectionFormScrollView.scrollRectToVisible(activeTextField.frame, animated:true)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.fundSelectionFormScrollView.contentInset = UIEdgeInsets.zero
        self.fundSelectionFormScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
