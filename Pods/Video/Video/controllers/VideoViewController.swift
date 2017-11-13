//
//  VideoViewController.swift
//  Video
//
//  Created by kunal singh on 03/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import UIKit
import Core
import CoreData

/**
 VideoViewController shows selected video file to play. It displays other videos available to play.
 It also gives option to share the video.
 */
public class VideoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoTableView: UITableView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoView: UIView!

    var videoViewPresenter : VideoViewPresenter!
    public var interPodsCommunicationModel: InterPodsCommunicationModel?
    public var managedObjectContext: NSManagedObjectContext?
    var selectedVideo: VideoItem?
    var allVideoItems = [VideoItem]()
    private let tableViewCellIdentifier = "VideoItemTableViewCell"
    private let DEFAULT_VIDEO_IMAGE = "video_placeholder.jpg"
    private let TABLE_CELL_HEIGHT: CGFloat = 70
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        videoViewPresenter = VideoViewPresenter(videoViewController: self)
        initialise()
        setTapGestureOnVideoView()
        makePlayImageViewCircular()
        initialiseTableView()
        registerTableViewCell()
    }
    
    /**
     Initialise video data
     */
    func initialise(){
        if let baseModel = interPodsCommunicationModel{
            selectedVideo = videoViewPresenter.videoItemFromInterPodsCommunicationModel(interPodsCommunicationModel: baseModel)
            setSelectedVideoData()
        }
    }
    
    /**
     Initialise videoTableView
     */
    private func initialiseTableView(){
        if let managedObject = managedObjectContext{
            allVideoItems = videoViewPresenter.allVideoItemsFromDatabase(using: managedObject)
        }
        videoTableView.delegate = self
        videoTableView.dataSource = self
        videoTableView.tableHeaderView = videoViewPresenter.videoTableHeaderView(tableViewWidth: videoTableView.frame.size.width, videoItem: selectedVideo)
        videoTableView.tableFooterView = UIView()
    }
    
    /**
     Register nib for videoTableView
     */
    func registerTableViewCell() {
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "Video", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                videoTableView.register(UINib(nibName: tableViewCellIdentifier, bundle: bundle), forCellReuseIdentifier: tableViewCellIdentifier)
            }else {
                assertionFailure("Could not load the bundle")
            }
        }else {
            assertionFailure("Could not create a path to the bundle")
        }
    }

    
    /**
     Dismiss view controller on back press
     */
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allVideoItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! VideoItemTableViewCell
        
        let videoItem = allVideoItems[indexPath.row]
        AssetDownloaderService.sharedInstance.coreImageDownloader.retrieveImage(filename: videoItem.videoImageFileName ?? "") { (image) in
            if image != nil {
                cell.videoImage.image = image
            }
            else {
                let podBundle = Bundle(for: self.classForCoder)
                if let bundleURL = podBundle.url(forResource: "Video", withExtension: "bundle") {
                    if let bundle = Bundle(url: bundleURL) {
                        cell.videoImage.image = UIImage(named: self.DEFAULT_VIDEO_IMAGE, in: bundle, compatibleWith: nil)
                    }
                }
            }
        }
        cell.videoName.text = videoItem.name ?? ""
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVideo = allVideoItems[indexPath.row]
        setSelectedVideoData()
        videoTableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (allVideoItems[indexPath.row].id == selectedVideo?.id) ? 1 : TABLE_CELL_HEIGHT
    }
    
    /**
     Set selected video data on screen
     */
    func setSelectedVideoData(){
        titleLabel.text = selectedVideo?.name ?? ""
        if let contentImage = AssetDownloaderService.sharedInstance.coreImageDownloader.retrieveImageFromDisk(filename: selectedVideo?.videoImageFileName ?? ""){
            videoImageView.image = contentImage
        }else{
            let podBundle = Bundle(for: self.classForCoder)
            if let bundleURL = podBundle.url(forResource: "Video", withExtension: "bundle") {
                if let bundle = Bundle(url: bundleURL) {
                    videoImageView.image = UIImage(named: DEFAULT_VIDEO_IMAGE, in: bundle, compatibleWith: nil)
                }
            }
        }
        videoTableView.tableHeaderView = videoViewPresenter.videoTableHeaderView(tableViewWidth: videoTableView.frame.size.width, videoItem: selectedVideo)
    }

    /**
     Show share screen on share video tap
     */
    func onShareVideoTap(_ sender: UIButton){
        if let shareUrl = selectedVideo?.videoURL{
            videoViewPresenter.showShareActivityController(shareUrl: shareUrl)
        }
    }
    
    /**
     Make play image circular
     */
    func makePlayImageViewCircular(){
        self.view.layoutIfNeeded()
        playImageView.layer.cornerRadius = playImageView.frame.size.width/2
        playImageView.clipsToBounds = true
    }
    
    /**
     Eet TapGesture on VideoView
     */
    private func setTapGestureOnVideoView(){
        let videoViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(startPlayingVideo(_:)))
        videoView.addGestureRecognizer(videoViewTapGesture)
    }
    
    /**
     Open next screen to play videos
     */
    @objc private func startPlayingVideo(_ sender: UIView){
        if selectedVideo != nil{
            videoViewPresenter.playVideo(videoItem: selectedVideo!)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        videoTableView.reloadData()
    }
}

