//
//  AppDelegate.swift
//  ramble-ios, Hexiao Zhang
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import UIKit
//import Fabric
//import Crashlytics
//import Firebase
import FBSDKCoreKit
import Parse
import GooglePlaces
import Stripe
import UserNotifications
import ParseLiveQuery
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //      Fabric.with([Crashlytics.self])
        //        FirebaseApp.configure()
        ParseSetup.setup()
        registerForPushNotifications()
        registerFacebook(application: application, launchOptions: launchOptions)
        GMSPlacesClient.provideAPIKey(Config.GooglePlaces.key)
        STPAPIClient.shared().publishableKey = Config.StripeKey.key
        Appearance.config()
        forceUpdateIfNeeded()
//===========How to set the launch Screen manually============
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "SplashController")
//        self.window?.rootViewController = viewController
//        self.window?.makeKeyAndVisible()
//=========================================================
//        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
//            if let result = userInfo["aps"] as? NSDictionary {
//                if let category = result["category"], category as! String == "receiveMessage" {
//                    replaceRootViewController(to: RMBNavigationController(rootViewController: MessageController()), animated: true, completion: nil)
//                }
//            }
//        }
        return true
    }
    
    // MARK: - Push Notifications
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
            
            guard granted else { return }
            Installation.current()?.linkUser()
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = Installation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.user = User.current()
        installation?.saveInBackground { success, error in
            print("Saving device token for push notification: \(success)")
            print("Saving device token for push notification error: \(error?.localizedDescription ?? "N/A")")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(#function)
        print(error)
    }

    // App was running either in the foreground, or the background, it will be called
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(#function)
        print("notification opened")
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
        // or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
        // Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data
        // invalidate timers, and store enough application state information
        // to restore your application to its current state in case it is terminated later.
        // If your application supports background execution,
        // this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state;
        // here you can undo many of the changes made on entering the background.
        Installation.current()?.resetBadge()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Installation.current()?.resetBadge()
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
        if MockSocket.shared.isConnectedChat == true {
            MockSocket.shared.liveQueryClient.disconnect()
        }
        if MockSocket.shared.isConnectedMessageList == true {
            MockSocket.shared.liveQueryClient.disconnect()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        let sourceApplication: String? = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        
        return ApplicationDelegate.shared.application(app, open: url, sourceApplication: sourceApplication, annotation: nil)
    }
    
    // MARK: - Facebook
    private func registerFacebook(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    /** Check if update is necessary */
    func forceUpdateIfNeeded() {
        // You need to fetch these parameters
        do {
            let config = try PFConfig.getConfig()
            // Minimum app version needed, should be fetched with a call to the backend. Used for TestFlight or Crashlytics (TF)
            //let minVersion: String = "1.0.0"
            // The minimal build number to run the app. used for App Store (AS)
            // FIXME: create this config variable in the Parse Dashboard
            let minVersion: String = config["Ramble_iOSMinimumVersion"] as? String ?? "1"
            // The environment target
            let environment: Environment = .appStore
            // The url you want to redirect user
            let url: String = "itms-apps://itunes.apple.com/us/app/apple-store/id\(Config.App.appStoreId)?mt=8"
            
            if let window = self.window, let controller = self.window?.rootViewController {
                let isNotForceUpdateVc = !(controller is ForceUpdateViewController)
                let isBuildOutdated = ForceUpdate.isBuildOutdated(for: minVersion, minBuild: "1", environment: environment)
                if isNotForceUpdateVc && isBuildOutdated {
                    window.rootViewController = ForceUpdate.viewController(for: url, environment: environment)
                    window.makeKeyAndVisible()
                }
            }
        } catch {
            print(error)
            print("Unable to check for minimum version.")
        }
    }
     
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    @available(iOS 10.0, *)
    internal func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         willPresent notification: UNNotification,
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Present push notification when app is in foreground
        if notification.request.content.categoryIdentifier == "receiveMessage"
        {
            NotificationCenter.default.post(name: NSNotification.Name.updateNotificationIcon, object: nil, userInfo: nil )
            if MockSocket.shared.isConnectedChat == false && MockSocket.shared.isConnectedMessageList == false
            {completionHandler([.alert, .sound])}
        } else {
            completionHandler([.alert, .sound])
        }
    }
    
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            // check if it is local notification
            guard let id = response.notification.request.content.userInfo["event"]
                else {
            // deal it as remote notification
                let identifier = response.notification.request.content.categoryIdentifier
                    switch identifier {
                    case "receiveMessage":
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute:{
                             replaceRootViewController(to: RMBNavigationController(rootViewController: MessageController()), animated: true, completion: nil)
                            })
                       
                    default:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute:{
                        replaceRootViewController(to: RMBNavigationController(rootViewController: MessageController(segmentIndex: 1)), animated: true, completion: nil)
                             })
                    }
                return
               }
            if response.notification.request.identifier == "reviewReminder" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{
                NotificationCenter.default.post(name: NSNotification.Name.pushRatingController, object: nil, userInfo: ["eventId" : id as! String] )
                })
            }
        }
    
}//end of appDelagate extension
