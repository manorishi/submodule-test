//
//  PosterViewController.swift
//  Poster
//
//  Created by Anurag Dake on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 PosterViewController perform UI transitions like to present and dismiss UIImagePickerController, Poster zoom view and implements various required delegates like ActionSheetCallbackProtocol,UIImagePickerControllerDelegate,TOCropViewControllerDelegate,TextFieldAlertControllerCallbackProtocol, UITextFieldDelegate.
 */

import UIKit
import CoreData
import Core
import TOCropViewController
import SKPhotoBrowser
import SDWebImage

protocol PosterProtocol {
    func cameraButtonPressed()
    func galleryButtonPressed()
    func deleteButtonPressed()
    func onEditButtonPress()
    func onDoneButtonPress()
}

public class PosterViewController: UIViewController, ActionSheetCallbackProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate,UITextFieldDelegate, TextFieldAlertControllerCallbackProtocol {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var editShareContainerView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    public var managedObjectContext: NSManagedObjectContext?
    public var baseModel: InterPodsCommunicationModel?
    public var isConfidential = false
    var posterPresenter : PosterPresenter!
    private var eventHandler : PosterProtocol!
    var actionSheetHelper: ActionSheetHelper?
    var chooseImageActionSheet: UIAlertController?
    var selectedImageViewToCrop: UIImageView?
    
    var imageElementsDataArray:[PosterImageElementModel] = []
    var textElementsDataArray:[PosterTextElementModel] = []
    var imageElementsReference:[UIImageView] = []
    var textElementsReference:[UILabel] = []
    let imageRefSize = CGSize(width: 300, height: 400)
    private let TEXT_ELEMENT_MAX_CHAR = 50
    
    let IMAGE_PLACEHOLDER_KEY = "placeholder"
    
    var textFieldAlertControllerHelper: TextFieldAlertControllerHelper?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        posterPresenter = PosterPresenter.init(posterViewController: self)
        eventHandler = posterPresenter
        loadData()
        posterPresenter.configView()
        showImageWithElements()
        initialiseActionSheetHelper()
        textFieldAlertControllerHelper = TextFieldAlertControllerHelper(textFieldAlertControllerCallbackProtocol: self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isConfidential{
            if textElementsDataArray.count == 0 && imageElementsDataArray.count == 0 {
                editButton.isHidden = true
                editButton.frame.size.width = 0
                shareButton.frame.size.width = UIScreen.main.bounds.width
            }
            else{
                editButton.isHidden = false
                editButton.frame.size.width = UIScreen.main.bounds.width / 2
                shareButton.frame.size.width = UIScreen.main.bounds.width / 2
            }
            shareButton.frame.origin.x = editButton.frame.size.width
        }
    }
    
    /**
     Show popup view to edit text.
     */
    func popupToEditText(title: String?, message: String?, defaultText: String, noOfTextFields: Int = 1) {
        if let alertController = textFieldAlertControllerHelper?.textFieldAlertController(with: title, message: message, defaultText: defaultText, numberOfTextFields: noOfTextFields){
            present(alertController, animated: true, completion: nil)
        }
    }
    
    public func newTextValue(newText: String) {
        print(newText)
        posterPresenter.updateSignature(stringArray: newText.components(separatedBy: ";"))
    }
    
    func initialiseActionSheetHelper(){
        actionSheetHelper = ActionSheetHelper(actionSheetCallbackProtocol: self)
    }

    /**
     Show poster image and add text and image elements.
     */
    func showImageWithElements() {
        posterImageView.sd_setImage(with: URL(string: baseModel?.thumbnailUrl ?? ""), placeholderImage: UIImage(named: "default_placeholder", in: loadResourceBundle(coder: self.classForCoder), compatibleWith: nil))
        
        //posterImageView.image = posterPresenter.posterImageFromDisk()
        posterImageView.frame.size = posterPresenter.scaleImageToSize(originalImageSize: posterImageView.image?.size ?? CGSize.zero, newSize: imageContainerView.frame.size)
        posterImageView.center.x = imageContainerView.frame.size.width / 2
        posterImageView.center.y = imageContainerView.frame.size.height / 2
        
        posterImageView.addGestureRecognizer(addDoubleTapGestureRecogniser(target: self, action: #selector(tappedOnImageForZoom(gesture:))))
        posterPresenter.addImageElements()
        posterPresenter.addTextElements()
    }
    
    func addDoubleTapGestureRecogniser(target: Any, action: Selector) -> UITapGestureRecognizer{
        let singleTapGesture = UITapGestureRecognizer(target: target, action: action)
        singleTapGesture.numberOfTapsRequired = 2
        return singleTapGesture
    }
    
    func tappedOnImageForZoom(gesture:UIGestureRecognizer) {
        if let posterImage = gesture.view as? UIImageView {
            var images = [SKPhoto]()
            let photo = SKPhoto.photoWithImage(posterImage.image ?? UIImage())
            images.append(photo)
            let browser = SKPhotoBrowser(originImage:posterImage.image ?? UIImage(), photos: images, animatedFromView: posterImageView)
            browser.initializePageIndex(0)
            SKPhotoBrowserOptions.displayToolbar = false
            present(browser, animated: true, completion: nil)
        }
    }
    
    /**
     Get text and image element from local database.
     */
    func loadData(){
        if let baseData = baseModel{
            textElementsDataArray = posterPresenter.postersTextElementsData(posterId: baseData.id, managedObjectContext: managedObjectContext!)
            imageElementsDataArray = posterPresenter.postersImageElementsData(posterId: baseData.id, managedObjectContext: managedObjectContext!)
            titleLabel.text = baseData.name
        }
    }
    
    /**
     Make poster text and image element editable.
     */
    func makeElementsEditable() {
        for imageElementRef in imageElementsReference {
            imageElementRef.layer.borderWidth = 1.5
            imageElementRef.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            imageElementRef.isUserInteractionEnabled = true
            if imageElementRef.accessibilityLabel == IMAGE_PLACEHOLDER_KEY {
                imageElementRef.image = UIImage(named: posterPresenter.IMAGE_ELEMENT_PLACEHOLDER, in: self.loadResourceBundle(coder: self.classForCoder), compatibleWith: nil)
                imageElementRef.contentMode = .center
            }
        }
        
        for textElementRef in textElementsReference {
            textElementRef.layer.borderWidth = 1.5
            textElementRef.isUserInteractionEnabled = true
            textElementRef.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            posterPresenter.updateTextElementMessage(textLabel: textElementRef, message: textElementRef.text)
        }
        posterPresenter.makeSignatureEditable()
    }
    
    /**
     Make poster text and image element uneditable.
     */
    func makeElementsUneditable() {
        for imageElementRef in imageElementsReference {
            imageElementRef.layer.borderWidth = 0
            imageElementRef.isUserInteractionEnabled = false
            imageElementRef.backgroundColor = UIColor.clear
            if imageElementRef.accessibilityLabel == IMAGE_PLACEHOLDER_KEY {
                imageElementRef.image = nil
                imageElementRef.contentMode = .scaleToFill
            }
        }
        
        for textElementRef in textElementsReference {
            textElementRef.layer.borderWidth = 0
            textElementRef.isUserInteractionEnabled = false
            textElementRef.backgroundColor = UIColor.clear
            if textElementRef.tag != 0 {
                textElementRef.text = nil
            }
        }
        posterPresenter.makeSignatureUneditable()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= TEXT_ELEMENT_MAX_CHAR
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        eventHandler.onDoneButtonPress()
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        posterPresenter.showShareActivityController()
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        eventHandler.onEditButtonPress()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     ActionSheetCallbackProtocol camera button selected
    */
    func cameraButtonPressed() {
        eventHandler.cameraButtonPressed()
    }
    
    /**
     ActionSheetCallbackProtocol gallery button selected
     */
    func galleryButtonPressed() {
        eventHandler.galleryButtonPressed()
    }
    
    /**
     ActionSheetCallbackProtocol delete button selected
     */
    func deleteButtonPressed() {
        eventHandler.deleteButtonPressed()
    }
    
    ///UIImagePickerControllerDelegate method
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage, let tag = selectedImageViewToCrop?.tag, let selectedImageType: ElementShapes =  ElementShapes(rawValue: tag) {
            
            let croppingStyle: TOCropViewCroppingStyle = selectedImageType.rawValue == ElementShapes.circle.rawValue ? TOCropViewCroppingStyle.circular : TOCropViewCroppingStyle.default
            posterPresenter.presentCropViewController(croppingStyle: croppingStyle, image: selectedImage, imageViewElement: selectedImageViewToCrop)
        }
    }
    
    /**
     Called when tapped on image element.
     */
    @objc func imageElementTappedToEdit(gesture:UIGestureRecognizer) {
        selectedImageViewToCrop = gesture.view as? UIImageView
        chooseImageActionSheet = actionSheetHelper?.actionSheetToChooseImage(isDeleteEnabled: selectedImageViewToCrop?.accessibilityLabel != IMAGE_PLACEHOLDER_KEY)
        if chooseImageActionSheet != nil{
            present(chooseImageActionSheet!, animated: true, completion: nil)
        }
    }
    
    ///TOCropViewControllerDelegate to perform  operation after cropping square image
    public func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        posterPresenter.setCroppedImage(image: image, cropViewController: cropViewController)
    }
    
    ///TOCropViewControllerDelegate to perform  operation after cropping circular image
    public func cropViewController(_ cropViewController: TOCropViewController, didCropToCircleImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        posterPresenter.setCroppedImage(image: image, cropViewController: cropViewController)
    }
    
    func loadResourceBundle(coder: AnyClass) -> Bundle?{
        let podBundle = Bundle(for: coder)
        if let bundleURL = podBundle.url(forResource: "Poster", withExtension: "bundle") {
            return Bundle(url: bundleURL)
        }
        return nil
    }
}

