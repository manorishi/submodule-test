//
//  DatePickerHelper.swift
//  mfadvisor
//
//  Created by Anurag Dake on 12/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

class DatePickerHelper{
    
    weak var delegate: DatePickerValueChangeListener?
    public var datePicker: UIDatePicker!
    public var keyboardToolBar: UIToolbar!
    
    init() {
        initialise()
    }
    
    init(with mode: UIDatePickerMode = .date, date: Date = Date(), minDate: Date? = nil, maxDate: Date? = nil) {
        initialise(with: mode, date: date)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    
    func initialise(with mode: UIDatePickerMode = .date, date: Date = Date()){
        self.datePicker = UIDatePicker()
        datePicker.date = date
        datePicker.datePickerMode = mode
        datePicker.addTarget(self, action: #selector(onDateChanged), for: .valueChanged)
        addKeyboardToolBar()
    }
    
    func updateDatePickerData(date: Date, minDate: Date?, maxDate: Date?){
        datePicker.date = date
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    
    func attach(fields: [UITextField]){
        for textField in fields{
            textField.inputView = datePicker
            textField.inputAccessoryView = keyboardToolBar
        }
    }
    
    func addKeyboardToolBar() {
        keyboardToolBar = UIToolbar(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(datePicker.frame.size.width), height: CGFloat(25)))
        keyboardToolBar.sizeToFit()
        keyboardToolBar.barStyle = .default
        let okButton = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(PickerViewHelper.onDoneTap))
        okButton.tintColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(PickerViewHelper.onCancelTap))
        cancelButton.tintColor = hexStringToUIColor(hex: MFColors.PRIMARY_COLOR)
        keyboardToolBar.items = [cancelButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), okButton]
    }
    
    @objc func onDateChanged(){
        let calender = Calendar.current
        let day = calender.component(.day, from: datePicker.date)
        let month = calender.component(.month, from: datePicker.date)
        let year = calender.component(.year, from: datePicker.date)
        delegate?.onDateChanged?(day: day, month: month, year: year)
//        delegate?.onDateChanged?(date: datePicker.date)
    }
    
    @objc func onDoneTap(){
        let calender = Calendar.current
        let day = calender.component(.day, from: datePicker.date)
        let month = calender.component(.month, from: datePicker.date)
        let year = calender.component(.year, from: datePicker.date)
        delegate?.onDatePickerDoneButtonTap?(day: day, month: month, year: year)
    }
    
    @objc func onCancelTap(){
        delegate?.onDatePickerCancelButtonTap?()
    }

}
