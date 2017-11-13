//
//  DirectoryInteractor.swift
//  Directory
//
//  Created by kunal singh on 23/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

/**
 DirectoryInteractor get directories data from local database.
 */

import Foundation
import Core
import CoreData

class DirectoryInteractor: BaseInteractor {
    
    override
    func homeDirectoryContents(using managedObjectContext: NSManagedObjectContext) -> [DierctoryContent]{
        return super.homeDirectoryContents(using: managedObjectContext)
    }
    
    override
    func directoryContents(with directoryId: Int32, using managedObjectContext: NSManagedObjectContext) -> [DierctoryContent]{
        return super.directoryContents(with: directoryId, using: managedObjectContext)
    }
    
    override func favouriteContents(contentTypeId: Int16, managedObjectContext: NSManagedObjectContext) -> [DierctoryContent] {
        return super.favouriteContents(contentTypeId: contentTypeId, managedObjectContext: managedObjectContext)
    }
}
