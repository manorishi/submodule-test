//
//  NetworkListenerDelegate.swift
//  Core
//
//  Created by kunal singh on 19/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 The delegate of a ReachabilityManager helps to notify about network connectivity.
 */

import Foundation

@objc
public protocol NetworkListenerDelegate {
    func onConnectionAvailable()
    @objc optional func onConnectionUnavailable()
}
