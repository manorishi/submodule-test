//
//  ActionSheetCallbackProtocol.swift
//  Poster
//
//  Created by Anurag Dake on 03/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation

/**
 Callback for buttons in ActionSheet
 */
protocol ActionSheetCallbackProtocol {
    func cameraButtonPressed()
    func galleryButtonPressed()
    func deleteButtonPressed()
}
