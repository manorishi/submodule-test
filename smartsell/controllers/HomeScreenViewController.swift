//
//  HomeScreenViewController.swift
//  smartsell
//
//  Created by Anurag Dake on 17/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import Core
import CoreData
import Kingfisher
import mfadvisor
import Directory
import DropDown
import quiz
import news
import Apptentive

/**
 AccountViewController displays home screen view with various options, latest achievemnets, new items
 */
class HomeScreenViewController : UIViewController, UIAlertViewCallbackProtocol {
    
    private let homeScreenPresenter : HomeScreenPresenter = HomeScreenPresenter()
    private var loadingAlertController, progressAlertController: UIAlertController?
    private var dropDown = DropDown()
    private var userData: UserData?
    var isFromRegistration = false
    var pendingAnnouncement:(status: Bool, errorTitle: String, errorMessage:String, actionText:String) = (false, "" ,"", "")
    
    @IBOutlet weak var homeScreenTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private let MFADVISOR_BUNDLE = "mfadvisor"
    private let QUIZ_BUNDLE = "quiz"
    private let NEWS_BUNDLE = "news"
    private let DIRECTORY_IDENTIFIER = "org.cocoapods.Directory"
    private let CORE_IDENTIFIER = "org.cocoapods.Core"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeScreenPresenter.initializeDropDown(dropDown: dropDown)
        userData = homeScreenPresenter.userData()
        homeScreenPresenter.configure(tableView: homeScreenTableView)
        NotificationCenter.default.addObserver(self, selector: #selector(goToLoginPage), name: AppNotificationConstants.QUIZ_FORBBIDDEN_NOTIFICATION, object: nil)
        addBackgroundImage()
        isFromRegistration ? startSync() : loadData()
        checkifMetaDataSyncRequired()
        announcementData()
    }
    
    private func checkifMetaDataSyncRequired(){
        if !isFromRegistration{
            homeScreenPresenter.checkifMetaDataSyncRequired { (isRequired) in
                if isRequired{
                    let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
                    alertViewHelper.showAlertView(title: "sync_dialog_title".localized, message: "sync_dialog_message".localized , cancelButtonTitle: "ok".localized)
                }
            } 
        }
    }
    
    private func addBackgroundImage(){
        backgroundImageView.image = UIImage(named: "background", in: Bundle(identifier: CORE_IDENTIFIER), compatibleWith: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onHomeScreenTableCellClicked(_:)), name: NSNotification.Name(rawValue: AppConstants.TABLE_VIEW_SELECTION_NOTIFICATION), object: nil)
        homeScreenPresenter.startCarouselScroll()
        shouldShowAnnouncement()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AppConstants.TABLE_VIEW_SELECTION_NOTIFICATION), object: nil)
        homeScreenPresenter.stopCarouselScroll()
    }
    
    @objc private func onHomeScreenTableCellClicked(_ notification: NSNotification){
        if let type = notification.userInfo?["type"] as? HomeScreenItemType{
            switch type {
            case .banner:
                resolveBannerItemClick(bannerItem: notification.userInfo?["data"] as? HomeScreenBannerItem)
            case .grid:
                resolveGridItemClick(gridItem: notification.userInfo?["data"] as? HomeScreenGridItem)
            case .carousel:
                resolveCarouselItemClick(carouselItem: notification.userInfo?["data"] as? HomeScreenCarouselItem)
            case .challenge:
                resolveChallengeItemClick(subtype: notification.userInfo?["subtype"] as? String, challengeItem: notification.userInfo?["data"] as? HomeScreenChallengeItem)
            }
        }
    }
    
    private func loadData(){
        guard let userTypeId = userData?.userTypeId else {
            return
        }
        homeScreenPresenter.loadData(table: homeScreenTableView, userTypeId: userTypeId)
        getLatestNewsData()
        getStocksData()
        getDailyChallengeData()
    }
    
    private func getLatestNewsData(){
        homeScreenPresenter.getLatestNewsData {[weak self] (title, intro) in
            DispatchQueue.main.async {
                self?.homeScreenPresenter.loadLatestNewsData(table: (self?.homeScreenTableView)!, title: title, intro: intro)
            }
        }
    }
    
    private func getStocksData(){
        homeScreenPresenter.getStocksData {[weak self] (sensexIndex, niftyIndex) in
            DispatchQueue.main.async {
                self?.homeScreenPresenter.loadLatestStocksData(table: (self?.homeScreenTableView)!, nseIndex: niftyIndex, bseIndex: sensexIndex)
            }
        }
    }
    
    private func getDailyChallengeData(){
        homeScreenPresenter.getDailyChallengeData(userTpeId: (userData?.userTypeId)!, completion: { [weak self] (dailyWinnerText, weeklyWinnerText) in
            self?.homeScreenPresenter.loadDailyChallengeData(table: (self?.homeScreenTableView)!, dailyWinner: dailyWinnerText, weeklyWinner: weeklyWinnerText)
        })
    }
    
    private func resolveBannerItemClick(bannerItem: HomeScreenBannerItem?){
        guard let item = bannerItem else {
            return
        }
        openBannerPage(item: item)
    }
    
    private func resolveCarouselItemClick(carouselItem: HomeScreenCarouselItem?){
        guard let item = carouselItem else {
            return
        }
        switch item.carouselType {
        case CarouselType.leaderboard.description:
            openLeaderBoardPage(item: item)
        case CarouselType.news.description:
            openNewsPage(item: item)
        case CarouselType.stock.description:
            openStocksPage(item: item)
        case CarouselType.generic.description:
            openGenericPage(item: item)
        default:
            return
        }
    }
    
    private func resolveChallengeItemClick(subtype: String?, challengeItem: HomeScreenChallengeItem?){
        guard let item = challengeItem, let typeOfChallenge = subtype else {
            return
        }
        switch typeOfChallenge {
        case "leaderboard":
            openLeaderBoardPage(item: item)
        case "challenge":
            openChallengeItem(item: item)
        default:
            return
        }
    }
    
    private func resolveGridItemClick(gridItem: HomeScreenGridItem?){
        guard let item = gridItem else {
            return
        }
        switch item.title {
        case HomeScreenGrid.Detailed_performance.description:
            openDetailedPerformancePage(item: item)
        case HomeScreenGrid.Fund_Comparison.description:
            openFundComparisonPage(item: item)
        case HomeScreenGrid.Fund_Presentation.description:
            openFundPresentationPage(item: item)
        case HomeScreenGrid.Fund_Selector.description:
            openFundSelectionPage(item: item)
        case HomeScreenGrid.Sales_Content.description:
            openSalesContentPage(item: item)
        case HomeScreenGrid.Sales_Pitch.description:
            openSalesPitchPage(item: item)
        case HomeScreenGrid.Your_Favorite.description:
            openYourFavoritesPage(item: item)
        case HomeScreenGrid.SIP_Calculator.description:
            openSipCalculatorPage(item: item)
        case HomeScreenGrid.SWP_Calculator.description:
            openSwpCalculatorPage(item: item)
        default:
            return
        }
    }
    
    private func openBannerPage(item: HomeScreenBannerItem){
        gotoSpecificPage(target: item.actionTarget, extraData: item.extraData)
    }
    
    private func openGenericPage(item: HomeScreenCarouselItem){
        gotoSpecificPage(target: item.actionTarget, extraData: item.extraData)
    }
    
    private func gotoSpecificPage(target: String?, extraData: String? = nil){
        guard let bannerTarget = target, let actionTarget: BannerType = BannerType(rawValue: bannerTarget) else{
            return
        }
        
        switch actionTarget {
        case .all_items, .live_data:
            self.tabBarController?.selectedIndex = 1
        case .favorites:
            openFavouritesPage()
        case .leaderboard:
            gotoLeaderboardPage()
        case .notifications:
            openNotificationsPage()
        case .edit_account:
            openProfilePage()
        case .directory:
            guard let directoryId = extraData, let id = Int32(directoryId) else {
                gotoBaseDirectory(id: nil)
                return
            }
            gotoBaseDirectory(id: id)
        case .poster:
            showDirectoryContentType(contentTypeId: ContentDataType.poster.rawValue, id: Int(extraData ?? "0") ?? 0)
        case .video:
            showDirectoryContentType(contentTypeId: ContentDataType.video.rawValue, id: Int(extraData ?? "0") ?? 0)
        case .pdf:
            showDirectoryContentType(contentTypeId: ContentDataType.pdf.rawValue, id: Int(extraData ?? "0") ?? 0)
        case .quiz:
            gotoQuizPage()
        case .news:
            gotoNewsPage()
        case .sip_calculator:
            gotoSipProjector()
        case .fund_selector:
            gotoFundSelector()
        case .fund_comparision:
            gotoAllFundsScreen(fundOptionType: .fundComparison)
        case .sales_pitch:
            gotoAllFundsScreen(fundOptionType: .salesPitch)
        case .fund_presentation:
            gotoAllFundsScreen(fundOptionType: .presentation)
        case .detailed_performance:
            gotoAllFundsScreen(fundOptionType: .performance)
        case .none:
            break
        }
    }
    
    private func openNewsPage(item: HomeScreenCarouselItem){
        gotoNewsPage()
    }
    
    private func openStocksPage(item: HomeScreenCarouselItem){
        self.tabBarController?.selectedIndex = 1
    }
    
    private func openChallengeItem(item: HomeScreenChallengeItem){
        gotoQuizPage()
    }
    
    private func openLeaderBoardPage(item: ListItemTypeProtocol){
       gotoLeaderboardPage()
    }
    
    private func openDetailedPerformancePage(item: HomeScreenGridItem){
        gotoAllFundsScreen(fundOptionType: .performance)
    }
    
    private func openFundComparisonPage(item: HomeScreenGridItem){
        gotoAllFundsScreen(fundOptionType: .fundComparison)
    }
    
    private func openFundPresentationPage(item: HomeScreenGridItem){
        gotoAllFundsScreen(fundOptionType: .presentation)
    }
    
    private func openSipCalculatorPage(item: HomeScreenGridItem){
        gotoAllFundsScreen(fundOptionType: .sipCalculator)
    }

    private func openSwpCalculatorPage(item: HomeScreenGridItem){
        gotoAllFundsScreen(fundOptionType: .swpCalculator)
    }
    
    private func openFundSelectionPage(item: HomeScreenGridItem){
        gotoFundSelector()
    }
    
    private func gotoFundSelector(){
        let podBundle = Bundle(for: FundSelectionViewController.classForCoder())
        guard let bundleURL = podBundle.url(forResource: MFADVISOR_BUNDLE, withExtension: "bundle"), let mfaManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.mfaManagedObjectContext, let bundle = Bundle(url: bundleURL) else{
            return
        }
        let fundSelectionViewController = FundSelectionViewController(nibName: "FundSelectionViewController", bundle: bundle)
        fundSelectionViewController.hidesBottomBarWhenPushed = true
        fundSelectionViewController.managedObjectContext = mfaManagedObjectContext
        self.navigationController?.pushViewController(fundSelectionViewController, animated: true)
    }
    
    private func openSalesContentPage(item: HomeScreenGridItem){
        gotoBaseDirectory(id: nil)
    }
    
    private func openSalesPitchPage(item: HomeScreenGridItem){
        gotoAllFundsScreen(fundOptionType: .salesPitch)
    }
    
    private func openYourFavoritesPage(item: HomeScreenGridItem){
        openFavouritesPage()
    }
    
    /**
     Navigate to screen as announcement traget.
     */
    func clickedOnAnnouncementTarget(data: Data){
        if let announcementDataObj = NSKeyedUnarchiver.unarchiveObject(with: data) as? AnnouncementData{
            let extraData = announcementDataObj.extraData == nil ? nil : (announcementDataObj.extraData)
            gotoSpecificPage(target: announcementDataObj.actionTarget?.rawValue ?? "", extraData: extraData)
        }
    }
    
    private func gotoSipProjector(){
        let podBundle = Bundle(for: SIPCalculatorViewController.classForCoder())
        guard let bundleURL = podBundle.url(forResource: MFADVISOR_BUNDLE, withExtension: "bundle"), let bundle = Bundle(url: bundleURL) else{ return }
        let sipCalculatorViewController = SIPCalculatorViewController(nibName: "SIPCalculatorViewController", bundle: bundle)
        sipCalculatorViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(sipCalculatorViewController, animated: true)
    }
    
    func showDirectoryContentType(contentTypeId:Int, id:Int) {
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            if let directoryContent = BaseInteractor().contentFromTypeId(contentTypeId: Int16(contentTypeId), contentId: Int32(id), managedObjectContext: managedObjectContext) {
                BasePresenter().clickedOnDirectoryItem(data:directoryContent, managedObjectContext:managedObjectContext , navigationController: self.navigationController!)
            }
        }
    }
    
    private func openFavouritesPage(){
        guard let favouritesViewController = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as? FavouritesViewController else{ return }
        favouritesViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(favouritesViewController, animated: true)
    }
    
    func gotoLeaderboardPage() {
        var leaderboardVC: QuizLeaderboardViewController?
        let podBundle = Bundle(for: QuizLeaderboardViewController.classForCoder())
        if let bundleURL = podBundle.url(forResource: QUIZ_BUNDLE, withExtension: "bundle"){
            if let bundle = Bundle(url: bundleURL) {
                leaderboardVC = QuizLeaderboardViewController(nibName: "QuizLeaderboardViewController", bundle: bundle)
                leaderboardVC?.hidesBottomBarWhenPushed = true
                let navigationController = UINavigationController(rootViewController: leaderboardVC!)
                navigationController.isNavigationBarHidden = true
                present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    func gotoQuizPage() {
        var quizWelcomeVC: QuizWelcomeViewController?
        let podBundle = Bundle(for: QuizWelcomeViewController.classForCoder())
        if let bundleURL = podBundle.url(forResource: QUIZ_BUNDLE, withExtension: "bundle"){
            if let bundle = Bundle(url: bundleURL) {
                quizWelcomeVC = QuizWelcomeViewController(nibName: "QuizWelcomeViewController", bundle: bundle)
                quizWelcomeVC?.hidesBottomBarWhenPushed = true
                let navigationController = UINavigationController(rootViewController: quizWelcomeVC!)
                navigationController.isNavigationBarHidden = true
                present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    private func gotoNewsPage(){
        let podBundle = Bundle(for: NewsViewController.classForCoder())
        guard let bundleURL = podBundle.url(forResource: NEWS_BUNDLE, withExtension: "bundle"), let bundle = Bundle(url: bundleURL) else{ return }
        let newsViewController = NewsViewController(nibName: "NewsViewController", bundle: bundle)
        newsViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(newsViewController, animated: true)
    }

    private func gotoAllFundsScreen(fundOptionType:FundOptionsType) {
        guard let targetViewController = self.storyboard?.instantiateViewController(withIdentifier:"AllItemsViewController") as? AllItemsViewController else{
            return
        }
        targetViewController.hidesBottomBarWhenPushed = true
        targetViewController.isFromHomeScreen = true
        targetViewController.fundOptionType = fundOptionType
        self.navigationController?.pushViewController(targetViewController, animated: true)
    }
    
    private func gotoBaseDirectory(id:Int32?) {
        let podBundle = Bundle(identifier: DIRECTORY_IDENTIFIER)
        let baseDirectory = BaseDirectoryViewController(nibName: "BaseDirectoryViewController", bundle: podBundle)
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            baseDirectory.managedObjectContext = managedObjectContext
        }
        if id != nil {
            baseDirectory.view.isHidden = false
            baseDirectory.directoryContentData = baseDirectory.directoryContentDataWithId(id!)
            baseDirectory.initialiseUI()
        }
        baseDirectory.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(baseDirectory, animated: true)
    }
    
    @IBAction func onSyncTapped(_ sender: UIButton) {
        startSync()
    }
    
    private func startSync(){
        guard let userTypeId = userData?.userTypeId else {
            return
        }
        if loadingAlertController == nil{
            loadingAlertController = AlertViewHelper.init(alertViewCallbackProtocol:nil).loadingAlertViewController(title: "Loading...", message: "\n\n")
        }
        present(loadingAlertController!, animated: true, completion: nil)
        let metaDataSyncListener = MetaDataSyncListener()
        metaDataSyncListener.parent = self
        homeScreenPresenter.syncDataFromServer(dataSyncDelegate: metaDataSyncListener, userTypeId: Int16(userTypeId))
    }
    
    @IBAction func onOptionsTapped(_ sender: UIButton) {
        homeScreenPresenter.setDropDownAnchor(dropDown: dropDown, anchorView: sender)
        setDropDownSelectionActions(dropDown: dropDown)
        dropDown.show()
    }
    
    internal func goToLoginPage(){
        (UIApplication.shared.delegate as? AppDelegate)?.gotoLoginController()
    }
    
    private func setDropDownSelectionActions(dropDown: DropDown){
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            switch index {
            case 0: self?.openProfilePage()
            case 1: self?.openNotificationsPage()
            case 2: self?.openHelpPage()
            default: break
            }
        }
        dropDown.cancelAction = { [] in
            dropDown.hide()
        }
    }
    
    private func openProfilePage(){
        guard let editProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else{
            return
        }
        editProfileViewController.userData = homeScreenPresenter.userData()
        self.present(editProfileViewController, animated: true, completion: nil)
    }
    
    private func openNotificationsPage(){
        guard let notificationsViewController = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController else{ return }
        self.present(notificationsViewController, animated: true, completion: nil)
    }
    
    private func openHelpPage(){
        Apptentive.shared.presentMessageCenter(from: self)
    }
    
    
    private func announcementData(){
        homeScreenPresenter.announcementData { [weak self] (status, errorTitle, errorMessage) in
            switch status {
            case .success:
                self?.showAnnouncement()
            case .forbidden:
                (UIApplication.shared.delegate as? AppDelegate)?.gotoLoginController()
            default:
                self?.showAnnouncement()
            }
        }
    }
    
    ///Display announcement
    func showAnnouncementAlertView(title:String, message:String, actionText:String) {
        if self.isViewLoaded && (self.view.window != nil) && loadingAlertController?.isBeingPresented == nil && progressAlertController == nil {
            pendingAnnouncement.status = false
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let actionButton = UIAlertAction(title: actionText, style: .default) {[weak self] (result) in
                if let data = KeyChainService.sharedInstance.getData(key: AppConstants.ANNOUNCEMENT_DATA_KEY){
                    self?.clickedOnAnnouncementTarget(data:data)
                }
            }
            alertController.addAction(actionButton)
            homeScreenPresenter.updateLastAnnouncementShownDate()
            present(alertController, animated: true, completion: nil)
        }
        else{
            pendingAnnouncement = (true, title, message, actionText)
        }
    }
    
    func shouldShowAnnouncement() {
        if pendingAnnouncement.status == true {
            showAnnouncementAlertView(title: pendingAnnouncement.errorTitle, message: pendingAnnouncement.errorMessage, actionText: pendingAnnouncement.actionText)
        }
    }
    
    func showAnnouncement() {
        if let data = KeyChainService.sharedInstance.getData(key: AppConstants.ANNOUNCEMENT_DATA_KEY) {
            let announcementDataObj = NSKeyedUnarchiver.unarchiveObject(with: data) as? AnnouncementData
            if announcementDataObj?.showAgain == true {
                if homeScreenPresenter.shouldShowRepeatAnnouncement(announcementData: announcementDataObj) {
                    showAnnouncementAlertView(title: announcementDataObj?.title ?? "", message: announcementDataObj?.message ?? "", actionText: announcementDataObj?.actionText ?? "")
                }
            }
            else{
                if homeScreenPresenter.shouldShowOnceAnnouncement(announcementData:announcementDataObj) {
                    showAnnouncementAlertView(title: announcementDataObj?.title ?? "", message: announcementDataObj?.message ?? "", actionText: announcementDataObj?.actionText ?? "")
                }
            }
        }
        else{
            logToConsole(printObject:"Unable to get Announcement data from Keychain")
        }
    }
    
    //Delegate method on meta and mfadvisor data sync is complete
    internal func metaDataSyncDone() {
        loadData()
        //loadingAlertController?.dismiss(animated: false, completion: nil)
        if let alertController = loadingAlertController{
            alertController.dismiss(animated: false, completion: nil)
        }
        homeScreenPresenter.startCarouselScroll()
    }
    
    
    ///Display error
    internal func showErrorMessage(title:String?, message:String?) {
        loadingAlertController?.dismiss(animated: false, completion: nil)
        showRetryDialog(title: title ?? "error_title".localized, message: message ?? "error_message".localized)
    }
    
    private func showRetryDialog(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "retry".localized, style: UIAlertActionStyle.default, handler: {[weak self](action:UIAlertAction!) in
           self?.startSync()
        }))
        alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AppNotificationConstants.QUIZ_FORBBIDDEN_NOTIFICATION, object: nil)
    }
    
}


extension HomeScreenViewController{
    
    class MetaDataSyncListener: DataSyncDelegateProtocol{
        weak var parent: HomeScreenViewController! = nil
        private var isSyncErrorShown: Bool = false
        
        func metaDataDownloadComplete() {
            parent.metaDataSyncDone()
        }
        
        func dataSyncCompleteWithForbidden() {
            if !isSyncErrorShown{
                isSyncErrorShown = true
                parent.goToLoginPage()
            }
        }
        
        func dataSyncCompleteWithError(errorTitle: String?, errorMessage: String?) {
            if !isSyncErrorShown{
                isSyncErrorShown = true
                parent.showErrorMessage(title: errorTitle, message: errorMessage)
            }
        }
        
    }
    
}
