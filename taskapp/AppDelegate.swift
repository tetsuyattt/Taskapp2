//
//  AppDelegate.swift
//  taskapp
//
//  Created by 富樫　哲也 on 2023/06/11.
//

import UIKit
import UserNotifications  //追加１５　ローカル通知設定

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//↑追加１８フォアグラウンドでも通知　UNUserNotificationCenterDelegateを追加


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        //ユーザーに許可を求める-----------------ここから追加１５
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            //Enable ordisable features based on authorization
        }
        //-------------------------------ここまで追加１５
        
        center.delegate = self  //追加１８（２）
        
        return true
    }
    
    //↓--------追加１８(３）アプリがフォアグラウンド（表示中）の時に通知を受け取ると呼ばれるメソッド
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)  {
        completionHandler([.banner, .list, .sound])
    }
    //------------------ここまで追加１８(３）

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


}

