//
//  MetaCategoryQuestions+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Apple on 28/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaCategoryQuestions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaCategoryQuestions> {
        return NSFetchRequest<MetaCategoryQuestions>(entityName: "MetaCategoryQuestions");
    }

    @NSManaged public var answer: String?
    @NSManaged public var cat_id: String?
    @NSManaged public var question: String?
    @NSManaged public var question_no: Int32

}
