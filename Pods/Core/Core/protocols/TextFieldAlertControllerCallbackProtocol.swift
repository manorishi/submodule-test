//
//  EditTextAlertControllerCallbackProtocol.swift
//  smartsell
//
//  Created by Anurag Dake on 15/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

/**
 The delegate of a TextFieldAlertControllerHelper helps to notify about update text.
*/

import Foundation

public protocol TextFieldAlertControllerCallbackProtocol {
    func newTextValue(newText: String)
}
