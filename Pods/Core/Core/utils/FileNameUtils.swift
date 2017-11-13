//
//  FileNameUtils.swift
//  Core
//
//  Created by kunal singh on 29/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 Used to create file name from content id, content type id and assets version.
 */
public func buildFileName(contentId: Int32, contentTypeId: Int16, assetVersion: Int32) -> String?{
    if let contentType = ContentDataType.enumFromContentTypeId(contentTypeId: contentTypeId){
        return String(contentId) + CoreConstants.IMAGE_URL_SEPARATOR + String(contentType.rawValue) + CoreConstants.IMAGE_URL_SEPARATOR + String(assetVersion)
    }
    return nil
}

/**
 Used to create file name from content id, content type and assets version.
 */
func buildFileName(contentId: Int32, contentType: ContentDataType, assetVersion: Int32) -> String {
    return String(contentId) + CoreConstants.IMAGE_URL_SEPARATOR + String(contentType.rawValue) + CoreConstants.IMAGE_URL_SEPARATOR + String(assetVersion)
}




