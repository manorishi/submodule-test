//
//  DatePickerValueChangeListener.swift
//  mfadvisor
//
//  Created by Anurag Dake on 12/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

@objc protocol DatePickerValueChangeListener {
//    @objc optional func onDateChanged(date: Date)
    @objc optional func onDateChanged(day: Int, month: Int, year: Int)
    @objc optional func onDatePickerDoneButtonTap(day: Int, month: Int, year: Int)
    @objc optional func onDatePickerCancelButtonTap()
}
