//
//  UIalertViewHelper.swift
//  Poster
//
//  Created by kunal singh on 10/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

/**
 All ActionSheets used in poster will be implemented here
 */
class ActionSheetHelper{
    
    private let CHOOSE_IMAGE = "Choose Image"
    private let CAMERA = "Camera"
    private let GALLERY = "Gallery"
    private let DELETE = "Delete"
    private let CANCEL = "Cancel"
    
    let actionSheetCallbackProtocol: ActionSheetCallbackProtocol
    
    init(actionSheetCallbackProtocol: ActionSheetCallbackProtocol) {
        self.actionSheetCallbackProtocol = actionSheetCallbackProtocol
    }
    
    /**
     ActionSheet AlertController for image source select options
     It will show 3 options camera, gallery and delete
     */
    func actionSheetToChooseImage(isDeleteEnabled: Bool) -> UIAlertController{
        
        let alertController = UIAlertController(title: CHOOSE_IMAGE, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: CAMERA, style: UIAlertActionStyle.default){
            UIAlertAction in
            self.actionSheetCallbackProtocol.cameraButtonPressed()
        }
        
        let gallaryAction = UIAlertAction(title: GALLERY, style: UIAlertActionStyle.default){
            UIAlertAction in
            self.actionSheetCallbackProtocol.galleryButtonPressed()
        }
        
        let deleteAction = UIAlertAction(title: DELETE, style: UIAlertActionStyle.default){
            UIAlertAction in
            self.actionSheetCallbackProtocol.deleteButtonPressed()
        }
        deleteAction.isEnabled = isDeleteEnabled
        
        let cancelAction = UIAlertAction(title: CANCEL, style: UIAlertActionStyle.cancel){
            UIAlertAction in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(gallaryAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }

    
}
