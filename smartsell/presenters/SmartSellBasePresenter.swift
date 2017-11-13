//
//  BasePresenter.swift
//  smartsell
//
//  Created by Anurag Dake on 04/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

class SmartSellBasePresenter{
    
    func buttonState(button: UIButton, isEnabled: Bool){
        button.isEnabled = isEnabled
        button.layer.cornerRadius = 4
        button.layer.borderWidth = isEnabled ? 0 : 2
        button.layer.borderColor = hexStringToUIColor(hex: Colors.LIGHT_GREY).cgColor
        button.backgroundColor = isEnabled ? hexStringToUIColor(hex: Colors.COLOR_PRIMARY) : UIColor.white
        button.setTitleColor(isEnabled ? UIColor.white : hexStringToUIColor(hex: Colors.LIGHT_GREY), for: .normal)
    }
    
    func showAlertMessage(title: String?, message:String?) {
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        alertViewHelper.showAlertView(title: title ?? "", message: message ?? "error_message".localized , cancelButtonTitle: "ok".localized)
    }
}
