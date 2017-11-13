//
//  MetaFundQuestions+CoreDataProperties.swift
//  mfadvisor
//
//  Created by Apple on 28/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import CoreData


extension MetaFundQuestions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaFundQuestions> {
        return NSFetchRequest<MetaFundQuestions>(entityName: "MetaFundQuestions");
    }

    @NSManaged public var answer_bottomline: String?
    @NSManaged public var answer_image: String?
    @NSManaged public var answer_topline: String?
    @NSManaged public var answer1: String?
    @NSManaged public var answer1_icon: String?
    @NSManaged public var answer2: String?
    @NSManaged public var answer2_icon: String?
    @NSManaged public var answer3: String?
    @NSManaged public var answer3_icon: String?
    @NSManaged public var answer4: String?
    @NSManaged public var answer4_icon: String?
    @NSManaged public var fund_id: String?
    @NSManaged public var question: String?
    @NSManaged public var question_icon: String?
    @NSManaged public var question_no: Int16

}
