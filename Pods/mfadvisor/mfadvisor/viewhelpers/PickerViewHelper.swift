//
//  PickerViewHelper.swift
//  mfadvisor
//
//  Created by Anurag Dake on 06/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

class PickerViewHelper: NSObject, UIPickerViewDelegate, UIPickerViewDataSource{
    
    weak var delegate: PickerValueChangeListener?
    public var pickerView: UIPickerView!
    public var keyboardToolBar: UIToolbar!
    public var pickerDateType = PickerDateType.start
    
    public var months: [Int]!
    public var years: [Int]!
    public var startDate: (Int, Int)!
    public var endDate: (Int, Int)!
    
    init(startDate: (Int, Int), endDate: (Int, Int)) {
        super.init()
        initialise(startDate: startDate, endDate: endDate)
    }
    
    func initialise(startDate: (Int, Int), endDate: (Int, Int)){
        months = []
        years = []
        self.startDate = startDate
        self.endDate = endDate
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        addKeyboardToolBar()
    }
    
    func attach(fields: [UITextField]){
        for textField in fields{
            textField.inputView = pickerView
            textField.inputAccessoryView = keyboardToolBar
        }
    }
    
    func addKeyboardToolBar() {
        keyboardToolBar = UIToolbar(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(pickerView.frame.size.width), height: CGFloat(25)))
        keyboardToolBar.sizeToFit()
        keyboardToolBar.barStyle = .default
        let okButton = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(PickerViewHelper.onDoneTap))
        okButton.tintColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(PickerViewHelper.onCancelTap))
        cancelButton.tintColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
        keyboardToolBar.items = [cancelButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), okButton]
    }
    
    func updatePickerData(selectedDateString: String?, pickerDateType: PickerDateType){
        self.pickerDateType = pickerDateType
        guard let selectedDate = selectedDateString else {
            return
        }
        let years = Array(getStartYear()...endDate.1)
        var months = Array(1...12)
        
        let components = selectedDate.components(separatedBy: "/")
        if components.count == 2{
            let year = Int(components[1]) ?? 0
            if year == years.last{
                months = Array(1...getEndMonth())
            }else if year == years.first{
                months = Array(getStartMonth()...12)
            }
        }
        
        self.months.removeAll()
        self.years.removeAll()
        self.months.append(contentsOf: months)
        self.years.append(contentsOf: years)
        self.pickerView.reloadAllComponents()
        
        if components.count == 2{
            let month = Int(components[0]) ?? 0
            if let monthIndex = self.months.index(of: month){
                pickerView.selectRow(monthIndex, inComponent: 0, animated: false)
            }
            let year = Int(components[1]) ?? 0
            if let yearIndex = self.years.index(of: year){
                pickerView.selectRow(yearIndex, inComponent: 1, animated: false)
            }
        }
    }
    
    func onYearUpdate(newYear: Int, newMonth: Int){
        if newYear == years.last{
            months = Array(1...getEndMonth())
        }else if newYear == years.first{
            months = Array(getStartMonth()...12)
        }else{
            months = Array(1...12)
        }
        pickerView.reloadComponent(0)
        if months.contains(newMonth){
            if let monthIndex = self.months.index(of: newMonth){
                pickerView.selectRow(monthIndex, inComponent: 0, animated: false)
            }
        }
    }
    
    func getStartMonth() -> Int{
        switch pickerDateType {
        case .start: return startDate.0
        case .end: return startDate.0 == 12 ? 1 : (startDate.0 + 1)
        }
    }
    
    func getEndMonth() -> Int{
        switch pickerDateType {
        case .start: return endDate.0 == 0 ? 12 : (endDate.0 - 1)
        case .end: return endDate.0
        }
    }
    
    func getStartYear() -> Int{
        switch pickerDateType {
        case .start: return startDate.1
        case .end: return startDate.0 == 12 ? (startDate.1 + 1) : startDate.1
        }
    }
    
    @objc func onDoneTap(){
        let year = years[pickerView.selectedRow(inComponent: 1)]
        let month = months[pickerView.selectedRow(inComponent: 0)]
        delegate?.onPickerViewDoneButtonTap?(month: month, year: year)
    }
    
    @objc func onCancelTap(){
        delegate?.onPickerViewCancelButtonTap?()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return months.count
        case 1: return years.count
        default: return 0
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return monthName(monthNumber: months[row])
        case 1: return String(years[row])
        default: return ""
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = years[pickerView.selectedRow(inComponent: 1)]
        let month = months[pickerView.selectedRow(inComponent: 0)]
        if component == 1{
            onYearUpdate(newYear: year, newMonth: month)
        }
//        delegate?.onValueChanged?(month: month, year: year)
    }
    
    public func monthName(monthNumber: Int) -> String?{
        guard monthNumber > 0 && monthNumber < 13 else {
            return nil
        }
        let monthDict = [ 1 : "Jan", 2 : "Feb", 3 : "Mar", 4 : "Apr", 5 : "May", 6 : "Jun", 7 : "Jul", 8 : "Aug", 9 : "Sep", 10 : "Oct", 11 : "Nov", 12 : "Dec"]
        return monthDict[monthNumber]
    }
    
}
