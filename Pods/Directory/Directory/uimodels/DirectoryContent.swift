//
//  directory.swift
//  Directory
//
//  Created by kunal singh on 23/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import Core

public class DierctoryContent {
    var id: Int32!
    var name: String?
    var contentDescription: String?
    var thumbnailURL: String?
    var assetURL: String?
    var shareText: String?
    var sequence: Int?
    var contentTypeId: Int16!
    var contentTypeName: String?
    var contentTypeImageName: String?
    var directoryDisplayType: Int?
    var isNewContent: Bool = false
    var imageFileName: String?
    var pdfFileName: String?
    var isFavourite: Bool = false
    var isConfidential: Bool = false
    
    init(id: Int32, name: String?, contentDescription: String?, thumbnailURL: String?, assetURL: String?, shareText: String?, sequence: Int?, contentTypeId: Int16, contentTypeName: String?, contentTypeImageName: String?, directoryDisplayType: Int?, isNewContent: Bool, imageFileName: String?, pdfFileName: String?,isFavourite: Bool, isConfidential: Bool = false) {
        self.id = id
        self.name = name
        self.contentDescription = contentDescription
        self.thumbnailURL = thumbnailURL
        self.assetURL = assetURL
        self.shareText = shareText
        self.sequence = sequence
        self.contentTypeId = contentTypeId
        self.contentTypeName = contentTypeName
        self.contentTypeImageName = contentTypeImageName
        self.directoryDisplayType = directoryDisplayType
        self.isNewContent = isNewContent
        self.imageFileName = imageFileName
        self.pdfFileName = pdfFileName
        self.isFavourite = isFavourite
        self.isConfidential = isConfidential
    }
    
    init() {}
}


