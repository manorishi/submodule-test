//
//  EnumUtils.swift
//  Core
//
//  Created by Anurag Dake on 21/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 Contains Enums used in more than one module.
 */

public enum NetworkStatus {
    case connected
    case disconnected
}

public enum AchievementType: Int {
    case marketingMaterial
    case fundSelector
}

public enum ResponseStatus {
    case success
    case error
    case forbidden
    case unauthorised //Not to be used by viewcontrollers, presenters and interactors
}

public enum ElementShapes: Int {
    case circle, rectangle
    
    public static func enumFromShapes(shape:String) -> ElementShapes?{
        if shape == CoreConstants.IMAGE_ELEMENT_SHAPE_CIRCLE{
            return circle
        }else if shape == CoreConstants.IMAGE_ELEMENT_SHAPE_RECTANGLE{
            return rectangle
        }
        return nil
    }
}

public enum ElementTextAlignment: Int {
    case left, center, right
    
    public static func enumFromTextAlignment(alignment:String) -> ElementTextAlignment?{
        if alignment == CoreConstants.LEFT_TEXT_ALIGNMENT{
            return left
        }else if alignment == CoreConstants.CENTER_TEXT_ALIGNMENT{
            return center
        }else if alignment == CoreConstants.RIGHT_TEXT_ALIGNMENT{
            return right
        }
        return nil
    }
}

/**
 Used to know content type.
 */
public enum ContentDataType: Int {
    case directory = 1
    case poster = 2
    case video = 3
    case pdf = 4
    
    public static func enumFromContentTypeId(contentTypeId:Int16) -> ContentDataType?{
        switch contentTypeId {
        case 1:
            return directory
        case 2:
            return poster
        case 3:
            return video
        case 4:
            return pdf
        default:
            return nil
        }
    }
}

public enum AnnouncementTarget:String {
    case profile = "profile"
    case allItems = "all_items"
    case favourites = "favorites"
    case leaderboard = "leaderboard"
    case notifications = "notifications"
    case editAccount = "edit_account"
    case directory = "directory"
    case poster = "poster"
    case video = "video"
    case pdf = "pdf"
    
    public static func announcementTargetEnumFromString(string:String) -> AnnouncementTarget?{
        switch string {
        case "profile":
            return profile
        case "all_items":
            return allItems
        case "favorites":
            return favourites
        case "leaderboard":
            return leaderboard
        case "notifications":
            return notifications
        case "edit_account":
            return editAccount
        case "directory":
            return directory
        case "poster":
            return poster
        case "video":
            return video
        case "pdf":
            return pdf
        default:
            return nil
        }
    }
}

