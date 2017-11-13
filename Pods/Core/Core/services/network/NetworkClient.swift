//
//  NetworkClient.swift
//  Core
//
//  Created by kunal singh on 17/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

/**
 NetworkClient perform all network operations like GET, POST network request.
 */

public class NetworkClient: NSObject{
    
    let responseValidator: ResponseValidator!
    let objectMapper: ObjectMapper!
    let networkChecker: NetworkChecker!
    
    let NETWORK_ERROR_TITLE = "Network Error!"
    let NETWORK_ERROR_MESSAGE = "Please check your internet connection."
    
    override init() {
        responseValidator = ResponseValidator()
        objectMapper = ObjectMapper()
        networkChecker = NetworkChecker()
    }
    
    /**
     Perform GET network request.
     */
    public func doGETRequest(requestURL: String, params: [String:AnyObject]?,httpBody:[String:AnyObject]?, completionHandler:@escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void){
        if networkChecker.isConnectedToNetwork(){
            doNetworkRequest(requestType: "GET", requestURL: requestURL, params: params,httpBody: httpBody, completionHandler: completionHandler)
        }else{
            completionHandler(.error, networkNotConnectedDictionary())
        }
    }
    
    /**
     Perform GET network request to fetch plain text.
     */
    public func doHtmlRequest(requestType: String, requestURL: String, headers: [String:String]? = nil, params: [String:AnyObject]? = nil, httpBody:[String:AnyObject]? = nil, completionHandler:@escaping (_ status: ResponseStatus, _ response: String?) -> Void){
        if networkChecker.isConnectedToNetwork(){
            let request = NSMutableURLRequest()
            request.url = URL.init(string: requestURL)
            request.httpMethod = requestType
            setHeaders(request: request, headers: headers)
            setRequestParams(request: request, params: params,httpBody: httpBody)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                let validatedResponse = self.responseValidator.htmlResponseWithValidation(response: response, data: data, error: error, objectMapper: self.objectMapper)
                completionHandler(validatedResponse.responseStatus, validatedResponse.responseData)
            }
            task.resume()
        }else{
            completionHandler(.error, nil)
        }
    }
    
    func setHeaders(request: NSMutableURLRequest, headers: [String:String]?){
        guard let headerList = headers else {
            return
        }
        for item in headerList{
            request.addValue(item.value, forHTTPHeaderField: item.key)
        }
    }
    
    /**
     Perform POST network request.
     */
    public func doPOSTRequest(requestURL: String, params: [String:AnyObject]?,httpBody:[String:AnyObject]?, completionHandler:@escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void){
        if networkChecker.isConnectedToNetwork(){
            doNetworkRequest(requestType: "POST", requestURL: requestURL, params: params,httpBody: httpBody, completionHandler: completionHandler)
        }else{
            completionHandler(.error, networkNotConnectedDictionary())
        }
    }
    
    private func doNetworkRequest(requestType: String, requestURL: String, params: [String:AnyObject]?, httpBody:[String:AnyObject]?, completionHandler:@escaping (_ status: ResponseStatus,_ response: [String:AnyObject]?) -> Void){
        let request = NSMutableURLRequest()
        request.url = URL.init(string: requestURL)
        request.httpMethod = requestType
        setRequestParams(request: request, params: params,httpBody: httpBody)
        createDataTask(with: request, completionHandler: completionHandler)
    }
    
    /**
     Perform POST network request with stored auth and refresh token.
     */
    public func doPOSTRequestWithTokens(requestURL: String, params: [String:AnyObject]?,httpBody:[String:AnyObject]?, completionHandler:@escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void){
        let token = tokens()
        var httpBodyWithTokens = httpBody ?? [:]
        httpBodyWithTokens["access_token"] = token.accessToken as AnyObject?
        httpBodyWithTokens["refresh_token"] = token.refreshToken as AnyObject?
        doNetworkRequest(requestType: "POST", requestURL: requestURL, params: params,httpBody: httpBodyWithTokens) {[weak self] (responseStatus, data) in
            if self?.responseValidator.isUnauthorised(responseStatus: responseStatus) ==  true{
                self?.doPOSTRequestWithTokens(requestURL: requestURL, params: params, httpBody: httpBody, completionHandler: completionHandler)
            }else{
                completionHandler(responseStatus, data)
            }
        }
    }
    
    /**
     Retrieve access and refresh token from keychain.
     */
    private func tokens() -> (accessToken: String, refreshToken: String){
        let accessToken: String = KeyChainService.sharedInstance.getValue(key: ConfigKeys.ACCESS_TOKEN_KEY) ?? ""
        let refreshToken: String = KeyChainService.sharedInstance.getValue(key: ConfigKeys.REFRESH_TOKEN_KEY) ?? ""
        return (accessToken, refreshToken)
    }
    
    private func setRequestParams(request: NSMutableURLRequest, params: [String:AnyObject]?,httpBody:[String:AnyObject]?){
        do {
            if let httpBody = httpBody,  httpBody.count > 0 {
                let httpBodyString = (httpBody.flatMap({ (key, value) -> String in
                    return "\(key)=\(value)"
                }) as Array).joined(separator: "&")
                let encodedUrl = httpBodyString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                request.httpBody = encodedUrl?.data(using: .utf8, allowLossyConversion: true)
            }
        }
            if let params = params,  params.count > 0 {
                var urlWithParam = (request.url?.absoluteString)! + "?"
                for (index,param) in params.enumerated() {
                    urlWithParam.append("\(param.key)=\(param.value)")
                    if index < (params.count - 1){
                        urlWithParam.append("&")
                    }
                }
                let encodedUrl = urlWithParam.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                request.url = URL(string: encodedUrl ?? "")
            }
    }
    
    private func createDataTask(with request: NSMutableURLRequest, completionHandler:@escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void){
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            let validatedResponse = self.responseValidator.responseWithValidation(response: response, data: data, error: error, objectMapper: self.objectMapper)
            completionHandler(validatedResponse.responseStatus, validatedResponse.responseData)
            
        }
        task.resume()
    }
    
    private func networkNotConnectedDictionary() -> [String:AnyObject]{
        var networkErrorDictionary = [String:AnyObject]()
        networkErrorDictionary["title"] = NETWORK_ERROR_TITLE as AnyObject?
        networkErrorDictionary["message"] = NETWORK_ERROR_MESSAGE as AnyObject?
        return networkErrorDictionary
    }
    
    public func uploadImage(requestURL: String, params: [String:AnyObject]?,httpBody:[String:AnyObject]?, image:UIImage, completionHandler:@escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void){
        let request = NSMutableURLRequest()
        request.url = URL.init(string: requestURL)
        request.httpMethod = "POST"
        let token = tokens()
        var paramsWithTokens = params ?? [:]
        paramsWithTokens["access_token"] = token.accessToken as AnyObject?
        paramsWithTokens["refresh_token"] = token.refreshToken as AnyObject?
        setRequestParams(request: request, params: paramsWithTokens, httpBody: httpBody)
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBodyWithParameters(textParameters: httpBody, imageParameter: ["profile_image":image], boundary: boundary)

        let task = URLSession.shared.dataTask(with: request as URLRequest) {[weak self] (data, response, error) in
            if let validatedResponse = self?.responseValidator.responseWithValidation(response: response, data: data, error: error, objectMapper: (self?.objectMapper)!){
                if self?.responseValidator.isUnauthorised(responseStatus: validatedResponse.responseStatus) ==  true{
                    self?.uploadImage(requestURL: requestURL, params: params, httpBody: httpBody, image: image, completionHandler: completionHandler)
                }else{
                    completionHandler(validatedResponse.responseStatus, validatedResponse.responseData)
                }
            }
        }
        task.resume()
    }
    
    private func createBodyWithParameters(textParameters: [String:AnyObject]?, imageParameter: [String:AnyObject]?, boundary: String) -> Data {
        let body = NSMutableData()
        if textParameters != nil {
            for (keys, value) in textParameters! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(keys)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        if imageParameter != nil {
            for (key, value) in imageParameter! {
                if let image = value as? UIImage {
                    let imageData = UIImageJPEGRepresentation(image, 1)
                    if (imageData == nil) {
                        continue
                    }
                    let filename = "image\(Int(NSDate().timeIntervalSince1970)).jpg"
                    let mimetype = "image/jpg"
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
                    body.append(imageData!)
                    body.append("\r\n".data(using: String.Encoding.utf8)!)
                }
            }
        }
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        return body as Data
    }
    
}
