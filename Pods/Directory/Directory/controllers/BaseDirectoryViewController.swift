//
//  BaseDirectoryViewController.swift
//  smartsell
//
//  Created by Apple on 27/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore

protocol BaseDirectoryProtocol {
    func initializeDirectory(directoryContentData:DierctoryContent?)
    func dismissViewController()
}

public class BaseDirectoryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var directoryNameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var eventHandler : BaseDirectoryProtocol!
    var baseDirectoryPresenter : BaseDirectoryPresenter!
    public var managedObjectContext: NSManagedObjectContext?
    public var directoryContentData:DierctoryContent? = nil
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        baseDirectoryPresenter = BaseDirectoryPresenter(baseDirectoryViewController: self)
        self.eventHandler = baseDirectoryPresenter
        initialiseUI()
        configView()
        self.tabBarController?.tabBar.isHidden = true
        hidesBottomBarWhenPushed = true
        setSearchFieldUI()
        searchTextField.delegate = self
    }
    
    func setSearchFieldUI() {
        
        searchTextField.layer.cornerRadius = 15
        searchTextField.layer.borderColor = UIColor.black.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
    }
    
 public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configView() {
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    /**
     Add DirectoryViewController as chid view controller.
     */
    public func initialiseUI(){
        eventHandler.initializeDirectory(directoryContentData: directoryContentData)
        directoryNameLabel.text = directoryContentData?.name ?? "Sales Collateral"
    }

    public func directoryContentDataWithId(_ directoryId:Int32) -> DierctoryContent? {
        return baseDirectoryPresenter.directoryContentDataWithId(directoryId, managedObjectContext: self.managedObjectContext!, isConfidential: false)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        eventHandler.dismissViewController()
    }
    
    @IBAction func onHomeButtonTap(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func searchTextFieldEditingChanged(_ sender: UITextField) {
        //collect text from the field
        // write a predicate filtering mechanism for the data set
        // take matched data and re populate the collectionview.
        print("Search text filter is \(sender.text)")
    }
    
    
}
