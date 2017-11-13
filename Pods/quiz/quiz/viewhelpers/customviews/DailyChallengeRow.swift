//
//  DailyChallengeRow.swift
//  quiz
//
//  Created by Sunil Sharma on 9/11/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit

class DailyChallengeRow: UIView {
    @IBOutlet weak var winnerCupImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completedAt: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var leftIconView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
        self.layer.cornerRadius = 2
    }
    
}
