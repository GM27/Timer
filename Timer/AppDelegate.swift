//
//  AppDelegate.swift
//  Timer
//
//  Created by Jeremy Merezhko on 5/10/22.
//

import UIKit
import BackgroundTasks


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private func configureUserNotifications() {
      UNUserNotificationCenter.current().delegate = self
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     // makes the notifications show up while you are in the app:
        configureUserNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      
       
    }

    
    func applicationWillTerminate(_ application: UIApplication) {
    
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // makes the AppDelegate thr handler of the notifications while you are in the foreground 
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler(.banner)
  }
}
