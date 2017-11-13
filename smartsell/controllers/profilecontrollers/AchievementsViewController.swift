//
//  AchievementsViewController.swift
//  smartsell
//
//  Created by Anurag Dake on 13/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core

protocol AchievementsProtocol{
    func onbackButtonPress()
}

/**
 AchievementsViewController displays user achievement
 */
class AchievementsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var levelNameLabel: UILabel!
    @IBOutlet weak var achievementTypeLabel: UILabel!
    @IBOutlet weak var sharesCountLabel: UILabel!
    @IBOutlet weak var nextLevelNumberLabel: UILabel!
    @IBOutlet weak var achievementTableView: UITableView!
    
    var achievementType: AchievementType = .marketingMaterial
    var achievements: [AchievementItem]?
    var currentAchievement: AchievementItem?
    var totalShares = 0
    private let tableViewCellIdentifier = "AchievementTableViewCell"
    private let TABLE_CELL_HEIGHT: CGFloat = 80
    
    var eventHandler : AchievementsProtocol!
    var achievementsPresenter : AchievementsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()
    }
    
    func initialise(){
        achievementsPresenter = AchievementsPresenter(achievementsViewController: self)
        self.eventHandler = achievementsPresenter
        setAchievementData()
        initialiseTableView()
    }
    
    func setAchievementData(){
        sharesCountLabel.text = String(totalShares)
        achievementTypeLabel.text = achievementsPresenter.achievementTypeName(achievementType: achievementType)
        levelNameLabel.text = achievementsPresenter.achievementLevelWithName()
        nextLevelNumberLabel.text = achievementsPresenter.nextLevelText(achievementType: achievementType)
    }
    
    func initialiseTableView(){
        achievementTableView.delegate = self
        achievementTableView.dataSource = self
        achievementTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: achievementTableView.frame.width, height: 8))
        achievementTableView.register(UINib(nibName: tableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: tableViewCellIdentifier)
    }
    
    //Tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = achievementTableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! AchievementTableViewCell
        if let achievement = achievements?[indexPath.row]{
            if achievement.isCurrentAchievement{
                cell.contentView.backgroundColor = hexStringToUIColor(hex: "#f5ba28")
            }
            cell.nameLabel.text = achievement.name
            cell.achievementIconImageView.image = achievement.isAchieved ? achievement.achievedIcon : achievement.nonAchievedIcon
            cell.dateLabel.text = achievementsPresenter.date(from: achievement.achievementDate)
            if achievement.achievementDate == nil{
                cell.levelLabel.text = "Level \(achievement.level!) - Share \(achievement.requiredActionCount!)"
                cell.contentView.alpha = 0.5
            }else{
                cell.levelLabel.text = "Level \(achievement.level!) - \(achievement.requiredActionCount!) shared"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TABLE_CELL_HEIGHT
    }


    @IBAction func onBackButtonPress(_ sender: UIButton) {
        eventHandler.onbackButtonPress()
    }
}
