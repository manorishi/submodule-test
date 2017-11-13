//
//  LeaderboardPresenter.swift
//  smartsell
//
//  Created by Anurag Dake on 13/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

/**
 LeaderboardPresenter handle UI logic for LeaderboardViewController
 */
class LeaderboardPresenter: LeaderboardProtocol{
    weak var leaderBoardViewController: LeaderBoardViewController!
    var leaderboardInteractor: LeaderboardInteractor!
    
    init(leaderBoardViewController: LeaderBoardViewController) {
        self.leaderBoardViewController = leaderBoardViewController
        leaderboardInteractor = LeaderboardInteractor()
    }
    
    func actionTypeLabel(for section: Int) -> String{
        guard let header = leaderBoardViewController.leaderboardHeaders?[section] else{
            return ""
        }
        switch header {
        case "marketing_materials".localized:
            return "shared".localized
        case "fund_selector".localized:
            return "selected".localized
        default: return ""
        }
    }
    
    func fetchLeaderBoardData(completionHandler: @escaping () -> Void){
        var leaderboardData = [[LeaderBoardItem]]()
        var leaderboardHeaders = [String]()
        
        leaderboardInteractor.fetchLeaderBoardData {[weak self] (status, marketingMaterials, fundSelectorItems) in
            DispatchQueue.main.async {
                if status{
                    if marketingMaterials != nil{
                        leaderboardData.append(marketingMaterials!)
                        leaderboardHeaders.append("marketing_materials".localized)
                    }
                    if fundSelectorItems != nil{
                        leaderboardData.append(fundSelectorItems!)
                        leaderboardHeaders.append("fund_selector".localized)
                    }
                    
                    self?.leaderBoardViewController.leaderboardHeaders = leaderboardHeaders
                    self?.leaderBoardViewController.leaderboardData = leaderboardData
                    self?.leaderBoardViewController.leaderboardTableView.reloadData()
                }
                completionHandler()
            }
        }
    }
    
    func makeViewCircular(view: UIView){
        leaderBoardViewController.view.layoutIfNeeded()
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true
    }
    
    /**
     Return header for table of videos
     */
    func leaderboardTableHeaderView(tableViewWidth: CGFloat, index: Int) -> UIView{
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableViewWidth, height: 68))
        
        let headerTopView = UIView(frame: CGRect(x: 0, y: 0, width: tableViewWidth, height: 8))
        headerTopView.backgroundColor = hexStringToUIColor(hex: "EAEAEA")
        
        let headerSubView = UIView(frame: CGRect(x: 0, y: 9, width: tableViewWidth, height: 60))
        headerSubView.backgroundColor = hexStringToUIColor(hex: "AE275F")
        
        let headerImageView = UIImageView(frame: CGRect(x: 15, y: 15, width: 30, height: 30))
        headerImageView.image = headerImage(index: index)
        headerSubView.addSubview(headerImageView)
        
        let headerLabel = UILabel(frame: CGRect(x: 66, y: 0, width: tableViewWidth - 66, height: 60))
        headerLabel.text = leaderBoardViewController.leaderboardHeaders?[index] ?? ""
        headerLabel.textColor = UIColor.white
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerSubView.addSubview(headerLabel)
        
        headerView.addSubview(headerSubView)
        return headerView
    }
    
    
    private func headerImage(index: Int) -> UIImage?{
        guard let header = leaderBoardViewController.leaderboardHeaders?[index] else{
            return nil
        }
        
        switch header {
        case "marketing_materials".localized:
            return UIImage(named: "ic_share_marketing")
        case "fund_selector".localized:
            return UIImage(named: "ic_select_fund")
        default: return nil
        }
    }
    
    func onbackButtonPress(){
        _ = leaderBoardViewController.navigationController?.popViewController(animated: true)
    }
}
