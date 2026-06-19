//
//  StoopingProjectApp.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/7/26.
//

import SwiftUI

@main
struct StoopingProjectApp: App {
    @StateObject var shopify = ShopifyService()
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

