//
//  AlertViewCallbackProtocol.swift
//  Core
//
//  Created by kunal singh on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 The delegate of a AlertViewHelper helps to notify about button click.
 */

import Foundation

@objc
public protocol UIAlertViewCallbackProtocol {
    @objc optional func okButtonPressed()
    @objc optional func cancelButtonPressed()
}
