//
//  ConfigurationKeys.swift
//  Core
//
//  Created by kunal singh on 27/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 Contains keychain data keys used throughout the project.
 */

public struct ConfigKeys {
    public static let META_SYNC_KEY = "status"
    public static let DATA_SYNC_NOTIFICATION = "data_sync_done"
    public static let ACCESS_TOKEN_KEY = "enparadigm.accessToken"
    public static let REFRESH_TOKEN_KEY = "enparadigm.refreshToken"
    public static let FAVOURITE_UPDATE_NOTIFICATION = "enparadigm.favouriteUpdate"
    public static let FAVOURITE_NOTIFICATION_DATA = "favouriteUpdateData"
    public static let POSTER_COUNT_KEY = "enparadigm.posterShareCount"
    public static let VIDEO_COUNT_KEY = "enparadigm.videoShareCount"
    public static let PDF_COUNT_KEY = "enparadigm.pdfShareCount"
    public static let PRESENTATION_COUNT_KEY = "enparadigm.presentationShareCount"
    public static let USER_DATA_KEY = "enparadigm.userData"
    public static let POSTERS_SHARE_COUNT_TO_UPDATE_KEY = "enparadigm.posterShareCountToUpdate"
    public static let VIDEOS_SHARE_COUNT_TO_UPDATE_KEY = "enparadigm.videoShareCountToUpdate"
    public static let PDFS_SHARE_COUNT_TO_UPDATE_KEY = "enparadigm.pdfShareCountToUpdate"
    public static let PRESENTATIONS_SHARE_COUNT_TO_UPDATE_KEY = "enparadigm.presentationShareCountToUpdate"
    public static let META_CONTENT_VERSION_KEY = "enparadigm.metaContentVersion"
    public static let LOOKUP_CONTENT_VERSION_KEY = "enparadigm.lookupContentVersion"
}
