//
//  FavouriteChildInterator.swift
//  smartsell
//
//  Created by Apple on 14/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core
import CoreData

/**
 FavouriteChildInterator contains methods to get favourite data from local db
 */
class FavouriteChildInterator {
    
    func favouriteDirectoryData(managedObjectContext:NSManagedObjectContext) -> [Favourite]{
        let favouriteRepo = CoreDataService.sharedInstance.favouriteRepo(context:managedObjectContext)
        return favouriteRepo.favouriteWithContentTypeId(Int16(ContentDataType.directory.rawValue))
    }

    func favouritePosterData(managedObjectContext:NSManagedObjectContext) -> [Favourite] {
        let favouriteRepo = CoreDataService.sharedInstance.favouriteRepo(context:managedObjectContext)
        return favouriteRepo.favouriteWithContentTypeId(Int16(ContentDataType.poster.rawValue))
    }
    
    func favouriteVideoData(managedObjectContext:NSManagedObjectContext) -> [Favourite] {
        let favouriteRepo = CoreDataService.sharedInstance.favouriteRepo(context:managedObjectContext)
        return favouriteRepo.favouriteWithContentTypeId(Int16(ContentDataType.video.rawValue))
    }
    
    func favouritePdfData(managedObjectContext:NSManagedObjectContext) -> [Favourite] {
        let favouriteRepo = CoreDataService.sharedInstance.favouriteRepo(context:managedObjectContext)
        return favouriteRepo.favouriteWithContentTypeId(Int16(ContentDataType.pdf.rawValue))
    }
}
