//
//  PosterInteractor.swift
//  Poster
//
//  Created by Anurag Dake on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 PosterInteractor perform all database operation like getting poster elements data from local database and updating share count.
 */

import Foundation
import Core
import CoreData

class PosterInteractor{

    /**
     Get poster images element data.
     */
    func postersImageElementsData(posterId: Int32, managedObjectContext: NSManagedObjectContext) -> [PosterImageElementModel] {
        var elementsArray:[PosterImageElementModel] = []
        let posterImageElements: [PosterImageElement] = CoreDataService.sharedInstance.posterImageElementsRepo(context: managedObjectContext).posterImageElementsHavingPosterId(posterId: posterId)
        for posterImage in posterImageElements {
            let elementShape = ElementShapes.enumFromShapes(shape: posterImage.shape ?? "")
            let posterElement = PosterImageElementModel.init(id: posterImage.id, posterId: posterImage.poster_id, leftMargin: posterImage.left_margin, onByDefault: posterImage.on_by_default, topMargin: posterImage.top_margin, height: posterImage.height, keep_aspect_ratio: posterImage.keep_aspect_ratio, shape: elementShape, width: posterImage.width)
            elementsArray.append(posterElement)
        }
        return elementsArray
    }
    
    /**
     Get poster texts element data.
     */
    func postersTextElementsData(posterId: Int32, managedObjectContext: NSManagedObjectContext) -> [PosterTextElementModel] {
        var elementsArray:[PosterTextElementModel] = []
        let posterTextElements: [PosterTextElement] = CoreDataService.sharedInstance.posterTextElementsRepo(context: managedObjectContext).posterTextElementsHavingPosterId(posterId: posterId)
        for posterText in posterTextElements{
            let textAlignment = ElementTextAlignment.enumFromTextAlignment(alignment: posterText.text_alignment ?? "")
            let posterElement = PosterTextElementModel.init(id: posterText.id, posterId: posterText.poster_id, leftMargin: posterText.left_margin, onByDefault: posterText.on_by_default, topMargin: posterText.top_margin, rightMargin: posterText.right_margin, defaultText: posterText.default_text, fontColor: posterText.font_color, fontFamily: posterText.font_family, fontSize: posterText.font_size, textAlignment: textAlignment)
            elementsArray.append(posterElement)
        }
        return elementsArray
    }

    /**
     Make api call to increment poster share count
     */
    func incrementPosterShareCount(completionHandler:@escaping (_ status: ResponseStatus, _ response: [String:AnyObject]?) -> Void) {
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: PosterUrlConstants.UPDATE_POSTER_SHARE_COUNT_URL, params: nil, httpBody: ["posters_shared": posterCountToIncrement() as AnyObject], completionHandler: completionHandler)
    }
    
    /**
     Update poster share count in keychain
     */
    func updatePosterShareCount(count: Int) {
        KeyChainService.sharedInstance.setValue(string: String(count), key: ConfigKeys.POSTER_COUNT_KEY)
    }
    
    /**
     Update share count of posters which is not synced with server - pending share count
     */
    func updatePostersToShareCount() {
        let count = posterCountToIncrement()
        KeyChainService.sharedInstance.setValue(string: String(count), key: ConfigKeys.POSTERS_SHARE_COUNT_TO_UPDATE_KEY)
    }
    
    /**
     Delete pending share count once synced with server
     */
    func deletePendingShareCount() {
        KeyChainService.sharedInstance.setValue(string: String(0), key: ConfigKeys.POSTERS_SHARE_COUNT_TO_UPDATE_KEY)
    }
    
    /**
     Get poster share count to update with server including pending share count
     */
    private func posterCountToIncrement() -> Int{
        let shareCountToUpdate = KeyChainService.sharedInstance.getValue(key: ConfigKeys.POSTERS_SHARE_COUNT_TO_UPDATE_KEY)
        return ((Int(shareCountToUpdate ?? "0") ?? 0) + 1)
    }

}
