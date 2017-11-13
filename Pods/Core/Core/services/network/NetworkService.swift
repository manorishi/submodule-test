//
//  NetworkService.swift
//  Core
//
//  Created by kunal singh on 17/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 NetworkService create instance of NetworkClient.
 */

public class NetworkService {
    
    public static let sharedInstance = NetworkService()
    public let networkClient: NetworkClient?
    
    private init() {
        networkClient = NetworkClient()
    }
    
}
