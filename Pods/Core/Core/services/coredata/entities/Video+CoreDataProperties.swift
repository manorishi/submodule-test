//
//  Video+CoreDataProperties.swift
//  
//
//  Created by kunal singh on 07/09/17.
//
//

import Foundation
import CoreData


extension Video {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video")
    }

    @NSManaged public var id: Int32
    @NSManaged public var image_version: Int32
    @NSManaged public var name: String?
    @NSManaged public var share_text: String?
    @NSManaged public var thumbnail_url: String?
    @NSManaged public var video_description: String?
    @NSManaged public var video_url: String?

}
