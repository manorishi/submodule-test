//
//  SIPCalculatorViewController.swift
//  mfadvisor
//
//  Created by Anurag Dake on 15/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import DropDown
import Core

enum SIPBasedType{
    case monthlyInvestment
    case targetAmount
}

public class SIPCalculatorViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var expReturnTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var monthlyInvestmentButton: UIButton!
    @IBOutlet weak var targetAmountButton: UIButton!
    
    private var dropDown = DropDown()
    var bundle: Bundle!
    var sipCalculatorPresenter: SIPCalculatorPresenter!
    var activeTextField: UITextField?
    var pickerView: UIPickerView?
    let investmenyOptionArray = Array(4...30)
    var sipBasedType: SIPBasedType = .monthlyInvestment
    let currencyUnicode = "\u{20B9}"
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        sipCalculatorPresenter = SIPCalculatorPresenter()
        bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) ?? Bundle.main
        initialise()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialiseUI()
    }
    
    func initialise(){
        customerNameTextField.delegate = self
        amountTextField.delegate = self
        yearTextField.delegate = self
        monthTextField.delegate = self
        expReturnTextField.delegate = self
        initialisePicker()
        updateUIOnRadioButtonTap(amountTextKey: "monthly_investment", monthlyInvestmentImageName: "ic_radio_button_checked", targetAmountImageName: "ic_radio_button_unchecked", amount: "10000")
        sipCalculatorPresenter.initialiseDropDown(dropDown: dropDown)
    }
    
    func initialiseUI(){
        sipCalculatorPresenter.underlineTextFields(textfields: [customerNameTextField, amountTextField, yearTextField, monthTextField, expReturnTextField])
    }
    
    func initialisePicker(){
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
        expReturnTextField.inputView = pickerView
        pickerView?.selectRow(8, inComponent: 0, animated: false)
    }
    
    @IBAction func onMonthlyInvestmentTap(_ sender: UIButton) {
        updateUIOnRadioButtonTap(amountTextKey: "monthly_investment", monthlyInvestmentImageName: "ic_radio_button_checked", targetAmountImageName: "ic_radio_button_unchecked", amount: "10000")
        sipBasedType = .monthlyInvestment
    }
    
    
    @IBAction func onTargetAmountTap(_ sender: UIButton) {
        updateUIOnRadioButtonTap(amountTextKey: "target_amount", monthlyInvestmentImageName: "ic_radio_button_unchecked", targetAmountImageName: "ic_radio_button_checked", amount: "500000")
        sipBasedType = .targetAmount
    }
    
    private func updateUIOnRadioButtonTap(amountTextKey: String, monthlyInvestmentImageName: String, targetAmountImageName: String, amount: String){
        amountLabel.text = sipCalculatorPresenter.localised(string: amountTextKey, bundle: bundle)
        monthlyInvestmentButton.setImage(UIImage(named: monthlyInvestmentImageName, in: bundle, compatibleWith: nil), for: .normal)
        targetAmountButton.setImage(UIImage(named: targetAmountImageName, in: bundle, compatibleWith: nil), for: .normal)
        amountTextField.text = amount
        
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        sipCalculatorPresenter.underLineTextField(textfield: textField, color: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR))
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        sipCalculatorPresenter.underLineTextField(textfield: textField, color: UIColor.darkGray)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 50
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        switch sender {
        case amountTextField:
            let validation = sipCalculatorPresenter.isInvestmentAmountValid(text: sender.text, for: sipBasedType)
            if !validation.isValid{
                displayError(anchorView: amountTextField, errorMessage: sipCalculatorPresenter.localised(string: validation.errorStringKey!, bundle: bundle))
            }else{
                hideError()
            }
        
        case yearTextField:
            let validation = sipCalculatorPresenter.isYearsValid(text: yearTextField.text)
            if !validation.isValid{
                displayError(anchorView: yearTextField, errorMessage: sipCalculatorPresenter.localised(string: validation.errorStringKey!, bundle: bundle))
            }else{
                hideError()
            }
        
        case monthTextField:
            let validation = sipCalculatorPresenter.isMonthValid(yearsText: yearTextField.text, monthtext: monthTextField.text)
            if !validation.isValid{
                displayError(anchorView: monthTextField, errorMessage: sipCalculatorPresenter.localised(string: validation.errorStringKey!, bundle: bundle))
            }else{
                hideError()
            }
            
        default: break
        }
    }
    
    func displayError(anchorView: UITextField, errorMessage: String){
        dropDown.dataSource.removeAll()
        dropDown.dataSource.append(errorMessage)
        sipCalculatorPresenter.setDropDownAnchor(dropDown: dropDown, anchorView: anchorView)
        sipCalculatorPresenter.setDropDownSelectionActions(dropDown: dropDown)
        dropDown.show()
    }
    
    func hideError(){
        dropDown.hide()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return investmenyOptionArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String("\(investmenyOptionArray[row])%")
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        expReturnTextField.text = "\(investmenyOptionArray[row])%"
    }
    
    @IBAction func onCalculateSIPTap(_ sender: UIButton) {
        guard areAllFieldsValid() else {
            return
        }
        gotoSipCalculatorResult()
    }
    
    private func gotoSipCalculatorResult(){
        let MFADVISOR_BUNDLE = "mfadvisor"
        let podBundle = Bundle(for: SIPCalculatorResultViewController.classForCoder())
        guard let bundleURL = podBundle.url(forResource: MFADVISOR_BUNDLE, withExtension: "bundle"), let bundle = Bundle(url: bundleURL) else{
            return
        }
        let sipCalculatorViewController = SIPCalculatorResultViewController(nibName: "SIPCalculatorResultViewController", bundle: bundle)
        let sipResult = calculateSIPResult()
        sipCalculatorViewController.customerName = customerNameTextField.text
        sipCalculatorViewController.monthlyAmount = "\(currencyUnicode)\(sipCalculatorPresenter.getFormattedNumberText(number: sipResult.monthlyAmount))"
        sipCalculatorViewController.tenure = sipCalculatorPresenter.tenureText(yearText: yearTextField.text, monthText: monthTextField.text)
        sipCalculatorViewController.expectedReturns = expReturnTextField.text
        sipCalculatorViewController.totalInvestment = "\(currencyUnicode)\(sipCalculatorPresenter.getFormattedNumberText(number: sipResult.totalInvestment))"
        sipCalculatorViewController.totalReturns = "\(currencyUnicode)\(sipCalculatorPresenter.getFormattedNumberText(number: sipResult.totalReturns))"
        self.navigationController?.pushViewController(sipCalculatorViewController, animated: true)
    }
    
    func calculateSIPResult() -> (monthlyAmount: Double, totalInvestment: Double, totalReturns: Double){
        var totalInvestment: Double
        var totalReturns: Double
        var targetAmount: Double
        var monthlyAmount = sipCalculatorPresenter.getMonthlyAmount(sipBasedType: sipBasedType, amountText: amountTextField.text)
        
        let tenureYear = Int(yearTextField.text ?? "0") ?? 0
        let tenureMonth = Int(monthTextField.text ?? "0") ?? 0
        let expectedReturn: Double = Double(sipCalculatorPresenter.expectedReturns(expectedReturnText: expReturnTextField.text))
        
        switch sipBasedType {
        case .monthlyInvestment:
            totalInvestment = (Double(tenureYear * 12) + Double(tenureMonth)) * monthlyAmount
            totalReturns = monthlyAmount * (pow(Double(1 + (expectedReturn / 1200)), Double(tenureYear * 12 + tenureMonth)) - 1) / (1 - pow(Double(1 + expectedReturn / 1200), Double(-1)))
            totalReturns = round(totalReturns)
            
        case .targetAmount:
            targetAmount = Double(amountTextField.text ?? "0") ?? 0
            var monthlyInvestment = round(targetAmount * ((1 - pow(Double(1 + expectedReturn / 1200), Double(-1))) /
                (pow(Double(1 + (expectedReturn / 1200)), Double(tenureYear * 12 + tenureMonth)) - 1)))
            monthlyInvestment = getRoundedValue(monthlyInvestment: monthlyInvestment)
            totalInvestment = round(Double((tenureYear * 12 + tenureMonth) * Int(monthlyInvestment)))
            totalReturns = round(monthlyInvestment * (pow(Double(1 + (expectedReturn / 1200)), Double(tenureYear * 12 + tenureMonth)) - 1) /
                (1 - pow(Double(1 + expectedReturn / 1200), Double(-1))))
            monthlyAmount = monthlyInvestment
        }
        
        return (monthlyAmount, totalInvestment, totalReturns)
    }
    
    func getRoundedValue(monthlyInvestment:Double) -> Double {
        var monthlyInvest = Int(monthlyInvestment)
        if (monthlyInvest % 100 != 0) {
            monthlyInvest = 100 * (monthlyInvest / 100) + 100
        }
        return Double(monthlyInvest)
    }
    
    func areAllFieldsValid() -> Bool{
        let amountValidation = sipCalculatorPresenter.isInvestmentAmountValid(text: amountTextField.text, for: sipBasedType)
        let yearsValidation = sipCalculatorPresenter.isYearsValid(text: yearTextField.text)
        let monthsValidation = sipCalculatorPresenter.isMonthValid(yearsText: yearTextField.text, monthtext: monthTextField.text)
        
        if !amountValidation.isValid{
            displayError(anchorView: amountTextField, errorMessage: sipCalculatorPresenter.localised(string: amountValidation.errorStringKey!, bundle: bundle))
            return false
        }
        if !yearsValidation.isValid{
            displayError(anchorView: yearTextField, errorMessage: sipCalculatorPresenter.localised(string: yearsValidation.errorStringKey!, bundle: bundle))
            return false
        }
        if !monthsValidation.isValid{
            displayError(anchorView: monthTextField, errorMessage: sipCalculatorPresenter.localised(string: monthsValidation.errorStringKey!, bundle: bundle))
            return false
        }
        return true
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onHomeButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
