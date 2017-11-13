//
//  AppDelegate.swift
//  licsuperagent
//
//  Created by kunal singh on 09/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import CoreData
import Core
import mfadvisor
import Firebase
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let mainStoryBoard = UIStoryboard(name: LICConfiguration.MAIN_STORYBOARD, bundle: nil)
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let mfaManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let offlineSyncer = OfflineSyncer()
    var homeScreenInteractor: HomeScreenInteractor?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(#function)
        // Override point for customization after application launch.
        managedObjectContext.persistentStoreCoordinator = CoreDataService.sharedInstance.persistentStoreCoordinator
        mfaManagedObjectContext.persistentStoreCoordinator = MFADataService.sharedInstance.persistentStoreCoordinator
        clearKeychainPreviousData()
        registerPushNotification()
        goToHomeController()
        initialiseExternalServices()
        addbackgroundFetchForMetaDataSyncing()
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        syncMetaData(completionHandler: completionHandler)
    }
    
    func initialiseExternalServices() {
        let extentalServices : [ExternalServicesProtocol] = [FabricService(),FirebaseService(), ApptentiveService()]
        for externalService in extentalServices {
            externalService.initializeService()
        }
    }
    
    func registerPushNotification() {
        let pushNotificationService = PushNotificationService()
        pushNotificationService.registerPushNotification()
        pushNotificationService.updateFCMOnServer(completionHandler: nil)
        pushNotificationService.updateAppVersionTopicOnFirebase()
    }
    
    func clearKeychainPreviousData() {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: AppConstants.APP_INSTALLED_KEY) == false {
            KeyChainService.sharedInstance.deleteAllKeychainValue()
            userDefaults.set(true, forKey: AppConstants.APP_INSTALLED_KEY)
            userDefaults.synchronize() // Forces the app to update UserDefaults
        }
    }
    
    func goToHomeController() {
        
        if let _ = KeyChainService.sharedInstance.getValue(key: ConfigKeys.ACCESS_TOKEN_KEY) {
            guard let userData = KeyChainService.sharedInstance.getData(key: ConfigKeys.USER_DATA_KEY),let userDataObj =  NSKeyedUnarchiver.unarchiveObject(with: userData) as? UserData               else{
                gotoLoginController()
                return
            }
            
            if userDataObj.registrationStatus == true{
                gotoMainTabbarController()
            }
            else{
                gotoRegistrationController(userData:userDataObj)
            }
        }
        else {
            gotoLoginController()
        }
    }
    
    func gotoRegistrationController(userData:UserData) {
        if let nextViewController = mainStoryBoard.instantiateViewController(withIdentifier: LICConfiguration.REGISTRATION_CONTROLLER) as? RegistrationViewController{
            nextViewController.userData = userData
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }
    }
    
    func gotoMainTabbarController() {
        let initialViewController = mainStoryBoard.instantiateViewController(withIdentifier: LICConfiguration.HOMESCREEN_TABBAR_CONTROLLER) as! UITabBarController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func gotoLoginController() {
        KeyChainService.sharedInstance.deleteAllKeychainValue()
        let initialViewController = mainStoryBoard.instantiateViewController(withIdentifier: LICConfiguration.LOGIN_NAVIGATION_CONTROLLER) as! UINavigationController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func saveDBContext(){
        managedObjectContext.performAndWait {
            do {
                try self.managedObjectContext.save()
            }catch let error {
                print(error)
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        offlineSyncer.stopListening()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        offlineSyncer.startListening()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
            if (rootViewController.responds(to: Selector(("canRotate")))) {
                return .allButUpsideDown;
            }
        }
        // Only allow portrait(default)
        return .portrait;
    }
    
    func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if (rootViewController.isKind(of: UITabBarController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        } else if (rootViewController.isKind(of: UINavigationController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        } else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
}

