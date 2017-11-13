//
//  EditProfileViewController.swift
//  smartsell
//
//  Created by Anurag Dake on 13/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core
import TOCropViewController
import Core

protocol EditProfileProtocol{
    
}

/**
 EditProfileViewController displays user details and gives option to change the details
 */
class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate, UITextFieldDelegate, TextFieldAlertControllerCallbackProtocol{
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var changePhotoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var profilePicView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var signatureView: UIView!
    
    
    var eventHandler : EditProfileProtocol!
    var editProfilePresenter : EditProfilePresenter!
    var userData: UserData?
    var textFieldAlertControllerHelper: TextFieldAlertControllerHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editProfilePresenter = EditProfilePresenter(editProfileViewController: self)
        self.eventHandler = editProfilePresenter
        initialiseView()
    }
    
    func initialiseView(){
        editProfilePresenter.makeViewCircular(view: profilePicImageView)
        editProfilePresenter.addTapListenersToViews()
        editProfilePresenter.showUserData()
        textFieldAlertControllerHelper = TextFieldAlertControllerHelper(textFieldAlertControllerCallbackProtocol: self)
    }
    
    ///UIImagePickerControllerDelegate method
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            editProfilePresenter.presentCropViewController(croppingStyle: .circular, image: selectedImage, imageViewElement: profilePicImageView)
        }
    }
    
    ///TOCropViewControllerDelegate to perform  operation after cropping circular image
    public func cropViewController(_ cropViewController: TOCropViewController, didCropToCircleImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        editProfilePresenter.setCroppedImage(image: image, cropViewController: cropViewController)
    }
    
    /**
     Show popup view to edit text.
     */
    func popupToEditText(title: String?, message: String?, defaultText: String, noOfTextFields: Int = 1) {
        if let alertController = textFieldAlertControllerHelper?.textFieldAlertController(with: title, message: message, defaultText: defaultText, numberOfTextFields: noOfTextFields){
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func newTextValue(newText: String) {
        editProfilePresenter.updateText(newText: newText)
    }
    
    @IBAction func onBackButtonPress(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onHomeTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
