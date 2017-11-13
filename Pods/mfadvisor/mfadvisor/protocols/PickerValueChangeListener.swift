//
//  PickerValueChangeListener.swift
//  mfadvisor
//
//  Created by Anurag Dake on 06/10/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

@objc protocol PickerValueChangeListener {
    @objc optional func onValueChanged(month: Int, year: Int)
    @objc optional func onPickerViewDoneButtonTap(month: Int, year: Int)
    @objc optional func onPickerViewCancelButtonTap()
}
