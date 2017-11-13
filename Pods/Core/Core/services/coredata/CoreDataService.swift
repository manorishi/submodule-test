//
//  CoreDataService.swift
//  Core
//
//  Created by kunal singh on 17/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 CoreDataService create instances of Repo's.
 */

import Foundation
import CoreData

public class CoreDataService {
    public let persistentStoreCoordinator : NSPersistentStoreCoordinator?
    private let databaseName: String = "SmartSell"
    private let bundleIdentifier: String = "org.cocoapods.Core"
    
    public static let sharedInstance = CoreDataService()
    
    private init() {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let applicationDocumentsDirectoryurls: NSURL = urls[urls.count - 1] as NSURL
        let coreKitBundle = Bundle(identifier: bundleIdentifier)
        let managedObjectModel = NSManagedObjectModel(contentsOf: coreKitBundle!.url(forResource: databaseName, withExtension: "momd")!)!
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = applicationDocumentsDirectoryurls.appendingPathComponent(databaseName + ".sqlite")
        do {
            try persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let  error as NSError {
            logToConsole(printObject: error.localizedDescription)
            abort()
        }
    }
    
    public func posterRepo(context: NSManagedObjectContext) -> PosterRepo{
        return PosterRepo.init(managedContext: context)
    }
    
    public func contentTypeRepo(context: NSManagedObjectContext) -> ContentTypeRepo{
        return ContentTypeRepo.init(managedContext: context)
    }
    
    public func videoRepo(context: NSManagedObjectContext) -> VideoRepo{
        return VideoRepo.init(managedContext: context)
    }
    
    public func pdfRepo(context: NSManagedObjectContext) -> PdfRepo{
        return PdfRepo.init(managedContext: context)
    }
    
    public func directoryRepo(context: NSManagedObjectContext) -> DirectoryRepo{
        return DirectoryRepo.init(managedContext: context)
    }
    
    public func newItemMapperRepo(context: NSManagedObjectContext) -> NewItemMapperRepo{
        return NewItemMapperRepo.init(managedContext: context)
    }
    
    public func directoryDisplayTypeRepo(context: NSManagedObjectContext) -> DirectoryDisplayTypeRepo{
        return DirectoryDisplayTypeRepo.init(managedContext: context)
    }
    
    public func posterTextElementsRepo(context: NSManagedObjectContext) -> PosterTextElementsRepo{
        return PosterTextElementsRepo.init(managedContext: context)
    }
    
    public func posterImageElementsRepo(context: NSManagedObjectContext) -> PosterImageElementsRepo{
        return PosterImageElementsRepo.init(managedContext: context)
    }
    
    public func userDirectoryContentMapperRepo(context: NSManagedObjectContext) -> UserDirectoryContentMapperRepo{
        return UserDirectoryContentMapperRepo.init(managedContext: context)
    }
    
    public func userHomeDirectoryContentMapperRepo(context: NSManagedObjectContext) -> UserHomeDirectoryContentMapperRepo{
        return UserHomeDirectoryContentMapperRepo.init(managedContext: context)
    }
    
    public func favouriteRepo(context: NSManagedObjectContext) -> FavouriteRepo{
        return FavouriteRepo.init(managedContext: context)
    }
    
    public func userAchievementRepo(context: NSManagedObjectContext) -> UserAchievementRepo{
        return UserAchievementRepo.init(managedContext: context)
    }
    
    public func achievementRepo(context: NSManagedObjectContext) -> AchievementRepo{
        return AchievementRepo.init(managedContext: context)
    }
    
    public func mfNotificationRepo(context: NSManagedObjectContext) -> MFNotificationRepo {
        return MFNotificationRepo.init(managedContext: context)
    }
    
    public func userHomePageMapperRepo(context: NSManagedObjectContext) -> UserHomePageMapperRepo {
        return UserHomePageMapperRepo.init(managedContext: context)
    }
    
    public func userHomeBannerMapperRepo(context: NSManagedObjectContext) -> UserHomeBannerMapperRepo {
        return UserHomeBannerMapperRepo.init(managedContext: context)
    }

}
