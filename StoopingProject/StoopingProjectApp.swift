//
//  StoopingProjectApp.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/7/26.
//

import SwiftUI
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .list])
    }
}

@main
struct StoopingProjectApp: App {
    let notificationDelegate = NotificationDelegate()
    @StateObject var shopify = ShopifyService()
    
    init() {
        NotificationManager.requestPermission()
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(shopify)
                .onAppear {
                    NotificationManager.requestPermission()
                }
        }
    }
}

