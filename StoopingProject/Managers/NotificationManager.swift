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
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    static func schedulePickupNotificationsForOrder(
        isNewCustomer: Bool,
        senderName: String,
        sundayDate: Date
    ) {
        guard notificationsEnabled else { return }
        
        let dateString = formattedDate(sundayDate)
        let body = buildPickupBody(isNewCustomer: isNewCustomer, senderName: senderName, sundayDate: dateString)
        
        let calendar = Calendar.current
        guard
            let nextFriday = nextWeekday(6, from: Date(), using: calendar),
            let nextSaturday = nextWeekday(7, from: Date(), using: calendar)
        else { return }
        
        scheduleOneTimeNotification(title: "Your Stooping Club Order is Ready 📦", body: body, date: nextFriday, hour: 9, minute: 0)
        scheduleOneTimeNotification(title: "Reminder: Confirm Your Stooping Club Pickup", body: "Just a reminder — \(body)", date: nextSaturday, hour: 9, minute: 0)
    }
    
    static func scheduleCheckoutConfirmation(
        title: String = "Order Confirmed!",
        body: String = "Thanks for your order. We'll text/email you with pickup details soon."
    ) {
        guard notificationsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { print("Error: \(error.localizedDescription)") }
        }
    }
    
    private static func buildPickupBody(isNewCustomer: Bool, senderName: String, sundayDate: String) -> String {
        if isNewCustomer {
            return "Hi, this is \(senderName) from Stooping Club Berkeley. Your order is ready for pickup.\n\nPlease text YES to confirm 2 pm this Sunday, \(sundayDate) at the parking lot of Security Public Storage, 1711 Eastshore Blvd, El Cerrito, CA 94530.\n\nOtherwise we will not pack your items. Thanks!"
        } else {
            return "Hi, your Stooping Club Berkeley order is ready for pickup.\n\nPlease text YES to confirm 2 pm this Sunday, \(sundayDate) at the parking lot of Security Public Storage, 1711 Eastshore Blvd, El Cerrito, CA 94530.\n\nOtherwise we will not pack your items. Thanks!"
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
