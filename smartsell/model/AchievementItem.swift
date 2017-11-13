//
//  Achievement.swift
//  smartsell
//
//  Created by Anurag Dake on 18/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

class AchievementItem{
    var name: String!
    var level: Int16!
    var requiredActionCount: Int32!
    var nextLevelRequiredActionCount: Int32!
    var achievementDate: Date?
    var nonAchievedIcon: UIImage!
    var achievedIcon: UIImage!
    var nextLevelName: String!
    var isCurrentAchievement: Bool = false
    var isAchieved: Bool = false
    var type: AchievementType!
}
