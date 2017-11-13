//
//  ResponseValidator.swift
//  Core
//
//  Created by kunal singh on 17/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

/**
 ResponseValidator validate network request reponse from http status code and response code.
 */

class ResponseValidator: NSObject {
    
    private let DEFAULT_ERROR_KEY = "message"
    private let DEFAULT_ERROR_MESSAGE = "An error occured"
    
    func responseWithValidation(response: URLResponse?, data: Data?, error: Error?, objectMapper: ObjectMapper) -> (responseStatus: ResponseStatus, responseData: [String: AnyObject]){
        
        guard error == nil && response != nil else {
            return (.error, defaultErrorDictionary())
        }
        guard let httpStatus = response as? HTTPURLResponse else {
            return (.error, defaultErrorDictionary())
        }
        
        let httpStatusCode = httpStatus.statusCode
        let jsonData = objectMapper.getJSON(from: data)
        let responseCode: Int? = jsonData?["code"] as? Int
        
        if httpStatusCode == 200 && responseCode == nil {
            return (.success, jsonData ?? [:])
        }
        if httpStatusCode != 200 && responseCode == nil {
            return (.error, defaultErrorDictionary())
        }
        if responseCode != nil{
            let jsonResponse = jsonData ?? [:]
            switch (httpStatusCode, responseCode!) {
            case (200, 200), (200, 700):
                return (.success, jsonResponse)
            case (401, 701), (401, 704), (401, 703), (400, 400), (500, 702):
                return (.error, jsonResponse)
            case (401, 401):
                UpdateToken().updateTokens(with: jsonResponse)
                return (.unauthorised, jsonResponse)
            case (403, 403):
                return (.forbidden, jsonResponse)
                
            case(200, _): return (.success, jsonResponse)
            case(_, _): return (.error, jsonResponse)
            }
        }
        return (.error, defaultErrorDictionary())
    }
    
    func htmlResponseWithValidation(response: URLResponse?, data: Data?, error: Error?, objectMapper: ObjectMapper) -> (responseStatus: ResponseStatus, responseData: String){
        guard error == nil && response != nil else {
            return (.error, DEFAULT_ERROR_MESSAGE)
        }
        guard let httpStatus = response as? HTTPURLResponse else {
            return (.error, DEFAULT_ERROR_MESSAGE)
        }
        
        let httpStatusCode = httpStatus.statusCode
        let htmlData = objectMapper.getHtml(from: data)
        return (httpStatusCode == 200 ? (.success, htmlData ?? "") : (.error, DEFAULT_ERROR_MESSAGE))
    }
    
    private func defaultErrorDictionary() -> [String : AnyObject] {
        var defaultError = [String : AnyObject]()
        defaultError[DEFAULT_ERROR_KEY] = DEFAULT_ERROR_MESSAGE as AnyObject?
        return defaultError
    }
    
    func isUnauthorised(responseStatus: ResponseStatus) -> Bool {
        if responseStatus == .unauthorised{
            return true
        }
        return false
    }
}
