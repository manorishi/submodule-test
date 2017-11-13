//
//  GalleryInteractor.swift
//  Directory
//
//  Created by Apple on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 GalleryInteractor interact with Repos to get data from local database and provide to presenter.
 */

import Foundation
import Core
import CoreData

class GalleryInteractor: BaseInteractor {
    
    /**
     Get gallery data from local database and sort data on GalleryHeader Id
     */
    func galleryData(managedObjectContext: NSManagedObjectContext) -> [[GalleryHeader: [DierctoryContent]]] {
        //initialize the variables
        var galleryArray: [[GalleryHeader: [DierctoryContent]]] = []
        let newItemMappers = super.newItems(using: managedObjectContext)
        let homeDirectoryContentMappers: [UserHomeDirectoryContentMapper] = CoreDataService.sharedInstance.userHomeDirectoryContentMapperRepo(context: managedObjectContext).userHomeDirectoryContents()
        let directoryContentMapperRepo = CoreDataService.sharedInstance.userDirectoryContentMapperRepo(context: managedObjectContext)
        let directoryRepo = CoreDataService.sharedInstance.directoryRepo(context: managedObjectContext)
        // set the data
        for homeDirectoryItem in homeDirectoryContentMappers {
            if let contentDataType = ContentDataType.enumFromContentTypeId(contentTypeId: homeDirectoryItem.content_type_id) {
                if contentDataType == ContentDataType.directory, let galleryHeader = directoryItem(contentId: homeDirectoryItem.content_id, sequence: homeDirectoryItem.sequence, directoryRepo: directoryRepo) {
                    var listItem:[GalleryHeader: [DierctoryContent]] = [:]
                    listItem[galleryHeader] = super.directoryContentsWithNewItems(userDirectoryContentMapperRepo: directoryContentMapperRepo, directoryId: homeDirectoryItem.content_id, managedObjectContext: managedObjectContext, newItems: newItemMappers)
                    galleryArray.append(listItem)
                }
            }
        }
        return galleryArray.sorted {
            let item1 = $0.keys.first?.uid ?? 0
            let item2 = $1.keys.first?.uid ?? 0
            return item1 < item2
        };
    }
    
    /**
     Get new items data from local database and sort data on sequence number.
     */
    func galleryDataContainingNewItems(managedObjectContext: NSManagedObjectContext) -> [[GalleryHeader: [DierctoryContent]]]{
        let newItemMappers = super.newItems(using: managedObjectContext)
        var galleryArray: [[GalleryHeader: [DierctoryContent]]] = []
        let favouritesItemsArray = allFavouriteItems(managedObjectContext: managedObjectContext)
        var contentsArray = [DierctoryContent]()
        for newItem in newItemMappers {
            let contentId = newItem.content_id
            if let content = super.contentFromTypeId(contentTypeId: newItem.content_type_id, contentId: contentId, managedObjectContext: managedObjectContext){
                content.sequence = Int(newItem.sequence)
                if let _ = favouritesItemsArray.first(where: {
                    return ($0.content_id == content.id) && ($0.content_type_id == content.contentTypeId)
                }) {
                    content.isFavourite = true
                }
                contentsArray.append(content)
            }
        }
        contentsArray.sort { $0.sequence! < $1.sequence! }
        var listItem:[GalleryHeader: [DierctoryContent]] = [:]
        listItem[GalleryHeader.init(uid: 0, name: contentsArray.count != 0 ? StringUtils.whatsNew : "", description: "")] = contentsArray
        galleryArray.append(listItem)
        return galleryArray
    }
    
    private func directoryItem(contentId: Int32, sequence: Int16, directoryRepo: DirectoryRepo) -> GalleryHeader?{
        if let directory = directoryRepo.directoryHavingId(directoryId: contentId){
            return GalleryHeader.init(uid: Int(sequence), name: directory.name ?? "", description: directory.directory_description ?? "")
        }
        return nil
    }
    
}
