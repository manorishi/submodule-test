//
//  LeaderboardInteractor.swift
//  smartsell
//
//  Created by Anurag Dake on 13/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import Core

/**
 LeaderboardInteractor fetches leaderboard details from server
 */
class LeaderboardInteractor{
    
    func fetchLeaderBoardData(completionHandler: @escaping (_ status: Bool, _ marketingMaterialLeaderboardItems: [LeaderBoardItem]?, _ fundSelectorLeaderboardItems: [LeaderBoardItem]?) -> Void){
        NetworkService.sharedInstance.networkClient?.doPOSTRequestWithTokens(requestURL: AppUrlConstants.leaderboardData, params: nil, httpBody: nil, completionHandler: { (responseStatus, responseData) in
            
            var marketingMaterialItems: [LeaderBoardItem]?
            var fundSelectorItems: [LeaderBoardItem]?
            
            switch responseStatus{
            case .success:
                if let marketingMaterials: NSArray = responseData?["mm"] as? NSArray{
                    for item in marketingMaterials {
                        let leaderBoardItem = LeaderBoardItem(leaderboardItem: item as? [String : AnyObject])
                        if marketingMaterialItems == nil{
                            marketingMaterialItems = []
                        }
                        marketingMaterialItems?.append(leaderBoardItem)
                    }
                }
                
                if let fundSelectors: NSArray = responseData?["fs"] as? NSArray{
                    for item in fundSelectors {
                        let leaderBoardItem = LeaderBoardItem(leaderboardItem: item as? [String : AnyObject])
                        if fundSelectorItems == nil{
                            fundSelectorItems = []
                        }
                        fundSelectorItems?.append(leaderBoardItem)
                    }
                }
                
                completionHandler(true, marketingMaterialItems, fundSelectorItems)
                
            case .error:
                completionHandler(false, nil, nil)
                
            case .forbidden:
                DispatchQueue.main.async {
                    completionHandler(false, nil, nil)
                    (UIApplication.shared.delegate as? AppDelegate)?.gotoLoginController()
                }
                
                
            default: break
            }
        })
    }
}
