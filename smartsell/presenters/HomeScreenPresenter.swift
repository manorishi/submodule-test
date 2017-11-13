//
//  HomeScreenPresenter.swift
//  smartsell
//
//  Created by Anurag Dake on 17/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

/**
 Used to configure view of Home screen and check for pending announcement and notification.
 */

import Core
import Directory
import DropDown
import news
import quiz
import mfadvisor

class HomeScreenPresenter {
    let homeScreenInteractor = HomeScreenInteractor()
    var homeScreenTableViewAdapter: HomeScreenTableViewAdapter? = nil
    let newsInteractor = NewsInteractor()
    let mfAdvisorInteractor = AllFundsInteractor()
    let quizWelcomeInteractor = QuizWelcomeInteractor()
    
    /**
     Fetch meta data from server.
     */
    func syncDataFromServer(dataSyncDelegate: DataSyncDelegateProtocol, userTypeId: Int16) {
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext, let mfaManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.mfaManagedObjectContext {
            homeScreenInteractor.startSyncingMetaData(managedObjectContext: managedObjectContext, mfaManagedObjectContext: mfaManagedObjectContext, dataSyncDelegate: dataSyncDelegate, userTypeId: userTypeId)
        }
    }
    
    func configure(tableView: UITableView){
        homeScreenTableViewAdapter = HomeScreenTableViewAdapter()
        tableView.delegate = homeScreenTableViewAdapter
        tableView.dataSource = homeScreenTableViewAdapter
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 2))
        tableView.register(homeScreenTableViewAdapter!.homeBannerCarouselTableViewCell(), forCellReuseIdentifier: homeScreenTableViewAdapter!.homeBannerCarouselCellReuseIdentifier())
        tableView.register(homeScreenTableViewAdapter!.dailyChallengeTableViewCell(), forCellReuseIdentifier: homeScreenTableViewAdapter!.dailyChallengeCellReuseIdentifier())
        tableView.register(homeScreenTableViewAdapter!.featureGridTableViewCell(), forCellReuseIdentifier: homeScreenTableViewAdapter!.featureGridCellReuseIdentifier())
        tableView.register(homeScreenTableViewAdapter!.bannerTableViewCell(), forCellReuseIdentifier: homeScreenTableViewAdapter!.bannerCellReuseIdentifier())
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func startCarouselScroll(){
        homeScreenTableViewAdapter?.startAutoScroll()
    }
    
    func stopCarouselScroll(){
        homeScreenTableViewAdapter?.stopAutoScroll()
    }
    
    func loadData(table: UITableView, userTypeId: Int){
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext{
            homeScreenTableViewAdapter!.dataList = homeScreenInteractor.getHomeScreenData(userTypeId: userTypeId, managedObjectContext: managedObjectContext)
            table.reloadData()
        }
    }
    
    func getLatestNewsData(completion: @escaping((_ title: String?, _ description: String?) -> ())){
        newsInteractor.topNewsItem { (newsItem) in
            completion(newsItem?.newsTitle, newsItem?.newsIntro)
        }
    }
    
    func getStocksData(completion: @escaping((_ sensexIndex: String?, _ niftyIndex: String?) -> ())){
        mfAdvisorInteractor.liveMarketData { (status, data) in
            completion(data?.bsePrevClose, data?.nsePrevClose)
        }
    }
    
    func getDailyChallengeData(userTpeId: Int, completion: @escaping((_ dailyWinnerText: String, _ weeklyWinnerText: String) -> ())){
        quizWelcomeInteractor.getHomeScreenQuizData(userTypeId: userTpeId, onSuccess: { (dailyWinnerText, weeklyWinnerText) in completion(dailyWinnerText, weeklyWinnerText)}) { (status, errorTitle, errorMsg) in
        }
    }
    
    func loadLatestNewsData(table: UITableView, title: String?, intro: String?){
        guard let dataList = homeScreenTableViewAdapter!.dataList else {
            return
        }
        for listItemList in dataList{
            if(listItemList[0].homeScreenItemType!() == HomeScreenItemType.carousel){
                for carouselItem in listItemList{
                    guard let item = carouselItem as? HomeScreenCarouselItem else {
                        return
                    }
                    if item.carouselType == CarouselType.news.description{
                        item.title = title ?? ""
                        item.description = intro ?? ""
                        table.reloadData()
                        return
                    }
                }
            }
        }
    }
    
    func loadLatestStocksData(table: UITableView, nseIndex: String?, bseIndex: String?){
        guard let dataList = homeScreenTableViewAdapter!.dataList, let sensex = bseIndex, let nifty = nseIndex else {
            return
        }
        for listItemList in dataList{
            if(listItemList[0].homeScreenItemType!() == HomeScreenItemType.carousel){
                for carouselItem in listItemList{
                    guard let item = carouselItem as? HomeScreenCarouselItem else {
                        return
                    }
                    if item.carouselType == CarouselType.stock.description{
                        let description = "Sensex Last Close: " + sensex + "\n" + "Nifty Last Close: " + nifty
                        item.description = description
                        table.reloadData()
                        return
                    }
                }
            }
        }
    }
    
    func loadDailyChallengeData(table: UITableView, dailyWinner: String, weeklyWinner: String){
        setWeeklyWinnerText(table: table, weeklyWinner: weeklyWinner)
        setDailyWinner(table: table, dailyWinner: dailyWinner)
    }
    
    private func setDailyWinner(table: UITableView, dailyWinner: String){
        guard let dataList = homeScreenTableViewAdapter!.dataList else {
            return
        }
        for listItemList in dataList{
            if(listItemList[0].homeScreenItemType!() == HomeScreenItemType.challenge){
                guard let item = listItemList[0] as? HomeScreenChallengeItem else {
                    return
                }
                item.description = dailyWinner
                table.reloadData()
                return
            }
        }
    }
    
    private func setWeeklyWinnerText(table: UITableView, weeklyWinner: String){
        guard let dataList = homeScreenTableViewAdapter!.dataList else {
            return
        }
        for listItemList in dataList{
            if(listItemList[0].homeScreenItemType!() == HomeScreenItemType.carousel){
                for carouselItem in listItemList{
                    guard let item = carouselItem as? HomeScreenCarouselItem else {
                        return
                    }
                    if item.carouselType == CarouselType.leaderboard.description{
                        item.description = weeklyWinner
                        table.reloadData()
                        return
                    }
                }
            }
        }
    }
    
    func checkifMetaDataSyncRequired(completion: @escaping((_ isRequired: Bool) -> ())){
        homeScreenInteractor.checkifSyncingRequired(completion: completion)
    }

    
    func initializeDropDown(dropDown: DropDown){
        dropDown.dataSource = ["Profile", "Notifications", "Help"]
        dropDown.width = 120
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        dropDown.selectionBackgroundColor = dropDown.backgroundColor ?? UIColor.lightGray
    }
    
    func setDropDownAnchor(dropDown: DropDown, anchorView: UIView){
        dropDown.anchorView = anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
    }
    
    func userData() -> UserData?{
        return homeScreenInteractor.userData()
    }
    
    //Announcements
    /**
     Call interactor method to get announcement data from server.
     */
    func announcementData(completionHandler:@escaping (_ status:ResponseStatus, _ errorTitle:String?, _ errorMessage:String?) -> ()) {
        
        
        homeScreenInteractor.announcementDataFromServer(completionHandler: completionHandler)
    }
    
    
    
    func updateLastAnnouncementShownDate() {
        homeScreenInteractor.updateLastAnnouncementShownDate()
    }
    
    /**
     Check whether announcement should be repeated or not.
     */
    func shouldShowRepeatAnnouncement(announcementData:AnnouncementData?) -> Bool {
        if let startDate = announcementData?.startDate {
            let currentDate  = Date()
            
            if (Calendar.current.compare(startDate, to: currentDate, toGranularity: .day) != .orderedDescending) && (announcementData?.endDate == nil || Calendar.current.compare((announcementData?.endDate)!, to: currentDate, toGranularity: .day) != .orderedAscending) {
                if announcementData?.lastShownDate == nil {
                    return true
                }
                else if (announcementData?.frequency ?? 0) == 0 {
                    return true
                }
                else if ((announcementData?.frequency ?? 1) <= daysFrom((announcementData?.lastShownDate)!, toDate: Date())) {
                    return true
                }
            }
        }
        return false
    }
    
    func shouldShowOnceAnnouncement(announcementData:AnnouncementData?) -> Bool {
        if let startDate = announcementData?.startDate {
            let currentDate  = Date()
            if (announcementData?.lastShownDate == nil && startDate <= currentDate){
                if announcementData?.endDate == nil {
                    return true
                }
                else if ((announcementData?.endDate)! >= currentDate){
                    return true
                }
            }
        }
        return false
    }
    
    func daysFrom(_ date: Date, toDate:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.day, from: date, to: toDate, options: []).day!
    }

}
