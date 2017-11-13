//
//  VideoRepo.swift
//  Core
//
//  Created by kunal singh on 21/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 VideoRepo perform CRUD operation on Video entity.
 */

import Foundation
import CoreData

public class VideoRepo {
    private var managedContext: NSManagedObjectContext?
    private let entityName: String = "Video"
    
    init(managedContext: NSManagedObjectContext?) {
        self.managedContext = managedContext
    }
    
    private func videoObjectFromDictionary(video: Dictionary<String, Any>) -> Video{
        let videoManagedObject = Video(entity: NSEntityDescription.entity(forEntityName: entityName, in: managedContext!)!, insertInto: managedContext!)
        if let videoId = video["id"] {
            videoManagedObject.id =  videoId as? Int32 ?? 0
        }
        if let name = video["name"] {
            videoManagedObject.name =  name as? String ?? ""
        }
        if let description = video["description"]{
            videoManagedObject.video_description = description as? String ?? ""
        }
        if let shareText = video["shareText"]{
            videoManagedObject.share_text = shareText as? String ?? ""
        }
        if let thumbnailUrl = video["thumbnailUrl"]{
            videoManagedObject.thumbnail_url = thumbnailUrl as? String ?? ""
        }
        if let imageVersion = video["imageVersion"]{
            videoManagedObject.image_version = imageVersion as? Int32 ?? 0
        }
        if let videoUrl = video["videoUrl"]{
            videoManagedObject.video_url = videoUrl as? String ?? ""
        }
        return videoManagedObject
    }
    
    
    func createVideos(videosArray: [Dictionary<String, Any>]) -> Bool{
        for video:Dictionary in videosArray {
            if !createEntry(object: videoObjectFromDictionary(video: video)){
                return false
            }
        }
        return true
    }
    
    func deleteVideos() -> Bool{
        return deleteEntry(entityName: entityName, context: managedContext)
    }
    
    public func videoHavingId(videoId: Int32) -> Video?{
        return readEntry(condition: NSPredicate(format: "id == %d", videoId), entity: entityName, context: managedContext) as? Video ?? nil
    }

    public func allVideos() -> [Video]{
        return readAllEntries(entity: entityName, context: managedContext) as? [Video] ?? []
    }
    
}
