//
//  PosterPresenter.swift
//  Poster
//
//  Created by Anurag Dake on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 PosterPresenter is used for Poster UI logic like adding poster editable text, image and signature elements.
 */

import Foundation
import CoreData
import Core
import TOCropViewController

enum ImagePickerType {
    case camera
    case gallery
}

class PosterPresenter:PosterProtocol {
    
    private let TEXT_ELEMENT_PLACEHOLDER = "You can add text here"
    private let NO_EDITABLE_ERROR_MSG = "No editable items for this poster"
    let IMAGE_ELEMENT_PLACEHOLDER = "ic_image_element_placeholder"
    private let signatureTextKey = "#signature#"
    let signatureTag = 3050
    
    weak var posterViewController: PosterViewController!
    var posterInteractor: PosterInteractor!
    var imagePicker = UIImagePickerController()
    var signatureProfileImageView:UIImageView? = nil
    
    init(posterViewController: PosterViewController) {
        self.posterViewController = posterViewController
        posterInteractor = PosterInteractor()
    }
    
    func postersImageElementsData(posterId: Int32, managedObjectContext: NSManagedObjectContext) -> [PosterImageElementModel]{
        return posterInteractor.postersImageElementsData(posterId: posterId, managedObjectContext: managedObjectContext)
    }
    
    func postersTextElementsData(posterId: Int32, managedObjectContext: NSManagedObjectContext) -> [PosterTextElementModel]{
        return posterInteractor.postersTextElementsData(posterId: posterId, managedObjectContext: managedObjectContext)
        
    }
    
    /**
     Configure view in controller like adjust poster image container view size according to device
     */
    func configView() {
        posterViewController.edgesForExtendedLayout = []
        posterViewController.doneButton.isHidden = true
        posterViewController.posterImageView.isUserInteractionEnabled = true
        posterViewController.posterImageView.clipsToBounds = true
        
        let padding:CGFloat = 8
        posterViewController.imageContainerView.frame.origin.y = posterViewController.headerView.frame.origin.y + posterViewController.headerView.frame.size.height + padding
        posterViewController.imageContainerView.frame.origin.x = padding
        posterViewController.imageContainerView.frame.size.width = UIScreen.main.bounds.width - (2 * padding)
        posterViewController.imageContainerView.frame.size.height = UIScreen.main.bounds.height - (posterViewController.headerView.frame.size.height + posterViewController.editShareContainerView.frame.size.height + 2 * padding + UIApplication.shared.statusBarFrame.height)
        if posterViewController.isConfidential{
            posterViewController.shareButton.isHidden = true
            posterViewController.editButton.isHidden = true
            posterViewController.imageContainerView.frame.origin.y = posterViewController.headerView.frame.origin.y + posterViewController.headerView.frame.size.height + padding + 20
        }
    }
    
    /**
     Get poster image from disk
     */
    func posterImageFromDisk() -> UIImage? {
        
        return AssetDownloaderService.sharedInstance.coreImageDownloader.retrieveImageFromDisk(filename: posterViewController.baseModel?.assetFileName ?? "")
    }
    
    /**
     Scales an image to fit within a bounds within passed new size. Also keeps the aspect ratio.
     */
    func scaleImageToSize(originalImageSize:CGSize, newSize: CGSize) -> CGSize {
        var scaledImageRect = CGRect.zero
        let aspectWidth = newSize.width/originalImageSize.width
        let aspectheight = newSize.height/originalImageSize.height
        let aspectRatio = min(aspectWidth, aspectheight)
        scaledImageRect.size.width = originalImageSize.width * aspectRatio;
        scaledImageRect.size.height = originalImageSize.height * aspectRatio;
        return scaledImageRect.size
    }
    
    /**
     Add both circle and rectangle image elements to poster image.
     */
    func addImageElements() {
        for imageData in posterViewController.imageElementsDataArray {
            switch imageData.shape ?? .rectangle {
            case ElementShapes.circle:
                addCircleImage(imageData: imageData)
            case ElementShapes.rectangle:
                addRectImage(imageData: imageData)
            }
        }
    }
    
    /**
     Add circle image elements to poster image.
     */
    func addCircleImage(imageData:PosterImageElementModel) {
        let imageView = imageElement(imageData: imageData)
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.tag = ElementShapes.circle.rawValue
        posterViewController.posterImageView.addSubview(imageView)
    }
    
    /**
     Add rectangle image elements to poster image.
     */
    func addRectImage(imageData:PosterImageElementModel) {
        let imageView = imageElement(imageData: imageData)
        imageView.layer.cornerRadius = 8
        imageView.tag = ElementShapes.rectangle.rawValue
        posterViewController.posterImageView.addSubview(imageView)
    }
    
    /**
     Calculate image element frame in poster and create UIImageView with that frame.
     
     - parameter imageData: Contains image element data.
     
     - returns: UIImageView
     */
    func imageElement(imageData:PosterImageElementModel) -> UIImageView {
        let leftMarginPercent = CGFloat(imageData.leftMargin) / posterViewController.imageRefSize.width
        let topMarginPercent = CGFloat(imageData.topMargin) / posterViewController.imageRefSize.height
        let heightPercent = CGFloat(imageData.height) / posterViewController.imageRefSize.height
        let widthPercent = CGFloat(imageData.width) / posterViewController.imageRefSize.width
        let posterSize = posterViewController.posterImageView.frame.size
        
        let imageView = UIImageView(frame: CGRect(x: leftMarginPercent * posterSize.width, y: topMarginPercent * posterSize.height , width: widthPercent * posterSize.width, height: heightPercent * posterSize.height))
        imageView.clipsToBounds = true
        imageView.accessibilityLabel = posterViewController.IMAGE_PLACEHOLDER_KEY
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.addGestureRecognizer(tapGestureRecogniser(target: posterViewController, action: #selector(PosterViewController.imageElementTappedToEdit(gesture:))))
        posterViewController.imageElementsReference.append(imageView)
        return imageView
    }
    
    /**
     Create single tap gesture and return it instance.
     */
    func tapGestureRecogniser(target: Any, action: Selector) -> UITapGestureRecognizer{
        let singleTapGesture = UITapGestureRecognizer(target: target, action: action)
        singleTapGesture.numberOfTapsRequired = 1
        return singleTapGesture
    }
    
    /**
     Add all text elements to poster image.
     */
    func addTextElements() {
        for textElementData in posterViewController.textElementsDataArray {
            if textElementData.defaultText?.localizedCaseInsensitiveCompare(signatureTextKey) == .orderedSame {
                addSignature(textElementData: textElementData)
            }
            else {
                posterViewController.posterImageView.addSubview(textElement(textElementData: textElementData))
            }
        }
    }
    
    func stringWidthWithConstrainedHeight(string:String, _ height: CGFloat, font: UIFont, options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let boundingBox = string.boundingRect(with: constraintRect, options: options, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }
    
    /**
     Make signature element editable.
     */
    func makeSignatureEditable() {
        if let signatureView = posterViewController.posterImageView.viewWithTag(signatureTag) {
            signatureView.layer.borderWidth = 1.5
            signatureView.isUserInteractionEnabled = true
            signatureView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            guard let profileImageView = signatureProfileImageView else {
                return
            }
            if profileImageView.accessibilityLabel == posterViewController.IMAGE_PLACEHOLDER_KEY {
                let imageHeight = Int(0.13 * posterViewController.posterImageView.frame.size.height)
                profileImageView.frame.size = CGSize(width: imageHeight, height: imageHeight)
                profileImageView.image = UIImage(named: IMAGE_ELEMENT_PLACEHOLDER, in: posterViewController.loadResourceBundle(coder: posterViewController.classForCoder), compatibleWith: nil)
                profileImageView.contentMode = .center
            }
            adjustSignatureHorizontally(signatureView: signatureView)
        }
    }
    
    /**
     Make signature element uneditable.
     */
    func makeSignatureUneditable() {
        if let signatureView = posterViewController.posterImageView.viewWithTag(signatureTag) {
            signatureView.layer.borderWidth = 0
            signatureView.isUserInteractionEnabled = false
            signatureView.backgroundColor = UIColor.clear
            guard let profileImageView = signatureProfileImageView else {
                return
            }
            if profileImageView.accessibilityLabel == posterViewController.IMAGE_PLACEHOLDER_KEY {
                profileImageView.image = nil
                profileImageView.frame.size = CGSize.zero
                profileImageView.contentMode = .scaleToFill
            }
            signatureTextAlignment(view: signatureView)
            adjustSignatureHorizontally(signatureView: signatureView)
        }
    }
    
    func updateSignature(stringArray:[String]) {
        if let signatureView = posterViewController.posterImageView.viewWithTag(signatureTag) {
            for (index,subview) in signatureView.subviews.enumerated()  {
                if let labelView = subview as? UILabel {
                    if stringArray.count > index {
                        labelView.text = stringArray[index]
                    }
                    else{
                        labelView.text = ""
                    }
                }
            }
            adjustSignatureHorizontally(signatureView: signatureView)
        }
    }
    
    @objc func signatureTappedToEdit(gesture:UIGestureRecognizer) {
        if let signatureView = gesture.view {
            
            var signature = ""
            for subview in  signatureView.subviews {
                if let labelView = subview as? UILabel {
                    signature += labelView.text ?? ""
                    signature += "\n"
                }
            }
            posterViewController.popupToEditText(title: "Edit Signature", message: "", defaultText: signature, noOfTextFields: 4)
        }
    }
    
    /**
     Add signature element to poster.
     */
    func addSignature(textElementData:PosterTextElementModel) {
        if let userData = KeyChainService.sharedInstance.getData(key: ConfigKeys.USER_DATA_KEY){
            if let userDataObj = NSKeyedUnarchiver.unarchiveObject(with: userData ) as? UserData {
                let containerView = UIView(frame: CGRect.zero)
                containerView.clipsToBounds = true
                containerView.layer.cornerRadius = 8
                containerView.layer.borderColor = UIColor.black.cgColor
                containerView.tag = signatureTag
                
                containerView.addGestureRecognizer(tapGestureRecogniser(target: self, action: #selector(signatureTappedToEdit(gesture:))))
                
                let textLabelHeight:Int = Int(0.04 * posterViewController.posterImageView.frame.size.height)
                let horizontalPadding = 2
                let defaultLabelWidth:CGFloat = 40
                let line1 = UILabel(frame: CGRect(x: horizontalPadding, y: 0, width: Int(defaultLabelWidth), height: textLabelHeight))
                let line2 = UILabel(frame: CGRect(x: horizontalPadding, y: Int(line1.frame.origin.y + line1.frame.size.height), width: Int(defaultLabelWidth), height: textLabelHeight))
                let line3 = UILabel(frame: CGRect(x: horizontalPadding, y: Int(line2.frame.origin.y + line2.frame.size.height), width: Int(defaultLabelWidth), height: textLabelHeight))
                let line4 = UILabel(frame: CGRect(x: horizontalPadding, y: Int(line3.frame.origin.y + line3.frame.size.height), width: Int(defaultLabelWidth), height: textLabelHeight))
                containerView.addSubview(line1)
                containerView.addSubview(line2)
                containerView.addSubview(line3)
                containerView.addSubview(line4)
                containerView.frame.size.height = CGFloat(4 * textLabelHeight)
                containerView.frame.origin.y = posterViewController.posterImageView.frame.size.height - (containerView.frame.size.height + 4)
                let signatureArray = userDataObj.signature?.components(separatedBy: ";")
                line1.text = signatureArray?[0] ?? ""
                line2.text = signatureArray?[1] ?? ""
                line3.text = signatureArray?[2] ?? ""
                line4.text = signatureArray?[3] ?? ""
                configSignatureText(view: containerView, textElementData: textElementData)
                
                let profileImageView = UIImageView(frame: CGRect.zero)
                profileImageView.addGestureRecognizer(tapGestureRecogniser(target: posterViewController, action: #selector(PosterViewController.imageElementTappedToEdit(gesture:))))
                signatureProfileImageView = profileImageView
                posterViewController.posterImageView.addSubview(profileImageView)
                let imageHeight = Int(0.13 * posterViewController.posterImageView.frame.size.height)
                profileImageView.frame.size = CGSize(width: imageHeight, height: imageHeight)
                profileImageView.center.y = containerView.center.y
                configSignatureImage(profileImageView: profileImageView)
                if let profileImage = AssetDownloaderService.sharedInstance.coreImageDownloader.retrieveImageFromDisk(filename: userDataObj.profileImageName()){
                    profileImageView.image = profileImage
                    profileImageView.accessibilityLabel = nil
                }
                else{
                    profileImageView.accessibilityLabel = posterViewController.IMAGE_PLACEHOLDER_KEY
                    profileImageView.frame.size = CGSize.zero
                }
                signatureTextAlignment(view: containerView)
                adjustSignatureHorizontally(signatureView: containerView)
                posterViewController.posterImageView.addSubview(containerView)
            }
        }
    }
    
    func adjustSignatureHorizontally(signatureView:UIView?) {
        var containerView:UIView? = signatureView
        if containerView == nil {
            containerView = posterViewController.posterImageView.viewWithTag(signatureTag)
        }
        if let profileImageView = signatureProfileImageView {
            if containerView == nil {
                return
            }
            
            let horizontalPadding = 2
            let defaultLabelWidth:CGFloat = 40
            
            
            let availableWidth = posterViewController.posterImageView.frame.size.width - (profileImageView.frame.size.width + CGFloat(3 * horizontalPadding + 2))
            let maxLabelWidth = maxStringWidth(view: containerView ?? UIView())
            if maxLabelWidth > availableWidth {
                updateSignatureLabelWidth(view: containerView!, width: availableWidth)
                containerView!.frame.size.width = availableWidth + CGFloat(2 * horizontalPadding)
            }
            else {
                let labelWidth = maxLabelWidth < defaultLabelWidth ? defaultLabelWidth : maxLabelWidth
                updateSignatureLabelWidth(view: containerView!, width: labelWidth)
                containerView!.frame.size.width = labelWidth  + CGFloat(2 * horizontalPadding)
            }
            containerView!.center.x = (posterViewController.posterImageView.frame.width / 2) + profileImageView.frame.size.width / 2 + 2
            profileImageView.frame.origin.x = containerView!.frame.origin.x - (profileImageView.frame.size.width + 2)
        }
    }
    
    func configSignatureImage(profileImageView:UIImageView) {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.tag = ElementShapes.circle.rawValue
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.black.cgColor
        //profileImageView.isUserInteractionEnabled = true
        posterViewController.imageElementsReference.append(profileImageView)
    }
    
    func updateSignatureLabelWidth(view:UIView, width:CGFloat) {
        for subview in view.subviews  {
            if let labelView = subview as? UILabel {
                labelView.frame.size.width = width
            }
        }
    }
    
    func updateSignatureLabelOriginX(view:UIView, originX:CGFloat) {
        for subview in view.subviews  {
            if let labelView = subview as? UILabel {
                labelView.frame.origin.x = originX
            }
        }
    }
    
    func maxStringWidth(view:UIView) -> CGFloat {
        var stringMaxWidth:CGFloat = 0
        for subview in view.subviews  {
            if let labelView = subview as? UILabel {
                let tempTextWidth = stringWidthWithConstrainedHeight(string: labelView.text ?? "", labelView.frame.size.height , font: labelView.font)
                if tempTextWidth > stringMaxWidth {
                    stringMaxWidth = tempTextWidth
                }
            }
        }
        return stringMaxWidth
    }
    
    func configSignatureText(view:UIView, textElementData:PosterTextElementModel) {
        for subview in view.subviews  {
            if let labelView = subview as? UILabel {
                labelView.numberOfLines = 1
                labelView.font = textElementFont(fontName: textElementData.fontFamily, fontSize: textElementData.fontSize)
                labelView.textColor = hexStringToUIColor(hex: textElementData.fontColor ?? "000000")
                labelView.clipsToBounds = true
                labelView.backgroundColor = UIColor.clear
            }
        }
    }
    
    func signatureTextAlignment(view:UIView) {
        var textAlignment:NSTextAlignment = .left
        if signatureProfileImageView?.accessibilityLabel == posterViewController.IMAGE_PLACEHOLDER_KEY {
            textAlignment = .center
        }
        for subview in view.subviews  {
            if let labelView = subview as? UILabel {
                labelView.textAlignment = textAlignment
            }
        }
    }
    
    /**
     Calculate text element frame and create UILabel instance and configure it.
     
     @return Returns UILabel instance.
     */
    func textElement(textElementData:PosterTextElementModel) -> UILabel {
        let posterSize = posterViewController.posterImageView.frame.size
        let leftMargin = (CGFloat(textElementData.leftMargin) / posterViewController.imageRefSize.width) * posterSize.width
        let topMargin = (CGFloat(textElementData.topMargin) / posterViewController.imageRefSize.height) * posterSize.height
        let rightMargin = (CGFloat(textElementData.rightMargin) / posterViewController.imageRefSize.width) * posterSize.width
        let labelWidth = posterSize.width - (leftMargin + rightMargin)
        
        let textLabel = UILabel(frame: CGRect(x: leftMargin, y: topMargin , width: labelWidth, height:20))
        textLabel.numberOfLines = 0
        textLabel.textAlignment = textElementAlignment(textAlignment: textElementData.textAlignment)
        if textElementData.onByDefault {
            textLabel.text = textElementData.defaultText
        }
        textLabel.font = textElementFont(fontName: textElementData.fontFamily, fontSize: textElementData.fontSize)
        updateTextElementHeight(textLabel: textLabel)
        textLabel.layer.cornerRadius = 8
        textLabel.clipsToBounds = true
        textLabel.layer.borderColor = UIColor.black.cgColor
        textLabel.textColor = hexStringToUIColor(hex: textElementData.fontColor!)
        textLabel.highlightedTextColor = hexStringToUIColor(hex: textElementData.fontColor ?? "000000")
        
        textLabel.addGestureRecognizer(tapGestureRecogniser(target: self, action: #selector(textElementTappedToEdit(gesture:))))
        posterViewController.textElementsReference.append(textLabel)
        return textLabel
    }
    
    /**
     Returns Text element font. If specified font is not found in system the return system default font.
     */
    func textElementFont(fontName:String?,fontSize:Int16) -> UIFont{
        if let fontNameString = fontName {
            let fontFamilyNames = UIFont.familyNames
            
            for familyName in fontFamilyNames {
                let names = UIFont.fontNames(forFamilyName: familyName )
                if familyName.caseInsensitiveCompare(fontNameString) == .orderedSame {
                    if let fontName = names.first {
                        return UIFont(name: fontName, size: CGFloat(fontSize)) ?? UIFont.systemFont(ofSize: CGFloat(fontSize))
                    }
                }
                /*if names.contains(where: {$0.caseInsensitiveCompare(fontNameString) == .orderedSame}) {
                 return UIFont(name: fontNameString, size: CGFloat(fontSize)) ?? UIFont.systemFont(ofSize: CGFloat(fontSize))
                 }*/
            }
        }
        return UIFont.systemFont(ofSize: CGFloat(fontSize))
    }
    
    /**
     Update text label height according to its text length and font.
     */
    func updateTextElementHeight(textLabel:UILabel) {
        let labelHeight = textLabel.text?.heightWithConstrainedWidth(textLabel.frame.size.width, font: textLabel.font)
        textLabel.frame.size.height = (labelHeight ?? 20) + 8
    }
    
    /**
     Called when tapped on text element.
     */
    @objc func textElementTappedToEdit(gesture:UIGestureRecognizer) {
        if let label = gesture.view as? UILabel {
            popupToEditText(textLabel: label)
        }
    }
    
    /**
     Update text label message and update its label height. If message passed is nil then set placeholder text.
     */
    func updateTextElementMessage(textLabel:UILabel, message:String?) {
        
        if message == nil || (message?.isEmpty ?? true){
            textLabel.tag = 1
            textLabel.text = TEXT_ELEMENT_PLACEHOLDER
            textLabel.textColor = UIColor.lightGray
        }
        else {
            textLabel.tag = 0
            textLabel.text = message!
            textLabel.textColor = textLabel.highlightedTextColor
        }
        
        updateTextElementHeight(textLabel: textLabel)
    }
    
    /**
     Show popup view to edit text.
     */
    func popupToEditText(textLabel:UILabel) {
        let alertController = UIAlertController(title: "Enter text", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField {[weak self, weak textLabel] (textfield) in
            if textLabel?.tag == 0 && !(textLabel?.text?.isEmpty ?? true) {
                textfield.text = textLabel?.text
                textfield.placeholder = "Enter text"
                textfield.delegate = self?.posterViewController
            }
            else{
                textfield.placeholder = "Enter text"
            }
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler:{[weak self, weak textLabel,weak alertController] (alertAction) in
            if let textField = alertController?.textFields?[0] {
                self?.updateTextElementMessage(textLabel: textLabel!, message: textField.text)
            }
        }))
        
        posterViewController.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Return text alignment.
     */
    func textElementAlignment(textAlignment:ElementTextAlignment?) -> NSTextAlignment {
        switch textAlignment ?? .left {
        case ElementTextAlignment.left:
            return .left
        case ElementTextAlignment.right:
            return .right
        case ElementTextAlignment.center:
            return .center
        }
    }
    
    /**
     Show share controller.
     */
    func showShareActivityController() {
        //let shareText = posterViewController.baseModel?.shareText ?? ""
        if let image = createPresentationImage() {
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
            activityViewController.excludedActivityTypes = [.assignToContact]
            posterViewController.present(activityViewController, animated: true)
            updateShareCount()
        }
    }
    
    func updateShareCount(){
        posterInteractor.incrementPosterShareCount {[weak self] (responseStatus, responseData) in
            DispatchQueue.main.async {
                switch responseStatus{
                case .success:
                    if let shareCount: Int = responseData?["posters_shared"] as? Int{
                        self?.posterInteractor.updatePosterShareCount(count: shareCount)
                        self?.posterInteractor.deletePendingShareCount()
                        self?.sendShareCountUpdateNotification()
                    }
                case .error:
                    self?.posterInteractor.updatePostersToShareCount()
                    self?.sendShareCountUpdateNotification()
                case .forbidden: break
                default: break
                }
            }
        }
    }
    
    private func sendShareCountUpdateNotification(){
        NotificationCenter.default.post(name: AppNotificationConstants.SHARE_COUNT_UPDATE_NOTIFICATION, object: nil)
    }
    
    /**
     Create image with poster and editable elements.
     */
    func createPresentationImage() -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(posterViewController.posterImageView.bounds.size, posterViewController.posterImageView.isOpaque, 0.0)
        posterViewController.posterImageView.drawHierarchy(in: posterViewController.posterImageView.bounds, afterScreenUpdates: false)
        let snapshotImageFromView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromView
    }
    
    /**
     Called when clicked on edit button.
     */
    func onEditButtonPress() {
        if posterViewController.textElementsDataArray.count != 0 || posterViewController.imageElementsDataArray.count != 0 {
            UIView.animate(withDuration: 0.2, animations: {[weak posterViewController] in
                for view in (posterViewController?.editShareContainerView.subviews)! {
                    view.isHidden = true
                }
                posterViewController?.doneButton.isHidden = false
                
                }, completion: nil)
            posterViewController.makeElementsEditable()
        }
        else{
            //Show error message when editable elements are not present.
            let alertController = UIAlertController(title: "", message: NO_EDITABLE_ERROR_MSG, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            posterViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    /**
     Called when clicked on DONE button
     */
    func onDoneButtonPress() {
        UIView.animate(withDuration: 0.2, animations: {[weak posterViewController] in
            for view in (posterViewController?.editShareContainerView.subviews)! {
                view.isHidden = false
            }
            posterViewController?.doneButton.isHidden = true
            }, completion: nil)
        posterViewController.makeElementsUneditable()
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
        posterViewController.selectedImageViewToCrop?.image = UIImage(named: IMAGE_ELEMENT_PLACEHOLDER, in: posterViewController.loadResourceBundle(coder: posterViewController.classForCoder), compatibleWith: nil)
        posterViewController.selectedImageViewToCrop?.contentMode = .center
        posterViewController.selectedImageViewToCrop?.accessibilityLabel = posterViewController.IMAGE_PLACEHOLDER_KEY
    }
    
    /**
     Present crop view controller once you get screen from camera and gallery
     */
    func presentCropViewController(croppingStyle: TOCropViewCroppingStyle, image: UIImage, imageViewElement: UIImageView?){
        let cropViewController = TOCropViewController(croppingStyle: croppingStyle, image: image)
        cropViewController.delegate = posterViewController
        cropViewController.toolbar.rotateClockwiseButtonHidden = true
        cropViewController.toolbar.rotateCounterclockwiseButtonHidden = true
        cropViewController.toolbar.clampButtonHidden = true
        cropViewController.toolbar.resetButton.isHidden = true
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.cropView.aspectRatioLockEnabled = true
        cropViewController.cropView.aspectRatio = CGSize(width: imageViewElement?.frame.size.width ?? 1, height: imageViewElement?.frame.size.height ?? 1)
        posterViewController.present(cropViewController, animated: true, completion: nil)
    }
    
    /**
     Set cropped image to selected image element
     */
    func setCroppedImage(image: UIImage, cropViewController: TOCropViewController){
        posterViewController.selectedImageViewToCrop?.image = image
        posterViewController.selectedImageViewToCrop?.contentMode = .scaleToFill
        posterViewController.selectedImageViewToCrop?.accessibilityLabel = nil
        cropViewController.dismiss(animated: false, completion: nil)
    }
    
    /**
     Open ImagePicker to select image from camera or gallery
     */
    private func openImagePicker(imagePickerType: ImagePickerType){
        imagePicker.delegate = posterViewController
        imagePicker.allowsEditing = false
        
        
        switch imagePickerType {
        case .camera:
            imagePicker.sourceType = .camera;
        case .gallery:
            imagePicker.sourceType = .savedPhotosAlbum;
        }
        posterViewController.present(imagePicker, animated: false, completion: nil)
    }
}
