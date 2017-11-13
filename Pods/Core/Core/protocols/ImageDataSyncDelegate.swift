//
//  ImageDataSyncDelegate.swift
//  Core
//
//  Created by kunal singh on 27/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 ImageDataSyncDelegate helps to track image download progress.
 */

import Foundation

public protocol ImageDataSyncDelegate {
    func imageDataSyncingProgress(total: Int, downloaded: Int)
}

