//
//  MetaMutualFundSelection+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Apple on 28/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaMutualFundSelection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaMutualFundSelection> {
        return NSFetchRequest<MetaMutualFundSelection>(entityName: "MetaMutualFundSelection");
    }

    @NSManaged public var id: String?
    @NSManaged public var lockin_flag: String?
    @NSManaged public var max_age: Int16
    @NSManaged public var max_duration: Int16
    @NSManaged public var min_age: Int16
    @NSManaged public var min_duration: Int16
    @NSManaged public var risk_appetite: String?
    @NSManaged public var slot1: Float
    @NSManaged public var slot2: Float
    @NSManaged public var slot3: Float
    @NSManaged public var slot4: Float
    @NSManaged public var slot5: Float
    @NSManaged public var slot6: Float

}
