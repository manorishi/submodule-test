//
//  VideoViewPresenter.swift
//  Video
//
//  Created by Anurag Dake on 06/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import Core
import CoreData

/**
 VideoViewPresenter handles UI for VideoViewController such as generating video item from InterPodsCommunicationModel, generate UI for table header view, display UIActivityViewController to share video
 */
class VideoViewPresenter: NSObject{
    weak var videoViewController: VideoViewController!
    var videoViewInteractor: VideoViewInteractor!
    
    let SHARE_BUTTON_TEXT = "SHARE VIDEO"
    let MORE_VIDEOS = "More Videos"
    private let VIDEO_IDENTIFIER = "org.cocoapods.Video"
    private let VIDEO_BUNDLE_NAME = "Video"
    private let VIDEOPLAY_VIEW_CONTROLLER = "VideoPlayViewController"
    
    init(videoViewController: VideoViewController) {
        self.videoViewController = videoViewController
        videoViewInteractor = VideoViewInteractor()
    }
    
    /**
     Return videoItem from InterPodsCommunicationModel
     */
    func videoItemFromInterPodsCommunicationModel(interPodsCommunicationModel: InterPodsCommunicationModel) -> VideoItem{
        return VideoItem(id: interPodsCommunicationModel.id, name: interPodsCommunicationModel.name, videoDescription: interPodsCommunicationModel.contentDescription, thumbnailURL: interPodsCommunicationModel.thumbnailUrl, videoURL: interPodsCommunicationModel.assetUrl, shareText: interPodsCommunicationModel.shareText, videoImageFileName: interPodsCommunicationModel.assetFileName)
    }
    
    /**
     Return all videos from database
     */
    func allVideoItemsFromDatabase(using managedObjectContext: NSManagedObjectContext) -> [VideoItem]{
        return videoViewInteractor.allVideoItemsFromDatabase(using: managedObjectContext)
    }
    
    /**
     Return header for table of videos
     */
    func videoTableHeaderView(tableViewWidth: CGFloat, videoItem: VideoItem?) -> UIView{
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        headerView.backgroundColor = UIColor.clear
        
        let videoName = videoItem?.name ?? ""
        
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 4, width: headerView.frame.size.width - 16, height: 0))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        let titleHeight = videoName.heightWithConstrainedWidth(titleLabel.frame.size.width,font: titleLabel.font)
        titleLabel.frame.size.height = titleHeight + 2
        titleLabel.numberOfLines = 0
        titleLabel.text = videoName
        headerView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel(frame: CGRect(x: 8, y: titleLabel.frame.origin.y + titleLabel.frame.size.height + 4, width:headerView.frame.size.width - 16 , height: 0))
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        let descriptionHeight = videoItem?.videoDescription?.heightWithConstrainedWidth(descriptionLabel.frame.size.width, font: descriptionLabel.font)
        descriptionLabel.frame.size.height = (descriptionHeight ?? 0) + 2
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = videoItem?.videoDescription
        headerView.addSubview(descriptionLabel)
        
        
        let shareButton = UIButton(frame: CGRect(x: 8, y: descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 4, width: headerView.frame.size.width - 16, height: 40))
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        shareButton.tintColor = UIColor.white
        shareButton.backgroundColor = hexStringToUIColor(hex: "AE275F")
        shareButton.setTitle(SHARE_BUTTON_TEXT, for: .normal)
        let tapgesture = UITapGestureRecognizer(target: videoViewController, action: #selector(videoViewController.onShareVideoTap(_:)))
        shareButton.addGestureRecognizer(tapgesture)
        headerView.addSubview(shareButton)
        
        let moreVideosLabel = UILabel(frame: CGRect(x: 8, y: shareButton.frame.origin.y + shareButton.frame.size.height + 4, width:headerView.frame.size.width - 16 , height: 0))
        moreVideosLabel.font = UIFont.boldSystemFont(ofSize: 13)
        moreVideosLabel.textColor = UIColor.darkGray
        moreVideosLabel.frame.size.height = 24
        moreVideosLabel.numberOfLines = 1
        moreVideosLabel.text = MORE_VIDEOS
        headerView.addSubview(moreVideosLabel)
        
        
        headerView.frame.size.height = titleLabel.frame.size.height + descriptionLabel.frame.size.height + shareButton.frame.size.height + moreVideosLabel.frame.size.height + 16
        return headerView
    }
    
    /**
     Show share controller.
     */
    func showShareActivityController(shareUrl: String) {
        let shareUrl = NSURL.init(string: shareUrl)
            let activityViewController = UIActivityViewController(activityItems: [shareUrl ?? NSURL()], applicationActivities: [])
            activityViewController.excludedActivityTypes = [.assignToContact]
            videoViewController.present(activityViewController, animated: true)
        updateShareCount()
    }
    
    /**
     Update video share count api call
     */
    func updateShareCount(){
        videoViewInteractor.incrementVideoShareCount {[weak self] (responseStatus, responseData) in
            DispatchQueue.main.async {
                switch responseStatus{
                case .success:
                    if let shareCount: Int = responseData?["videos_shared"] as? Int{
                        self?.videoViewInteractor.updateVideoShareCount(count: shareCount)
                        self?.videoViewInteractor.deletePendingShareCount()
                        self?.sendShareCountUpdateNotification()
                    }
                case .error:
                    self?.videoViewInteractor.updateVideosToShareCount()
                    self?.sendShareCountUpdateNotification()
                    
                case .forbidden: break
                default: break
                }
            }
        }
    }
    
    /**
     Send notification to inform share count update
     */
    private func sendShareCountUpdateNotification(){
        NotificationCenter.default.post(name: AppNotificationConstants.SHARE_COUNT_UPDATE_NOTIFICATION, object: nil)
    }
    
    /**
     Goto play video view controller
     */
    func playVideo(videoItem: VideoItem){
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: VIDEO_BUNDLE_NAME, withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let videoPlayVC = VideoPlayViewController(nibName: VIDEOPLAY_VIEW_CONTROLLER, bundle: bundle)
                videoPlayVC.videoItem = videoItem
                videoViewController.present(videoPlayVC, animated: true, completion: nil)
            }
        }
    }
}
