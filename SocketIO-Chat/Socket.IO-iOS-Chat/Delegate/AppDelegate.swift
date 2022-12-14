//
//  AppDelegate.swift
//  Socket.IO-iOS-Chat
//
//  Created by Apple iQlance on 07/10/2021.
//

import UIKit
import IQKeyboardManagerSwift
import SocketIO

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        //setRootViewcontroller(window: window)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        SocketHelper.shared.closeConnection()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SocketHelper.shared.establishConnection()
    }

}

func setRootViewcontroller(window: UIWindow?) {
    
    let navigationController = StoryBoard.landing.instantiateViewController(withIdentifier: "nav") as! UINavigationController
    
    if isLoggedIn {
        
        let tabbar = StoryBoard.landing.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
        navigationController.pushViewController(tabbar, animated: true)
        
    } else {
        
        let signInSignUpVC = StoryBoard.landing.instantiateViewController(withIdentifier: "JoinChatVC") as! JoinChatVC
        navigationController.pushViewController(signInSignUpVC, animated: false)
    }
    
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
}
