//
//  CheckoutPageView.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/7/26.
//

import Foundation

//add a button to have notifications or not at checkout page
//NotificationManager.notificationsEnabled = true
//NotificationManager.notificationsEnabled = false

NotificationManager.scheduleNotification(
    title: "Hello!",
    body: "Pickup is at",
    weekday: 2,
    hour: 9,
    minute: 0
)
