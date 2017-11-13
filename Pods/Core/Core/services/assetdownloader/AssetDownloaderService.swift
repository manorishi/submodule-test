//
//  ImageDownloaderService.swift
//  Core
//
//  Created by kunal singh on 27/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

public class AssetDownloaderService {
    public static let sharedInstance = AssetDownloaderService()
    public var coreImageDownloader: CoreImageDownloader
    public var corePdfDownloader: PdfDownloader
    
    private init() {
        coreImageDownloader = CoreImageDownloader()
        corePdfDownloader = PdfDownloader()
    }
    
}
