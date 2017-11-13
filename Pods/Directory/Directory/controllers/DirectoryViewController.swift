//
//  DirectoryViewController.swift
//  Directory
//
//  Created by kunal singh on 23/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Core
import DropDown
import SDWebImage

protocol DirectoryScreenProtocol {
    func homeDirectoryContents(using managedObjectContext: NSManagedObjectContext) -> [DierctoryContent]
    func directoryContents(with directoryId: Int32, using managedObjectContext: NSManagedObjectContext) -> [DierctoryContent]
    func clickedOnDirectoryItem(data:DierctoryContent, isParentConfidential: Bool)
    func clickedOnMoreButton(data:DierctoryContent , completion:@escaping (_ status:Bool) -> ())
    func clickedOnFavourite(data:DierctoryContent,indexpath:IndexPath,managedObjectContext:NSManagedObjectContext,completionHandler:@escaping (_ status:Bool) -> Void)
}

public class DirectoryViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var emptyDataMessageView: UIView!
    @IBOutlet weak var directoryCollectionView: UICollectionView!
    private let gridReuseIdentifier = "DirectoryGridCollectionViewCell"
    private let listReuseIdentifier = "DirectoryListCollectionViewCell"
    private let headerViewIdentifier = "HeaderViewIdentifier"
    
    var eventHandler : DirectoryScreenProtocol!
    var directoryPresenter : DirectoryPresenter!
    var directoryContentsArray:[DierctoryContent]?
    private var resourceBundle: Bundle?
    public var managedObjectContext: NSManagedObjectContext?
    public var directoryContentData:DierctoryContent? = nil
    private var dropDown = DropDown()
    public var favouriteContentTypeId:Int16? = nil
    let favouriteNotificationName = NSNotification.Name(ConfigKeys.FAVOURITE_UPDATE_NOTIFICATION)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.directoryCollectionView.delegate = self
        self.directoryCollectionView.dataSource = self
        directoryPresenter = DirectoryPresenter(directoryViewController: self)
        self.eventHandler = directoryPresenter
        registerCollectionViewCell()
        resourceBundle = loadResourceBundle(coder: self.classForCoder)
        directoryPresenter.initialiseDropDown(dropDown: dropDown)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        directoryData()
        self.directoryCollectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavouriteStatus(notification:)), name: favouriteNotificationName, object: nil)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: favouriteNotificationName, object: nil)
    }
    
    /**
     Update colletion view with new favourite status. 
     */
    func updateFavouriteStatus(notification:Notification) {
        if favouriteContentTypeId == nil {
            if let data = notification.userInfo?[ConfigKeys.FAVOURITE_NOTIFICATION_DATA] as? FavouriteNotification{
                if let directoryData = directoryContentsArray?.first(where: {
                    return ($0.id == data.contentId) && ($0.contentTypeId == data.contentTypeId)
                }){
                    directoryData.isFavourite = data.isFavourite
                    directoryCollectionView.reloadData()
                }
            }
        }
    }
    
    /**
     Get data from database and set returned data in variable 'directoryContentsArray'.If directory Id is nil then it get home directory data otherwise directory contents data.
     */
    func directoryData() {
        if directoryContentData?.id == nil {
            if favouriteContentTypeId != nil {
                directoryContentsArray = directoryPresenter.favouriteContents(contentTypeId: favouriteContentTypeId ?? 0, managedObjectContext: managedObjectContext!)
            }
            else{
                directoryContentsArray = eventHandler.homeDirectoryContents(using: managedObjectContext!)
            }
        }
        else {
            directoryContentsArray = eventHandler.directoryContents(with:((directoryContentData?.id)!), using: managedObjectContext!)
        }
       showHideEmptyDataMessageView()
    }
    
    func showHideEmptyDataMessageView() {
        emptyDataMessageView.isHidden = directoryPresenter.isHiddenEmptyDataMessageView(dataCount: directoryContentsArray?.count ?? 0, favouriteContentTypeId: favouriteContentTypeId)
    }
    
    /**
     Register collection view cell.
     */
    func registerCollectionViewCell() {
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "Directory", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                
                directoryCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier)
                
                switch getCollectionViewDisplayType(displayId: directoryContentData?.directoryDisplayType) {
                case .list:
                    directoryCollectionView.register(UINib(nibName: "DirectoryListCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: listReuseIdentifier)
                case .grid:
                    directoryCollectionView.register(UINib(nibName: "DirectoryGridCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: gridReuseIdentifier)
                }
            }
            else {
                assertionFailure("Could not load the bundle")
            }
        }
        else {
            assertionFailure("Could not create a path to the bundle")
        }
    }
    
    /**
     Returns collection view display type(Grid or List view).
     */
    func getCollectionViewDisplayType(displayId:Int?) -> CollectionViewLayoutType{
        switch CollectionViewLayoutType(rawValue: displayId ?? 1)! {
        case .list:
            return .list
        case .grid:
            return .grid
        }
    }
    
    // MARK: CollectionView Delegate methods
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch getCollectionViewDisplayType(displayId: directoryContentData?.directoryDisplayType) {
        case .list:
            return CGSize(width: collectionView.frame.size.width * 0.96, height: 135)
        case .grid:
            let cellWidth = collectionView.frame.size.width / 2 - 8
            return CGSize(width: cellWidth, height: cellWidth + 100)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 5, bottom: 10, right: 5)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if directoryContentData?.id != nil && !(directoryContentData?.contentDescription?.isEmpty ?? true) {
            let labelHeight = directoryContentData?.contentDescription?.heightWithConstrainedWidth(collectionView.frame.size.width - 30, font: UIFont.systemFont(ofSize: 15))
            return CGSize(width: collectionView.frame.size.width, height: (labelHeight ?? 0) + 15)
        }
        else {
            return CGSize(width:0, height: 0)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return directoryContentsArray?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewIdentifier, for: indexPath)
            let labelHeight = directoryContentData?.contentDescription?.heightWithConstrainedWidth(collectionView.frame.size.width - 30, font: UIFont.systemFont(ofSize: 15))
            
            let headerBackgroundView = UIView(frame: CGRect(x: 4, y: 5, width: collectionView.frame.size.width - 8, height: (labelHeight ?? 0) + 10))
            headerBackgroundView.backgroundColor = UIColor.white
            
            let headerLabel = UILabel(frame: CGRect(x: 5 , y: 0, width: headerBackgroundView.frame.size.width - 10, height: (labelHeight ?? 0) + 10))
            headerLabel.numberOfLines = 0
            headerLabel.font = UIFont.systemFont(ofSize: 15)
            headerLabel.text = directoryContentData?.contentDescription ?? ""
            headerBackgroundView.addSubview(headerLabel)
            headerView.addSubview(headerBackgroundView)
            return headerView
        }
        return UICollectionReusableView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch getCollectionViewDisplayType(displayId: directoryContentData?.directoryDisplayType) {
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listReuseIdentifier,
                                                          for: indexPath) as! DirectoryListCollectionViewCell
            if let data = directoryContentsArray?[indexPath.row] {
                
                cell.contentTitleLabel.text = data.name ?? ""
                cell.contentTypeLabel.text = data.contentTypeName ?? ""
                cell.contentDescriptionLabel.text = data.contentDescription ?? ""
                cell.contentTypeLabel.text = data.contentTypeName ?? ""
                cell.contentImageView.sd_setImage(with: URL(string: data.thumbnailURL ?? ""), placeholderImage: UIImage(named: DirectoryConstants.POSTER_PLACEHOLDER_IMAGE, in: self.resourceBundle, compatibleWith: nil))
                
                AssetDownloaderService.sharedInstance.coreImageDownloader.retrieveImage(filename: data.imageFileName ?? "", completionHandler: { (image) in
                    if image != nil {
                        cell.contentImageView.image = image
                    }
                })
                
                cell.newIconImageView.isHidden = !data.isNewContent
                cell.contentTypeImageView.image = contentTypeImage(resourceFileName: data.contentTypeImageName ?? "", resourceBundle: resourceBundle)
                cell.likeButton.setImage(directoryPresenter.favouriteImage(isFavorite: data.isFavourite,bundle:resourceBundle), for: .normal)
                cell.moreOptionButton.tag = indexPath.row
                cell.moreOptionButton.addTarget(self, action: #selector(clickedOnMoreButton(_:)), for: .touchUpInside)
                cell.likeButton.tag = indexPath.row
                cell.likeButton.addTarget(self, action: #selector(clickedOnFavouriteButton(_:)), for: .touchUpInside)
                
            }
            return cell
            
        case .grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridReuseIdentifier,
                                                          for: indexPath) as! DirectoryGridCollectionViewCell
            
            if let data = directoryContentsArray?[indexPath.row] {
                
                cell.contentTitleLabel.text = data.name ?? ""
                cell.contentTypeLabel.text = data.contentTypeName ?? ""
                cell.contentDescriptionLabel.text = data.contentDescription ?? ""
                cell.contentTypeLabel.text = data.contentTypeName ?? ""
                cell.contentImageView.sd_setImage(with: URL(string: data.thumbnailURL ?? ""), placeholderImage: UIImage(named: DirectoryConstants.POSTER_PLACEHOLDER_IMAGE, in: self.resourceBundle, compatibleWith: nil))
                cell.newIconImageView.isHidden = !data.isNewContent
                cell.contentTypeImageView.image = contentTypeImage(resourceFileName: data.contentTypeImageName ?? "", resourceBundle: resourceBundle)
                cell.likeButton.setImage(directoryPresenter.favouriteImage(isFavorite: data.isFavourite,bundle:resourceBundle), for: .normal)
                cell.moreOptionButton.tag = indexPath.row
                cell.moreOptionButton.addTarget(self, action: #selector(clickedOnMoreButton(_:)), for: .touchUpInside)
                cell.likeButton.tag = indexPath.row
                cell.likeButton.addTarget(self, action: #selector(clickedOnFavouriteButton(_:)), for: .touchUpInside)
                
            }
            
            return cell
        }
    }
    
    /**
     Triggered when user click on more button.
     */
    func clickedOnMoreButton(_ sender:UIButton) {
        let index = sender.tag
        if let data = directoryContentsArray?[index] {
            directoryPresenter.setDropDownAnchor(dropDown: dropDown, anchorView: sender)
            directoryPresenter.setDropDownSelectionActions(dropDown: dropDown, data: data)
            dropDown.show()
        }
    }
    
    /**
     Triggered when user click on favourite button.
     */
    func clickedOnFavouriteButton(_ sender:UIButton){
        let index = sender.tag
        if let directoryContentData = directoryContentsArray?[index]{
            let indexPath = IndexPath(row: index, section: 0)
            eventHandler.clickedOnFavourite(data: directoryContentData, indexpath: indexPath, managedObjectContext: managedObjectContext!, completionHandler: {[weak self] (status) in
                if status {
                    if self?.favouriteContentTypeId != nil {
                        self?.directoryContentsArray?.remove(at: index)
                        self?.directoryCollectionView.reloadData()
                        self?.showHideEmptyDataMessageView()
                    }
                    else {
                        if let collectionViewCell = self?.directoryCollectionView.cellForItem(at: indexPath), self?.directoryCollectionView.visibleCells.contains(collectionViewCell) == true {
                            self?.directoryCollectionView.reloadItems(at: [indexPath])
                        }
                    }
                    self?.sendNotificationFavouriteUpdate(directoryData:directoryContentData)
                }
            })
        }
    }
    
    /**
     Send notification for favourite/unfavourite update.
     */
    func sendNotificationFavouriteUpdate(directoryData:DierctoryContent){
        let data = FavouriteNotification()
        data.contentId = directoryData.id
        data.contentTypeId = directoryData.contentTypeId
        data.isFavourite = directoryData.isFavourite
        let userInfo = [ConfigKeys.FAVOURITE_NOTIFICATION_DATA : data]
        NotificationCenter.default.post(name: favouriteNotificationName, object: userInfo)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = directoryContentsArray?[indexPath.row] {
            eventHandler.clickedOnDirectoryItem(data: data, isParentConfidential: directoryContentData?.isConfidential ?? false)
        }
    }
    
}
