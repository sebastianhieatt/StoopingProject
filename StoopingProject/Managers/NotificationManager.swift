//
//  NotificationManager.swift
//  StoopingProject
//
//  Created by SebastianHieatt on 6/9/26.
//
import UserNotifications

class NotificationManager {
    
    static var notificationsEnabled: Bool = true
    
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("🔔 Permission granted: \(granted)")
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    // TEMPORARY - for testing only
    static func scheduleTestNotificationForToday(title: String, body: String, hour: Int, minute: Int) {
        
        guard notificationsEnabled else {
            print("Notifications are disabled.")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // If that time today has already passed, this fires immediately/next minute instead of waiting a week
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling test notification: \(error.localizedDescription)")
            } else {
                print("Test notification scheduled for today at \(hour):\(String(format: "%02d", minute))")
            }
        }
    }
    
    
    
    static func schedulePickupNotificationsForOrder(
        sundayDate: Date
    ) {
        guard notificationsEnabled else { return }
        
        let calendar = Calendar.current
        guard let nextFriday = nextWeekday(6, from: Date(), using: calendar) else { return }
        let nextSaturday = Calendar.current.date(byAdding: .day, value: 1, to: nextFriday) ?? nextFriday
        
        scheduleOneTimeNotification(title: "Reminder: Pickup is at 2pm today!", body: "1711 Eastshore Blv, El Cerrito, CA 94530", date: nextSaturday, hour: 9, minute: 0)
        scheduleOneTimeNotification(title: "Reminder: Confirm Your Stooping Club Pickup", body: "", date: nextFriday, hour: 9, minute: 0)
    }
    static func checkAuthStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("🔔 Auth status: \(settings.authorizationStatus.rawValue)")
            // 0 = notDetermined, 1 = denied, 2 = authorized, 3 = provisional, 4 = ephemeral
        }
    }
    static func scheduleCheckoutConfirmation(
        title: String = "Order Confirmed!",
        body: String = "Thanks for your order. We'll text/email you with pickup details soon."
    ) {
        checkAuthStatus()
        guard notificationsEnabled else {
            print("🚫 Notifications disabled")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification add error: \(error.localizedDescription)")
            } else {
                print("✅ Notification added to queue")
            }
        }
    }
    
    
    
    private static func scheduleOneTimeNotification(title: String, body: String, date: Date, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }
    
    private static func nextWeekday(_ weekday: Int, from date: Date, using calendar: Calendar) -> Date? {
        var components = DateComponents()
        components.weekday = weekday
        return calendar.nextDate(after: date, matching: components, matchingPolicy: .nextTime)
    }
    
    private static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: date)
    }
}
