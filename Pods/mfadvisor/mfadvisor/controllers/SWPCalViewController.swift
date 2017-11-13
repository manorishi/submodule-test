//
//  SWPCalViewController.swift
//  mfadvisor
//
//  Created by Anurag Dake on 03/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core
import DropDown

class SWPCalViewController: UIViewController, UITextFieldDelegate, PickerValueChangeListener, DatePickerValueChangeListener{
    
    @IBOutlet weak var selectedFundNameLabel: UILabel!
    @IBOutlet weak var withdrawlAmountTextField: UITextField!
    @IBOutlet weak var startingCapitalTextField: UITextField!
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var valueAsOnDateTextField: UITextField!
    
    @IBOutlet weak var advancedOptionsView: UIView!
    @IBOutlet weak var advancedOptionsViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var quarterlyButton: UIButton!
    
    private var dropDown = DropDown()
    var swpCalPresenter: SWPCalPresenter!
    var activeTextField: UITextField?
    var swpType = SWPType.monthly
    var bundle: Bundle!
    var fundNavData: [MFNavData]?
    var dates: (startNav: MFNavData?, endNav: MFNavData?)?
    var pickerViewHelper: PickerViewHelper!
    var datePickerHelper: DatePickerHelper!
    public var managedObjectContext:NSManagedObjectContext?
    public var fundId:String!
    public var fundName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swpCalPresenter = SWPCalPresenter()
        bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) ?? Bundle.main
        initialise()
        fetchFundNAVData()
        updateDateData()
        initialisePickerView()
        initialiseDatePicker()
        swpCalPresenter.initialiseDropDown(dropDown: dropDown)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialiseUI()
    }
    
    func initialise(){
        self.navigationController?.navigationBar.isHidden = true
        selectedFundNameLabel.text = fundName ?? ""
        setTextFieldDelegate()
        updateUIOnRadioButtonTap(monthlyImageName: "ic_radio_button_checked", quarterlyImageName: "ic_radio_button_unchecked")
    }
    
    func setTextFieldDelegate(){
        for field in [withdrawlAmountTextField, startingCapitalTextField, valueAsOnDateTextField, startDateTextField, endDateTextField]{
            field?.delegate = self
        }
    }
    
    func initialiseUI(){
        swpCalPresenter.underlineTextFields(textfields: [withdrawlAmountTextField, startingCapitalTextField, valueAsOnDateTextField, startDateTextField, endDateTextField])
    }
    
    func fetchFundNAVData(){
        guard let managedObjContext = managedObjectContext else {
            return
        }
        fundNavData = swpCalPresenter.fundNAVData(fundId: fundId, managedObjectContext: managedObjContext)
    }
    
    func updateDateData(){
        guard let navData = fundNavData else {
            return
        }
        dates = swpCalPresenter.startAndEndDate(navData: navData)
        if let startDate = dates?.startNav{
            startDateTextField.text = "\(startDate.month)/\(startDate.year)"
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
            pickerViewHelper.attach(fields: [startDateTextField, endDateTextField])
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
        case startDateTextField:
            pickerViewHelper.updatePickerData(selectedDateString: startDateTextField.text, pickerDateType: .start)
            
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
        swpCalPresenter.underLineTextField(textfield: textField, color: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR))
    }
    
    @IBAction func onMonthlyButtonTap(_ sender: UIButton) {
        updateUIOnRadioButtonTap(monthlyImageName: "ic_radio_button_checked", quarterlyImageName: "ic_radio_button_unchecked")
        swpType = .monthly
    }
    
    
    @IBAction func onQuarterlyButtonTap(_ sender: UIButton) {
        updateUIOnRadioButtonTap(monthlyImageName: "ic_radio_button_unchecked", quarterlyImageName: "ic_radio_button_checked")
        swpType = .quarterly
    }
    
    private func updateUIOnRadioButtonTap(monthlyImageName: String, quarterlyImageName: String){
        monthlyButton.setImage(UIImage(named: monthlyImageName, in: bundle, compatibleWith: nil), for: .normal)
        quarterlyButton.setImage(UIImage(named: quarterlyImageName, in: bundle, compatibleWith: nil), for: .normal)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        swpCalPresenter.underLineTextField(textfield: textField, color: UIColor.darkGray)
    }
    
    @IBAction func onAdvancedOptionsButtonTap(_ sender: UIButton) {
        advancedOptionsViewHeightConstraint.constant = 128
        advancedOptionsView.isHidden = false
    }
    
    @IBAction func onRemoveButtonTap(_ sender: UIButton) {
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
        swpCalPresenter.setDropDownAnchor(dropDown: dropDown, anchorView: anchorView)
        swpCalPresenter.setDropDownSelectionActions(dropDown: dropDown)
        dropDown.show()
    }
    
    func hideError(){
        dropDown.hide()
    }
    
    @IBAction func onCalculateButtonTap(_ sender: UIButton) {
        guard swpCalPresenter.isStartingCapitalValid(amountText: startingCapitalTextField.text) else {
            displayError(anchorView: startingCapitalTextField, errorMessage: "starting_capital_error".localized)
            return
        }
        guard swpCalPresenter.isWithdrawAmountValid(withDrawAmountText: withdrawlAmountTextField.text, startingCapitalText: startingCapitalTextField.text) else {
            displayError(anchorView: startingCapitalTextField, errorMessage: "withdraw_amount_error".localized)
            return
        }
        guard swpCalPresenter.isDateValid(dateText: startDateTextField.text) && swpCalPresenter.isDateValid(dateText: endDateTextField.text) && swpCalPresenter.isDateValid(dateText: valueAsOnDateTextField.text), swpCalPresenter.isEndDateGreaterThanStartDate(startDateText: startDateTextField.text, endDateText: endDateTextField.text) else {
            return
        }
        
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else{
            return
        }
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        let loadingController = alertViewHelper.loadingAlertViewController(title: "Please wait", message: "\n\n")
        self.present(loadingController, animated: true, completion: nil)
        swpCalPresenter.swpOutputData(fundName: fundName, withDrawAmount: Int(withdrawlAmountTextField.text ?? "0"), startingCapital: Int(startingCapitalTextField.text ?? "0"), startDate: startDateTextField.text, endDate: endDateTextField.text, vaoDate: valueAsOnDateTextField.text, fundNavData: fundNavData ?? [], swpType: swpType) { [weak self] (swpOutput) in
            
            let swpCalDetailsVC = SwpCalDetailsViewController(nibName: "SwpCalDetailsViewController", bundle: bundle)
            swpCalDetailsVC.swpOutput = swpOutput
            self?.dismiss(animated: false, completion: { [weak self] in
                self?.navigationController?.pushViewController(swpCalDetailsVC, animated: true)
            })
        }
    }
}
