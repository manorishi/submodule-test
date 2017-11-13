//
//  NetworkUtils.swift
//  smartsell
//
//  Created by Apple on 12/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

/**
 Used to retrieve error title and message from response.
 */

public class NetworkUtils {
    
    private static let ERROR_MESSAGE_KEY = "message"
    private static let ERROR_TITLE_KEY = "title"
    private static let ERROR_MESSAGE = "Something went wrong. Please retry"
    private static let ERROR_TITLE = "Error!"
    
    public static func errorMessage(response:[String:AnyObject]?) -> String {
        if let errorMsg = response?[NetworkUtils.ERROR_MESSAGE_KEY] as? String {
            return errorMsg
        }
        else {
            return ERROR_MESSAGE
        }
    }
    
    public static func errorTitle(response:[String:AnyObject]?) -> String {
        if let errorTitle = response?[NetworkUtils.ERROR_TITLE_KEY] as? String {
            return errorTitle
        }
        else {
            return ERROR_TITLE
        }
    }
}
