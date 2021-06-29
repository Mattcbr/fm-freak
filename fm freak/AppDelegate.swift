//
//  AppDelegate.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var appClosingCounter = 1

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

    func applicationWillTerminate(_ application: UIApplication) {
        appClosingCounter = UserDefaults.standard.integer(forKey: Utils().appClosingKey) + 1
        if appClosingCounter > 9 {
            appClosingCounter = 0
        }
        UserDefaults.standard.setValue(appClosingCounter, forKey: Utils().appClosingKey)
    }

}

