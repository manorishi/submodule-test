//
//  LeaderBoardViewController.swift
//  smartsell
//
//  Created by Anurag Dake on 13/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core
import Kingfisher

protocol LeaderboardProtocol{
    func onbackButtonPress()
}

/**
 NotificationsViewController displays leaderboard
 */
class LeaderBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var leaderboardTableView: UITableView!
    var eventHandler : LeaderboardProtocol!
    var leaderboardPresenter : LeaderboardPresenter!
    
    var loadingController : UIAlertController?
    var leaderboardHeaders: [String]?
    var leaderboardData : [[LeaderBoardItem]]?
    
    private let tableViewCellIdentifier = "LeaderboardItemTableViewCell"
    private let DEFAULT_PROFILE_IMAGE = "ic_profile_picutre_placeholder"
    private let TABLE_CELL_HEIGHT: CGFloat = 60
    private let TABLE_SECTION_HEIGHT: CGFloat = 68
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()
    }
    
    func initialise(){
        leaderboardPresenter = LeaderboardPresenter(leaderBoardViewController: self)
        self.eventHandler = leaderboardPresenter
        initialiseUiAlertController()
        initialiseTableView()
    }
    
    func initialiseTableView(){
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        leaderboardTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: leaderboardTableView.frame.width, height: 8))
        leaderboardTableView.register(UINib(nibName: tableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: tableViewCellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoadingAlert()
        leaderboardPresenter.fetchLeaderBoardData { [weak self] in
            DispatchQueue.main.async {
                self?.dismissLoadingAlert()
            }
            
        }
    }
    
    func initialiseUiAlertController(){
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        loadingController = alertViewHelper.loadingAlertViewController(title: "loading".localized, message: "\n\n")
    }
    
    //Tableview delegate methods.
    func numberOfSections(in tableView: UITableView) -> Int {
        return leaderboardData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardData?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = leaderboardTableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! LeaderboardItemTableViewCell
        if let leaderboardItem = leaderboardData?[indexPath.section][indexPath.row]{
            cell.userNameLabel.text = leaderboardItem.name ?? ""
            cell.countLabel.text = "\(leaderboardItem.count ?? 0)"
            cell.actionLabel.text = leaderboardPresenter.actionTypeLabel(for: indexPath.section)
            leaderboardPresenter.makeViewCircular(view: cell.profilePicImageView)
            if let profilePicUrl = leaderboardItem.profilePicUrl, let url = URL(string: profilePicUrl){
                cell.profilePicImageView.kf.setImage(with: url, placeholder: UIImage(named: DEFAULT_PROFILE_IMAGE), options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TABLE_CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TABLE_SECTION_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return leaderboardPresenter.leaderboardTableHeaderView(tableViewWidth: tableView.frame.width, index: section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return leaderboardHeaders?[section] ?? ""
    }
    
    func showLoadingAlert(){
        if loadingController != nil{
            present(loadingController!, animated: true, completion: nil)
        }
    }
    
    func dismissLoadingAlert(){
        if loadingController != nil{
            loadingController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onBackButtonPress(_ sender: UIButton) {
        eventHandler.onbackButtonPress()
    }
    
}
