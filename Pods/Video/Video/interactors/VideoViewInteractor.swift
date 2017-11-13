//
//  VideoViewInteractor.swift
//  Video
//
//  Created by Anurag Dake on 06/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Core
import CoreData

/**
 VideoViewInteractor fetches all videos from database.
 It makes api call to increment video share count and updated in keychain
 */
class VideoViewInteractor{
    
    let videoContentTypeId: Int16 = 3
    
    /**
     Fetch all videos from db
     */
    func allVideoItemsFromDatabase(using managedObjectContext: NSManagedObjectContext) -> [VideoItem]{
        let videos = CoreDataService.sharedInstance.videoRepo(context: managedObjectContext).allVideos()
        var videoItems = [VideoItem]()
        for video in videos{
            let videoItem = VideoItem(id: video.id, name: video.name, videoDescription: video.video_description, thumbnailURL: video.thumbnail_url, videoURL: video.video_url, shareText: video.share_text, videoImageFileName: buildFileName(contentId: video.id, contentTypeId: videoContentTypeId, assetVersion: video.image_version))
            videoItems.append(videoItem)
        }
        return videoItems
    }
    
    /**
     Make api call to increment video share count
     */
    func incrementVideoShareCount(completionHandler:@escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void){
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: VideoUrlConstants.UPDATE_VIDEO_SHARE_COUNT_URL, params: nil, httpBody: ["videos_shared": videoCountToIncrement() as AnyObject], completionHandler: completionHandler)
    }
    
    /**
     Update video share count in keychain
     */
    func updateVideoShareCount(count: Int){
        KeyChainService.sharedInstance.setValue(string: String(count), key: ConfigKeys.VIDEO_COUNT_KEY)
    }
    
    /**
     Update share count of videos which is not synced with server - pending share count
     */
    func updateVideosToShareCount(){
        let count = videoCountToIncrement()
        KeyChainService.sharedInstance.setValue(string: String(count), key: ConfigKeys.VIDEOS_SHARE_COUNT_TO_UPDATE_KEY)
    }
    
    /**
     Delete pending share count once synced with server
     */
    func deletePendingShareCount(){
        KeyChainService.sharedInstance.setValue(string: String(0), key: ConfigKeys.VIDEOS_SHARE_COUNT_TO_UPDATE_KEY)
    }
    
    /**
     Get video share count to update with server including pending share count
     */
    private func videoCountToIncrement() -> Int{
        let shareCountToUpdate = KeyChainService.sharedInstance.getValue(key: ConfigKeys.VIDEOS_SHARE_COUNT_TO_UPDATE_KEY)
        return ((Int(shareCountToUpdate ?? "0") ?? 0) + 1)
    }
}
