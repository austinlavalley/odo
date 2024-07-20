//
//  NotificationManager.swift
//  odo
//
//  Created by Austin Lavalley on 7/19/24.
//

import SwiftUI
import UserNotifications


class NotificationManager: ObservableObject {
    
    
    init() {
        checkForPermission()
    }

    
    func checkForPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
            case .denied:
                return
            case .authorized:
                self.dispatchNotification()
            default:
                return
            }
        }
    }
    
    
    
    
    func dispatchNotification() {
        let identifier = "notif-one"
        let title = "TITLE"
        let body = "BODY"
        let hour = 10
        let minute = 22
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
    
}
