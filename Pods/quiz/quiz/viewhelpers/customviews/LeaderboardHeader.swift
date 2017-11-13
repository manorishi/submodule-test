//
//  LeaderboardHeader.swift
//  quiz
//
//  Created by Sunil Sharma on 9/11/17.
//  Copyright © 2017 Cybrilla Technologies. All rights reserved.
//

import UIKit

class LeaderboardHeader: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bottomRightLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
        self.layer.cornerRadius = 2
    }
    
}
