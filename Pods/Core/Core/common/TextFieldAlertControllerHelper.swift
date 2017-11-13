//
//  EditTextAlertController.swift
//  smartsell
//
//  Created by Anurag Dake on 15/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

/**
 TextFieldAlertControllerHelper show alert controller with textfields.
 */

import UIKit

public class TextFieldAlertControllerHelper:NSObject, UITextFieldDelegate {
    
    let textFieldAlertControllerCallbackProtocol: TextFieldAlertControllerCallbackProtocol
    let textFieldMaxLenght = 50
    
    public init(textFieldAlertControllerCallbackProtocol: TextFieldAlertControllerCallbackProtocol) {
        self.textFieldAlertControllerCallbackProtocol = textFieldAlertControllerCallbackProtocol
    }
    
    /**
     Create alert controller with textfields
     */
    public func textFieldAlertController(with title:String?, message: String?, defaultText: String = "", numberOfTextFields: Int = 1) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        var signatureTexts = [String]()
        if defaultText.contains("\n") {
            signatureTexts = defaultText.components(separatedBy: "\n")
        }else{
            signatureTexts.append(defaultText)
        }
        
        for i in 0..<numberOfTextFields{
            alertController.addTextField {(textfield) in
                textfield.delegate = self
                textfield.text = numberOfTextFields == 1 ? defaultText : (i < signatureTexts.count ? signatureTexts[i] : "")
            }
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler:{[weak self] (alertAction) in
            var textToReturn = ""
            for i in 0..<numberOfTextFields{
                if let textField = alertController.textFields?[i] {
                    textToReturn += "\(i > 0 ? ";" : "")\(textField.text ?? "")"
                }
            }
            self?.textFieldAlertControllerCallbackProtocol.newTextValue(newText: textToReturn)
        }))
        
        return alertController
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= textFieldMaxLenght
    }
}
