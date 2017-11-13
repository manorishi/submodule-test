//
//  DailyChallengeTableViewCell.swift
//  smartsell
//
//  Created by kunal singh on 11/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

class DailyChallengeTableViewCell: BaseHomeScreenTableViewCell{
    
    
    @IBOutlet weak var dailyChallengeLabel: UILabel!
    @IBOutlet weak var takeChallengeButton: UIButton!
    @IBOutlet weak var leaderBoardButton: UIButton!
    
    
    var item: [ListItemTypeProtocol]? {
        didSet{
            guard let challengeItem = item  as? [HomeScreenChallengeItem] else {
                return
            }
            dailyChallengeLabel.text = challengeItem[0].description
            takeChallengeButton.addTarget(self, action: #selector(takeChallengePressed(sender:)), for: .touchUpInside)
            leaderBoardButton.addTarget(self, action: #selector(leaderBoardPressed(sender:)), for: .touchUpInside)
        }
    }
    
    @objc private func takeChallengePressed(sender: UIButton){
        super.postNotification(type: HomeScreenItemType.challenge as AnyObject, subtype: "challenge" as AnyObject, data: item![0] as AnyObject)
    }
    
    @objc private func leaderBoardPressed(sender: UIButton){
        super.postNotification(type: HomeScreenItemType.challenge as AnyObject, subtype: "leaderboard" as AnyObject, data: item![0] as AnyObject)
    }
    
}
