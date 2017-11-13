//
//  ObjectMapper.swift
//  Core
//
//  Created by kunal singh on 17/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

/**
 ObjectMapper will map the response from server in the required format such as JSON.
 */

class ObjectMapper: NSObject {
    
    func getJSON(from data:Data?) -> [String:AnyObject]?{
        guard let responseData = data else{
            return nil
        }
        do{
            let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) as? [String : AnyObject]
            return responseJSON
        }catch{
            return nil
        }
    }
    
    func getHtml(from data:Data?) -> String?{
        guard let responseData = data else{
            return nil
        }
        return String(data: responseData, encoding: String.Encoding.utf8)
    }
}

