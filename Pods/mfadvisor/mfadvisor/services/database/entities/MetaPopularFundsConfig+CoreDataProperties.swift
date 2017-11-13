//
//  MetaPopularFundsConfig+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Apple on 28/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaPopularFundsConfig {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaPopularFundsConfig> {
        return NSFetchRequest<MetaPopularFundsConfig>(entityName: "MetaPopularFundsConfig");
    }

    @NSManaged public var fund_id: String?
    @NSManaged public var position: Int32

}
