//
//  Video.swift
//  Video
//
//  Created by Anurag Dake on 06/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 VideoItem is the UI model class to display videos
 It stores all video related data to display video item and play video
 */
public class VideoItem{
    var id: Int32!
    var name: String?
    var videoDescription: String?
    var thumbnailURL: String?
    var videoURL: String?
    var shareText: String?
    var imageVersion: Int32?
    var videoImageFileName: String?
    
    init(id: Int32, name: String?, videoDescription: String?, thumbnailURL: String?, videoURL: String?, shareText: String?, videoImageFileName: String?) {
        self.id = id
        self.name = name
        self.videoDescription = videoDescription
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
        self.shareText = shareText
        self.videoImageFileName = videoImageFileName
    }
    
    init() {}
}
