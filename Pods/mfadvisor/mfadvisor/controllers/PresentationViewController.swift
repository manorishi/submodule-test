//
//  PresentationViewController.swift
//  mfadvisor
//
//  Created by Apple on 05/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CoreData
import Core
import DropDown

/**
 PresentationViewController shows option to enter lumpsum/sip values to generate presentaion for the given fund
 It is shown as tab of FundDetailViewController
 */
class PresentationViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var presentationScrollView: UIScrollView!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var investmentTypeTextField: UITextField!
    @IBOutlet weak var investmentAmountTextField: UITextField!
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var createPresentationButton: UIButton!
    
    public var managedObjectContext:NSManagedObjectContext?
    var presentationPresenter: PresentationPresenter!
    
    public var fundId:String!
    public var fundName:String?
    
    var activeTextField: UITextField?
    var investmentTypeDropDown:DropDown? = nil
    let LUMPSUM_INVESTMENT = "Lumpsum"
    let SIP_INVESTMENT = "SIP"
    var errorMessageDropDown:DropDown = DropDown()
    var fundMinInvestmentData:MetaMutualFundMinInvestment? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentationPresenter = PresentationPresenter(presentationViewController: self)
        self.view.backgroundColor = MFColors.VIEW_BACKGROUND_COLOR
        fundNameLabel.text = fundName
        configView()
        getMutualFundInvestmentData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(PresentationViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PresentationViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    func addTapGestureRecogniserToScrollView(){
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnScrollView(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        self.presentationScrollView.addGestureRecognizer(singleTapGesture)
    }
    
    func tappedOnScrollView(_ sender:UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardRect.size.height, 0.0)
            self.presentationScrollView.contentInset = contentInsets
            self.presentationScrollView.scrollIndicatorInsets = contentInsets
            
            if let activeTextField = activeTextField {
                var aRect: CGRect = self.view.frame
                aRect.size.height -= keyboardRect.size.height
                if (!aRect.contains(activeTextField.frame.origin)) {
                    self.presentationScrollView.scrollRectToVisible(activeTextField.frame, animated:true)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.presentationScrollView.contentInset = UIEdgeInsets.zero
        self.presentationScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func getMutualFundInvestmentData() {
        fundMinInvestmentData = presentationPresenter.getMutualFundMinInvestmentData(fundId: fundId, managedObjectContext: managedObjectContext!)
        fillDefaultInvestmentAmount()
        presentationPresenter.updateCreatePresentationButton(investmentAmountTextField: investmentAmountTextField)
    }
    
    func configView() {
        addTapGestureRecogniserToScrollView()
        investmentAmountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        initialiseInvestmentTypeDropDown()
        presentationPresenter.initialiseDropDown(dropDown: errorMessageDropDown)
        presentationPresenter.configView()
        investmentTypeTextField.delegate = self
        investmentAmountTextField.delegate = self
        customerNameTextField.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        presentationPresenter.updateCreatePresentationButton(investmentAmountTextField: investmentAmountTextField)
    }
    
    func initialiseInvestmentTypeDropDown(){
        investmentTypeDropDown  = DropDown()
        investmentTypeDropDown?.dataSource = [LUMPSUM_INVESTMENT, SIP_INVESTMENT]
        //dropDown.width = locationTextField.frame.size.width
        investmentTypeTextField.text = LUMPSUM_INVESTMENT
        investmentTypeDropDown?.direction = .any
        investmentTypeDropDown?.dismissMode = .onTap
        //Set anchor view for dropdown
        investmentTypeDropDown?.anchorView = investmentTypeTextField
        investmentTypeDropDown?.bottomOffset = CGPoint(x: 0, y:(investmentTypeDropDown?.anchorView?.plainView.bounds.height)!)
        investmentTypeDropDown?.topOffset = CGPoint(x: 0, y:-(investmentTypeDropDown?.anchorView?.plainView.bounds.height ?? 0))
        investmentTypeDropDown?.cancelAction = { [] in
            self.investmentTypeDropDown?.hide()
        }
        investmentTypeDropDown?.selectionAction = {[weak self] (index: Int, item: String) in
            self?.investmentTypeTextField.text = item
            self?.fillDefaultInvestmentAmount()
        }
    }
    
    func fillDefaultInvestmentAmount() {
        if investmentTypeTextField.text == LUMPSUM_INVESTMENT {
            investmentAmountTextField.text = "\(String(describing: Int(fundMinInvestmentData?.lumpsum_minimum ?? 0)))"
        }else if investmentTypeTextField.text == SIP_INVESTMENT {
            investmentAmountTextField.text = "\(String(describing: Int(fundMinInvestmentData?.sip_minimum ?? 0)))"
        }
    }
    
    @IBAction func clickedOnCreatePresentation(_ sender: Any) {
        if presentationPresenter.isValidAmount(fundMinInvestmentData: fundMinInvestmentData){
            var mFSelectionItem: MFSelectionItem?
            if let managedObjectCont = managedObjectContext, let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
                mFSelectionItem = presentationPresenter.getMFSelectionItemDataWith(fundId: fundId, managedObjectContext: managedObjectCont, bundle: bundle)
            }
            
            guard let fundItems = mFSelectionItem?.fundItems else {
                return
            }
            let fund1 = fundItems.first
            if investmentTypeTextField.text == LUMPSUM_INVESTMENT {
                fund1?.lumpSum = Double(investmentAmountTextField.text ?? "")
            }
            else if investmentTypeTextField.text == SIP_INVESTMENT {
                fund1?.sip = Float(investmentAmountTextField.text ?? "")
            }
        presentationPresenter.gotoFundPresentation(managedObjectContext: managedObjectContext, mFSelectionItem: mFSelectionItem, customerName: customerNameTextField.text)
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        presentationPresenter.updateCreatePresentationButton(investmentAmountTextField: textField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        presentationPresenter.underLineTextField(textfield: textField, color: hexStringToUIColor(hex: MFColors.PRIMARY_COLOR))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == investmentTypeTextField {
            textField.endEditing(true)
            investmentTypeDropDown?.show()
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        presentationPresenter.underLineTextField(textfield: textField, color: UIColor.darkGray)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == customerNameTextField {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 40
        }
        return true
    }
    
    func displayError(anchorView: UITextField, errorMessage: String){
        presentationPresenter.underLineTextField(textfield: anchorView, color: UIColor.red)
        errorMessageDropDown.dataSource.removeAll()
        errorMessageDropDown.dataSource.append(errorMessage)
        presentationPresenter.setDropDownAnchor(dropDown: errorMessageDropDown, anchorView: anchorView)
        presentationPresenter.setDropDownSelectionActions(dropDown: errorMessageDropDown)
        errorMessageDropDown.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
