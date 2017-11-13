//
//  GalleryViewController.swift
//  Directory
//
//  Created by Apple on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import CoreData
import Core
import DropDown
import SDWebImage

protocol GalleryScreenProtocol {
    func clickedOnGalleryItem(data: DierctoryContent)
    func clickedOnMoreButton(data:DierctoryContent , completion:@escaping (_ status:Bool) -> ())
    func clickedOnFavourite(data:DierctoryContent,indexpath:IndexPath,managedObjectContext:NSManagedObjectContext,completionHandler:@escaping (_ status:Bool) -> Void)
}

public class GalleryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var galleryTableView: UITableView!
    private let tableViewCellIdentifier = "GalleryTableViewCellIdentifier"
    var galleryPresenter : GalleryPresenter!
    public var managedObjectContext:NSManagedObjectContext?
    public var directoryContentData:DierctoryContent? = nil
    public var galleryCellDescriptionHeight: CGFloat = 80
    public var gallerySectionHeight: CGFloat = 28
    var galleryDataArray:[[GalleryHeader:[DierctoryContent]]]? = nil
    public var isNewItemsView:Bool = false
    var resourceBundle: Bundle?
    var eventHandler : GalleryScreenProtocol!
    var dropDown = DropDown()
    
    let notificationName = NSNotification.Name(ConfigKeys.DATA_SYNC_NOTIFICATION)
    let favouriteNotificationName = NSNotification.Name(ConfigKeys.FAVOURITE_UPDATE_NOTIFICATION)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        galleryPresenter = GalleryPresenter.init(galleryViewController: self)
        self.eventHandler = galleryPresenter
        getGalleryData()
        resourceBundle = loadResourceBundle(coder: self.classForCoder)
        registerViewCell()
        galleryPresenter.initialiseDropDown(dropDown: dropDown)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavouriteStatus(notification:)), name: favouriteNotificationName, object: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNewItemsData), name: notificationName, object: nil)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
    
    func updateFavouriteStatus(notification:Notification) {
        if isNewItemsView{
        getGalleryData()
        reloadRowsWhenAssetDownloaded()
        }
    }
    
    func reloadNewItemsData(){
        if let galleryData = galleryDataArray {
            if galleryData.count > 0{
                for (_, value) in galleryData[0]{
                    if value.count == 0{
                        getGalleryData()
                    }
                }
            }
        }
        reloadRowsWhenAssetDownloaded()
    }

    /**
     Configure table view.
     */
    func configTableView() {
        self.galleryTableView.delegate = self
        self.galleryTableView.dataSource = self
        galleryTableView.sectionHeaderHeight = 0
        if isNewItemsView {
            galleryTableView.sectionFooterHeight = 0
            galleryTableView.isDirectionalLockEnabled = true
            galleryTableView.alwaysBounceVertical = false
            galleryTableView.isScrollEnabled = false
        }
        else {
            galleryTableView.sectionFooterHeight = 12
        }
    }
    
    func getGalleryData() {
        if isNewItemsView {
            galleryDataArray = galleryPresenter.galleryDataContainingNewItems(managedObjectContext: managedObjectContext!)
        }else {
            galleryDataArray = galleryPresenter.dataForGallery(managedObjectContext: managedObjectContext!)
        }
    }
    
    /**
     Register tableview cell.
     */
    func registerViewCell() {
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "Directory", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                galleryTableView.register(UINib(nibName: "GalleryTableViewCell", bundle: bundle) , forCellReuseIdentifier: tableViewCellIdentifier)
            }
            else {
                assertionFailure("Could not load the bundle")
            }
        }
        else {
            assertionFailure("Could not create a path to the bundle")
        }
    }
    
    // MARK: TableView Delegate methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        if isNewItemsView {
            return 1
        }
        return galleryDataArray?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let data = galleryDataArray?[section] {
            let galleryHeaderData = data.keys.first
            var titleHeight:CGFloat = 0
            if !(galleryHeaderData?.name.isEmpty ?? true){
                titleHeight = galleryHeaderData?.name.heightWithConstrainedWidth(tableView.frame.size.width - 16, font: UIFont.boldSystemFont(ofSize: 15)) ?? 0
            }
            var descriptionHeight:CGFloat = 0
            if !isNewItemsView{
                
                if !(galleryHeaderData?.description.isEmpty ?? true){
                    descriptionHeight = galleryHeaderData?.description.heightWithConstrainedWidth(tableView.frame.size.width - 16, font: UIFont.systemFont(ofSize: 14)) ?? 0
                }
                gallerySectionHeight = CGFloat(titleHeight + descriptionHeight + 12)
            }
            else{
                gallerySectionHeight = CGFloat(titleHeight + 10)
            }
            return titleHeight == 0 && descriptionHeight == 0 ? 6 : gallerySectionHeight
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
        headerView.backgroundColor = UIColor.clear
        if let data = galleryDataArray?[section] {
            let galleryHeaderData = data.keys.first
            
            let titleLabel = UILabel(frame: CGRect(x: 8, y: 4, width: headerView.frame.size.width - 16, height: 0))
            titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
            let titleHeight = galleryHeaderData?.name.heightWithConstrainedWidth(titleLabel.frame.size.width, font: titleLabel.font)
            titleLabel.frame.size.height = (titleHeight ?? 0) + 2
            titleLabel.numberOfLines = 0
            titleLabel.text = galleryHeaderData?.name
            headerView.addSubview(titleLabel)
            if !isNewItemsView{
                let descriptionLabel = UILabel(frame: CGRect(x: 8, y: titleLabel.frame.origin.y + titleLabel.frame.size.height, width:headerView.frame.size.width - 16 , height: 0))
                descriptionLabel.font = UIFont.systemFont(ofSize: 14)
                let descriptionHeight = galleryHeaderData?.description.heightWithConstrainedWidth(descriptionLabel.frame.size.width, font: descriptionLabel.font)
                descriptionLabel.frame.size.height = (descriptionHeight ?? 0) + 2
                descriptionLabel.numberOfLines = 0
                descriptionLabel.text = galleryHeaderData?.description
                headerView.addSubview(descriptionLabel)
                headerView.frame.size.height = titleLabel.frame.size.height + descriptionLabel.frame.size.height + 4
            }
            else{
                headerView.frame.size.height = titleLabel.frame.size.height + 10
            }
        }
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier) as! GalleryTableViewCell
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? GalleryTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.size.width/2 - 8) + galleryCellDescriptionHeight
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        ///Removing favourite update notification
        NotificationCenter.default.removeObserver(self, name: favouriteNotificationName, object: nil)
    }
    
    /**
     Reload table view when data sync operation is completed.
     */
    public func reloadRowsWhenAssetDownloaded(){
       self.galleryTableView.reloadData()
    }
}

extension GalleryViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // MARK: CollectionView Delegate methods
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width / 2 - 8
        return CGSize(width: cellWidth, height: cellWidth + 80)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let galleryArray = galleryDataArray{
            let dataItem:[GalleryHeader: [DierctoryContent]] = galleryArray[collectionView.tag]
            for (_, value) in dataItem {
                return value.count
            }
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DirectoryConstants.galleryCollectionCellIDentifier,
                                                      for: indexPath) as! GalleryCollectionViewCell
        if let directoryContentData = directoryContent(tag: collectionView.tag, row: indexPath.row){
            cell.titleLabel.text = directoryContentData.name
            cell.contentImageView.sd_setImage(with: URL(string: directoryContentData.thumbnailURL ?? ""), placeholderImage: UIImage(named: DirectoryConstants.POSTER_PLACEHOLDER_IMAGE, in: self.resourceBundle, compatibleWith: nil))
//            AssetDownloaderService.sharedInstance.coreImageDownloader.retrieveImage(filename: directoryContentData.imageFileName ?? "", completionHandler: { (image) in
//                if image != nil {
//                    cell.contentImageView.image = image
//                }
//                else {
//                    cell.contentImageView.image = UIImage(named: DirectoryConstants.POSTER_PLACEHOLDER_IMAGE, in: self.resourceBundle, compatibleWith: nil)
//                }
//            })
            
            cell.newIconImageView.isHidden = !directoryContentData.isNewContent
            cell.contentTypeImageView.image = contentTypeImage(resourceFileName: directoryContentData.contentTypeImageName ?? "", resourceBundle: resourceBundle)
            cell.likeButton.setImage(galleryPresenter.favouriteImage(isFavorite: directoryContentData.isFavourite,bundle:resourceBundle), for: .normal)
            cell.likeButton.buttonIdentifier = cell.likeButton.tagWithSectionAndRow(section: collectionView.tag, row: indexPath.row)
            cell.moreOptionButton.buttonIdentifier = cell.moreOptionButton.tagWithSectionAndRow(section: collectionView.tag, row: indexPath.row)
            cell.moreOptionButton.addTarget(self, action: #selector(clickedOnMoreButton(_:)), for: .touchUpInside)
            cell.likeButton.addTarget(self, action: #selector(clickedOnFavouriteButton(_:)), for: .touchUpInside)
            cell.contentTypeLabel.text = directoryContentData.contentTypeName ?? ""
        }
        return cell
    }
    
    @objc private func clickedOnMoreButton(_ sender:CustomTaggedButton) {
         if let tag = sender.buttonIdentifier{
            let (section, row) = sender.sectionRowFromTag(tag: tag)!
             if let directoryContentData = directoryContent(tag: section, row: row){
                galleryPresenter.setDropDownAnchor(dropDown: dropDown, anchorView: sender)
                galleryPresenter.setDropDownSelectionActions(dropDown: dropDown, data: directoryContentData)
                dropDown.show()
            }
        }
    }
    
    @objc private func clickedOnFavouriteButton(_ sender:CustomTaggedButton) {
        if let tag = sender.buttonIdentifier{
            let (section, row) = sender.sectionRowFromTag(tag: tag)!
            if let directoryContentData = directoryContent(tag: section, row: row){
                
                eventHandler.clickedOnFavourite(data: directoryContentData, indexpath: IndexPath(row: row, section: section), managedObjectContext: managedObjectContext!, completionHandler: {[weak self] (status) in
                    if status {
                    if let tableviewCell = self?.galleryTableView.cellForRow(at: IndexPath(row: 0, section: section)) as? GalleryTableViewCell,self?.galleryTableView.visibleCells.contains(tableviewCell) == true{
                        tableviewCell.galleryCollectionView.reloadItems(at: [IndexPath(row:row, section:0)])
                        self?.sendNotificationFavouriteUpdate(directoryData: directoryContentData)
                    }
                    }
                })
            }
        }
    }
    
    /**
     Send Favourite update notification to observers.
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
        if let directoryContentData = directoryContent(tag: collectionView.tag, row: indexPath.row){
            eventHandler.clickedOnGalleryItem(data: directoryContentData)
        }
    }
    
    private func directoryContent(tag: Int, row: Int) -> DierctoryContent?{
        if let galleryArray = galleryDataArray{
            let dataItem:[GalleryHeader: [DierctoryContent]] = galleryArray[tag]
            var directoryContentArray = [DierctoryContent]()
            for (_, value) in dataItem {
                directoryContentArray = value
            }
            return directoryContentArray[row]
        }
        return nil
    }
    
}
