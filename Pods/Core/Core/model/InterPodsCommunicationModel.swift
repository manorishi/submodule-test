//
//  InterPodsCommunicationModel.swift
//  Core
//
//  Created by kunal singh on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 This model is used to communicate between two module like directory to video.
 */

public class InterPodsCommunicationModel {
    public var id: Int32!
    public var name: String?
    public var contentDescription: String?
    public var assetFileName: String?
    public var assetUrl: String?
    public var shareText: String?
    public var thumbnailUrl: String?
    
    public init(id: Int32, name: String?, contentDescription: String?, assetFileName: String?, assetUrl: String?, shareText: String?, thumbnailUrl: String?) {
        self.id = id
        self.name = name
        self.contentDescription = contentDescription
        self.assetFileName = assetFileName
        self.assetUrl = assetUrl
        self.shareText = shareText
        self.thumbnailUrl = thumbnailUrl
    }
    
    public init() {}
    
}
