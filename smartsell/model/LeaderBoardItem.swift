//
//  LeaderBoardItem.swift
//  smartsell
//
//  Created by Anurag Dake on 16/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

class LeaderBoardItem{
    var name: String?
    var profilePicUrl: String?
    var count: Int?
    
    init(leaderboardItem: [String:AnyObject]?) {
        guard let item = leaderboardItem else{
            return
        }
        if let name = item["name"] as? String {
            self.name = name
        }
        if let profilePicUrl = item["profile_img_url"] as? String {
            self.profilePicUrl = profilePicUrl
        }
        if let count = item["count"] as? Int {
            self.count = count
        }
    }
}
