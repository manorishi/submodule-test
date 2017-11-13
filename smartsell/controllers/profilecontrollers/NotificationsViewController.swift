//
//  NotificationsViewController.swift
//  smartsell
//
//  Created by Anurag Dake on 13/04/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

protocol NotificationsProtocol{
    
}

/**
 NotificationsViewController displays notifications arrived
 */
class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var notificationTableView: UITableView!
    var eventHandler : NotificationsProtocol!
    var notificationPresenter : NotificationsPresenter!
    var notificationDataArray:[NotificationData] = []
    let notificationTableCellIdentifier = "MFNotificationTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationPresenter = NotificationsPresenter(notificationsViewController: self)
        self.eventHandler = notificationPresenter
        configTableView()
        getNotificationData()
    }
    
    func getNotificationData() {
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            notificationPresenter.deleteOldNotificationData(managedObjectContext: managedObjectContext)
            notificationDataArray = notificationPresenter.getNotificationData(managedObjectContext: managedObjectContext)
        }
    }
    
    func configTableView() {
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        notificationTableView.tableFooterView = UIView()
        notificationTableView.tableHeaderView = UIView()
        notificationTableView.register(UINib(nibName: "MFNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: notificationTableCellIdentifier)
    }
    
    //Tableview delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notificationTableCellIdentifier, for: indexPath) as! MFNotificationTableViewCell
        let data = notificationDataArray[indexPath.row]
        cell.titleLabel.text = data.title
        cell.bodyLabel.text = data.body
        cell.dateLabel.text = data.date
        cell.timeLabel.text = data.time
        return cell
        
    }
    
    @IBAction func onBackButtonPress(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onHomeTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
