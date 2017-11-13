//
//  SIPCalViewController.swift
//  mfadvisor
//
//  Created by Anurag Dake on 03/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core
import DropDown

class SIPCalViewController: UIViewController, UITextFieldDelegate, PickerValueChangeListener, DatePickerValueChangeListener{
    
    @IBOutlet weak var selectedFundNameLabel: UILabel!
    @IBOutlet weak var sipAmountTextField: UITextField!
    @IBOutlet weak var sipDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var valueAsOnDateTextField: UITextField!
    
    @IBOutlet weak var advancedOptionsView: UIView!
    @IBOutlet weak var advancedOptionsViewHeightConstraint: NSLayoutConstraint!
    
    private var dropDown = DropDown()
    var sipCalPresenter: SIPCalPresenter!
    var activeTextField: UITextField?
    var fundNavData: [MFNavData]?
    var dates: (startNav: MFNavData?, endNav: MFNavData?)?
    var pickerViewHelper: PickerViewHelper!
    var datePickerHelper: DatePickerHelper!
    public var managedObjectContext:NSManagedObjectContext?
    public var fundId:String!
    public var fundName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sipCalPresenter = SIPCalPresenter()
        initialise()
        fetchFundNAVData()
        updateDateData()
        initialisePickerView()
        initialiseDatePicker()
        sipCalPresenter.initialiseDropDown(dropDown: dropDown)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialiseUI()
    }
    
    func initialise(){
        self.navigationController?.navigationBar.isHidden = true
        selectedFundNameLabel.text = fundName ?? ""
        setTextFieldDelegate()
        activeTextField = sipAmountTextField
    }
    
    func setTextFieldDelegate(){
        for field in [sipAmountTextField, sipDateTextField, endDateTextField, valueAsOnDateTextField]{
            field?.delegate = self
        }
    }
    
    func initialiseUI(){
        sipCalPresenter.underlineTextFields(textfields: [sipAmountTextField, sipDateTextField, endDateTextField, valueAsOnDateTextField])
    }
    
    func fetchFundNAVData(){
        guard let managedObjContext = managedObjectContext else {
            return
        }
        fundNavData = sipCalPresenter.fundNAVData(fundId: fundId, managedObjectContext: managedObjContext)
    }
    
    func updateDateData(){
        guard let navData = fundNavData else {
            return
        }
        dates = sipCalPresenter.startAndEndDate(navData: navData)
        if let startDate = dates?.startNav{
            sipDateTextField.text = "\(startDate.month)/\(startDate.year)"
        }
        if let endDate = dates?.endNav{
            endDateTextField.text = "\(endDate.month)/\(endDate.year)"
            valueAsOnDateTextField.text = "\(endDate.day)/\(endDate.month)/\(endDate.year)"
        }
    }
    
    func initialisePickerView(){
        if let startDate = dates?.startNav, let endDate = dates?.endNav{
            pickerViewHelper = PickerViewHelper(startDate: (Int(startDate.month), Int(startDate.year)), endDate: (Int(endDate.month), Int(endDate.year)))
            pickerViewHelper.delegate = self
            pickerViewHelper.attach(fields: [sipDateTextField, endDateTextField])
        }
    }
    
    func initialiseDatePicker(){
        datePickerHelper = DatePickerHelper()
        datePickerHelper.delegate = self
        datePickerHelper.attach(fields: [valueAsOnDateTextField])
    }
    
    func updateDatePickerData(){
        var defaultDate = Date()
        var maxDate = Date()
        var minDate = Date()
        if let dateString = valueAsOnDateTextField.text{
            defaultDate = Date.init(dateString: dateString)
        }else{
            defaultDate = Date.init()
        }
        if let endDate = dates?.endNav{
            maxDate = datefrom(day: Int(endDate.day), month: Int(endDate.month), year: Int(endDate.year))
        }
        if let minDateText = endDateTextField.text{
            minDate = Date.init(dateString: "01/\(minDateText)")
        }
        datePickerHelper.updateDatePickerData(date: defaultDate, minDate: minDate, maxDate: maxDate)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case sipDateTextField:
            pickerViewHelper.updatePickerData(selectedDateString: sipDateTextField.text, pickerDateType: .start)
            
        case endDateTextField:
            pickerViewHelper.updatePickerData(selectedDateString: endDateTextField.text, pickerDateType: .end)
            
        case valueAsOnDateTextField:
            updateDatePickerData()
            
        default: break
        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        sipCalPresenter.underLineTextField(textfield: textField, color: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR))
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        sipCalPresenter.underLineTextField(textfield: textField, color: UIColor.darkGray)
    }
    
    @IBAction func onAdvancedOptionsButtonTap(_ sender: UIButton) {
        advancedOptionsViewHeightConstraint.constant = 128
        advancedOptionsView.isHidden = false
    }
    
    @IBAction func onActionButtonTap(_ sender: UIButton) {
        advancedOptionsViewHeightConstraint.constant = 0
        advancedOptionsView.isHidden = true
    }
    
    func onPickerViewDoneButtonTap(month: Int, year: Int) {
        activeTextField?.text = "\(month)/\(year)"
        activeTextField?.resignFirstResponder()
    }
    
    func onPickerViewCancelButtonTap() {
        activeTextField?.resignFirstResponder()
    }
        
//    func onDateChanged(day: Int, month: Int, year: Int) {
//        valueAsOnDateTextField.text = "\(day)/\(month)/\(year)"
//    }
    
    func onDatePickerDoneButtonTap(day: Int, month: Int, year: Int) {
        valueAsOnDateTextField.text = "\(day)/\(month)/\(year)"
        activeTextField?.resignFirstResponder()
    }
    
    func onDatePickerCancelButtonTap() {
        activeTextField?.resignFirstResponder()
    }
    
    func displayError(anchorView: UITextField, errorMessage: String){
        dropDown.dataSource.removeAll()
        dropDown.dataSource.append(errorMessage)
        sipCalPresenter.setDropDownAnchor(dropDown: dropDown, anchorView: anchorView)
        sipCalPresenter.setDropDownSelectionActions(dropDown: dropDown)
        dropDown.show()
    }
    
    func hideError(){
        dropDown.hide()
    }
    
    @IBAction func onCalculateButtonTap(_ sender: UIButton) {
        guard sipCalPresenter.isSipAmountValid(amountText: sipAmountTextField.text) else {
            displayError(anchorView: sipAmountTextField, errorMessage: "sip_amount_error".localized)
            return
        }
        guard sipCalPresenter.isDateValid(dateText: sipDateTextField.text) && sipCalPresenter.isDateValid(dateText: endDateTextField.text) && sipCalPresenter.isDateValid(dateText: valueAsOnDateTextField.text), sipCalPresenter.isEndDateGreaterThanStartDate(startDateText: sipDateTextField.text, endDateText: endDateTextField.text) else {
            return
        }
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else{
            return
        }
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        let loadingController = alertViewHelper.loadingAlertViewController(title: "Please wait", message: "\n\n")
        self.present(loadingController, animated: true, completion: nil)
        sipCalPresenter.sipOutputData(fundName: fundName, sipAmount: Int(sipAmountTextField.text ?? "0"), startDate: sipDateTextField.text, endDate: endDateTextField.text, vaoDate: valueAsOnDateTextField.text, fundNavData: fundNavData ?? []) { [weak self] (sipOutput) in
            let sipCalDetailsVC = SipCalDetailsViewController(nibName: "SipCalDetailsViewController", bundle: bundle)
            sipCalDetailsVC.sipOutput = sipOutput
            self?.dismiss(animated: false, completion: { [weak self] in
                self?.navigationController?.pushViewController(sipCalDetailsVC, animated: true)
            })
        }
        
    }
}

