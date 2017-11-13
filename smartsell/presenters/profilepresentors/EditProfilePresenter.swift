//
//  EditProfilePresenter.swift
//  smartsell
//
//  Created by Anurag Dake on 13/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import TOCropViewController
import Core

enum ImagePickerType {
    case camera
    case gallery
}

/**
 EditProfilePresenter handle UI logic for EditProfileViewController such as showing alert to update data
 */
class EditProfilePresenter: EditProfileProtocol {
    
    weak var editProfileViewController: EditProfileViewController!
    var editProfileInteractor: EditProfileInteractor!
    var imagePicker = UIImagePickerController()
    var isProfileImageAvailable = false
    var selectedLabel: UILabel?
    
    private let profileImagePlaceholder = "ic_profile_picutre_placeholder"
    
    init(editProfileViewController: EditProfileViewController) {
        self.editProfileViewController = editProfileViewController
        editProfileInteractor = EditProfileInteractor()
    }
    
    func makeViewCircular(view: UIView){
        editProfileViewController.view.layoutIfNeeded()
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
    }
    
    /**
     Set User data on ui elements
     */
    func showUserData(){
        if let userData = editProfileViewController.userData{
            editProfileViewController.nameLabel.text = userData.name ?? ""
            editProfileViewController.emailLabel.text = userData.emailId ?? ""
            editProfileViewController.signatureLabel.text = userData.signatureInDisplayFormat()
            if let profileImage = editProfileInteractor.retrieveImage(fileName: userData.profileImageName()){
                editProfileViewController.profilePicImageView.image = profileImage
                isProfileImageAvailable = true
            }else{
                editProfileViewController.profilePicImageView.image = UIImage(named: profileImagePlaceholder)
            }
            updateChangePhotoLabelText()
        }
    }
    
    func updateChangePhotoLabelText(){
        if isProfileImageAvailable{
            editProfileViewController.changePhotoLabel.text = "change_photo".localized
        }else{
            editProfileViewController.changePhotoLabel.text = "add_photo".localized
        }
    }
    
    /**
     Add tap listernes on views in edit profile page
     */
    func addTapListenersToViews(){
        editProfileViewController.profilePicView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProfilePicViewTap)))
        editProfileViewController.nameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onNameViewTap)))
        editProfileViewController.emailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onEmailViewTap)))
        editProfileViewController.signatureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSignatureViewTap)))
    }
    
    @objc private func onProfilePicViewTap(){
        showActionSheetToChooseImage(isDeleteEnabled: isProfileImageAvailable)
    }
    
    @objc private func onNameViewTap(){
        selectedLabel = editProfileViewController.nameLabel
        editProfileViewController.popupToEditText(title: "enter_name".localized, message: "", defaultText: editProfileViewController.nameLabel.text ?? "")
    }
    
    @objc private func onEmailViewTap(){
        selectedLabel = editProfileViewController.emailLabel
        editProfileViewController.popupToEditText(title: "enter_email".localized, message: "", defaultText: editProfileViewController.emailLabel.text ?? "")
    }
    
    @objc private func onSignatureViewTap(){
        selectedLabel = editProfileViewController.signatureLabel
        editProfileViewController.popupToEditText(title: "enter_signature".localized, message: "", defaultText: editProfileViewController.signatureLabel.text ?? "", noOfTextFields: 4)
    }
    
    
    
    func updateText(newText: String){
        let isEmpty = newText.characters.count == 0 ? true : false
        
        if selectedLabel != nil{
            switch selectedLabel! {
            case editProfileViewController.nameLabel:
                if isEmpty{
                    Toast(with: "name_cannot_empty".localized).show()
                    onNameViewTap()
                }else{
                    editProfileViewController.userData?.name = newText
                    selectedLabel?.text = newText
                    editProfileInteractor.update(name: newText, completionHandler: { (responseStatus, response) in
                        DispatchQueue.main.async {
                            switch responseStatus{
                            case .forbidden:
                                (UIApplication.shared.delegate as? AppDelegate)?.gotoLoginController()
                                
                            default: break
                            }
                        }
                    })
                }
                
            case editProfileViewController.emailLabel:
                if isEmpty{
                    Toast(with: "email_cannot_empty".localized).show()
                    onEmailViewTap()
                }else{
                    editProfileViewController.userData?.emailId = newText
                    selectedLabel?.text = newText
                    editProfileInteractor.update(emailID: newText, completionHandler: { (responseStatus, response) in
                        DispatchQueue.main.async {
                            switch responseStatus{
                            case .forbidden:
                                (UIApplication.shared.delegate as? AppDelegate)?.gotoLoginController()
                                
                            default: break
                            }
                        }
                    })
                }
                
            case editProfileViewController.signatureLabel:
                editProfileViewController.userData?.signature = newText
                selectedLabel?.text = editProfileViewController.userData?.signatureInDisplayFormat()
                editProfileInteractor.update(signature: newText, completionHandler:  { (responseStatus, response) in
                    DispatchQueue.main.async {
                        switch responseStatus{
                        case .forbidden:
                            (UIApplication.shared.delegate as? AppDelegate)?.gotoLoginController()
                            
                        default: break
                        }
                    }
                })
                
            default: break
            }
        }
        
    }
    
    
    func showActionSheetToChooseImage(isDeleteEnabled: Bool){
        
        let alertController = UIAlertController(title: "choose_image".localized, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "camera".localized, style: UIAlertActionStyle.default){
            UIAlertAction in
            self.cameraButtonPressed()
        }
        
        let gallaryAction = UIAlertAction(title: "gallery".localized, style: UIAlertActionStyle.default){
            UIAlertAction in
            self.galleryButtonPressed()
        }
        
        let deleteAction = UIAlertAction(title: "delete".localized, style: UIAlertActionStyle.default){
            UIAlertAction in
            self.deleteButtonPressed()
        }
        deleteAction.isEnabled = isDeleteEnabled
        
        let cancelAction = UIAlertAction(title: "cancel".localized, style: UIAlertActionStyle.cancel){
            UIAlertAction in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(gallaryAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        editProfileViewController.present(alertController, animated: true, completion: nil)
    }

    /**
     Camera button from action sheet selected
     */
    func cameraButtonPressed() {
        openImagePicker(imagePickerType: .camera)
    }
    
    /**
     Gallery button from action sheet selected
     */
    func galleryButtonPressed() {
        openImagePicker(imagePickerType: .gallery)
    }
    
    /**
     Remove image from selected image element
     */
    func deleteButtonPressed() {
        editProfileViewController.profilePicImageView.image = UIImage(named: profileImagePlaceholder)
        editProfileViewController.profilePicImageView.contentMode = .scaleAspectFit
        isProfileImageAvailable = false
        updateChangePhotoLabelText()
        if let userData = editProfileViewController.userData{
            editProfileInteractor.deleteImage(fileName: userData.profileImageName())
        }
    }
    
    /**
     Open ImagePicker to select image from camera or gallery
     */
    private func openImagePicker(imagePickerType: ImagePickerType){
        imagePicker.delegate = editProfileViewController
        imagePicker.allowsEditing = false
        
        switch imagePickerType {
        case .camera:
            imagePicker.sourceType = .camera;
        case .gallery:
            imagePicker.sourceType = .savedPhotosAlbum;
        }
        editProfileViewController.present(imagePicker, animated: false, completion: nil)
    }
    
    /**
     Present crop view controller once you get screen from camera and gallery
     */
    func presentCropViewController(croppingStyle: TOCropViewCroppingStyle, image: UIImage, imageViewElement: UIImageView?){
        let cropViewController = TOCropViewController(croppingStyle: croppingStyle, image: image)
        cropViewController.delegate = editProfileViewController
        cropViewController.toolbar.rotateClockwiseButtonHidden = true
        cropViewController.toolbar.rotateCounterclockwiseButtonHidden = true
        cropViewController.toolbar.clampButtonHidden = true
        cropViewController.toolbar.resetButton.isHidden = true
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.cropView.aspectRatioLockEnabled = true
        cropViewController.cropView.aspectRatio = CGSize(width: 1, height: 1)
        editProfileViewController.present(cropViewController, animated: true, completion: nil)
    }
    
    /**
     Set cropped image to selected image element
     */
    func setCroppedImage(image: UIImage, cropViewController: TOCropViewController){
        editProfileViewController.profilePicImageView.image = image
        cropViewController.dismiss(animated: false, completion: nil)
        guard let userData = editProfileViewController.userData else{
            return
        }
        isProfileImageAvailable = true
        editProfileInteractor.replaceImageFromGallery(with: image, fileName: userData.profileImageName())
        editProfileInteractor.upload(image: image, completionHandler: {(responseStatus, response) in
            DispatchQueue.main.async {
                switch responseStatus{
                case .forbidden:
                    (UIApplication.shared.delegate as? AppDelegate)?.gotoLoginController()
                    
                default: break
                }
            }
        })
        updateChangePhotoLabelText()
    }
}
