//
//  MetaPresentationDisplayData+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Apple on 28/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaPresentationDisplayData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaPresentationDisplayData> {
        return NSFetchRequest<MetaPresentationDisplayData>(entityName: "MetaPresentationDisplayData");
    }

    @NSManaged public var general_presentation_top_image1: String?
    @NSManaged public var liquidity_heading: String?
    @NSManaged public var liquidity_icon: String?
    @NSManaged public var liquidity_intro: String?
    @NSManaged public var presentation_page2_disclaimer: String?
    @NSManaged public var presentation_page2_heading: String?
    @NSManaged public var presentation_page3_disclaimer: String?
    @NSManaged public var presentation_page3_heading: String?
    @NSManaged public var product_label_icon: String?
    @NSManaged public var selection_page1_disclaimer: String?
    @NSManaged public var selection_page2_disclaimer: String?
    @NSManaged public var selection_page3_disclaimer: String?
    @NSManaged public var suggestion_heading: String?
    @NSManaged public var tenure_heading: String?
    @NSManaged public var tenure_icon: String?
    @NSManaged public var tenure_intro: String?

}
