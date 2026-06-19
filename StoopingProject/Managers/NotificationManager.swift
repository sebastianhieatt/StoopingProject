//
//  NotificationManager.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/9/26.
//
import UserNotifications

class NotificationManager {
    
    // Change this to true to enable notifications, false to disable
    static var notificationsEnabled: Bool = true
    
    // Call this once when the app starts to ask for permission
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    // Call this to schedule a notification at a specific time
    static func scheduleNotification(title: String, body: String, weekday: Int, hour: Int, minute: Int) {
        
        guard notificationsEnabled else {
            print("Notifications are disabled.")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for weekday \(weekday) at \(hour):\(String(format: "%02d", minute))")
            }
        }
    }
    
    // Call this to fire a one-time notification shortly after checkout
    static func scheduleCheckoutConfirmation(title: String = "Order Confirmed!", body: String = "Thanks for your order. We'll text/email you with pickup details soon.") {
        
        guard notificationsEnabled else {
            print("Notifications are disabled.")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // Fires 2 seconds after checkout completes
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling checkout notification: \(error.localizedDescription)")
            } else {
                print("Checkout confirmation notification scheduled.")
            }
        }
    }
}
