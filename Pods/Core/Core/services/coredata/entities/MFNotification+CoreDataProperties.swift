//
//  MFNotification+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension MFNotification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MFNotification> {
        return NSFetchRequest<MFNotification>(entityName: "MFNotification")
    }

    @NSManaged public var body: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var title: String?

}
