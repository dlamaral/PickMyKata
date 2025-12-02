//
//  NotificationService.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 23/10/2025.
//

import Foundation
import UserNotifications

class NotificationService {
    
    static let shared = NotificationService()
    private init() {}
    
    /// Requests authorization from the user to send notifications.
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
            completion(granted)
        }
    }
    
    /// Schedules reminders for the next 7 days.
    /// Skips "Today" if the user has already completed their goal.
    func scheduleUpcomingReminders(isGoalMetForToday: Bool) {
        // 1. Clear any old schedule so we don't duplicate
        cancelAllReminders()
        
        // 2. Check Permission first
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            
            let calendar = Calendar.current
            let now = Date()
            
            // 3. Schedule for the next 7 days
            for dayOffset in 0..<7 {
                
                // If today is already done, skip index 0
                if dayOffset == 0 && isGoalMetForToday {
                    continue
                }
                
                // Calculate the date
                guard let futureDate = calendar.date(byAdding: .day, value: dayOffset, to: now) else { continue }
                
                // Set the time to 7:00 PM (19:00)
                var components = calendar.dateComponents([.year, .month, .day], from: futureDate)
                components.hour = 19
                components.minute = 0
                components.second = 0
                
                // Safety check: If "Today 7 PM" has already passed, don't schedule it.
                if let targetDate = calendar.date(from: components), targetDate < now {
                    continue
                }
                
                // Create Content
                let content = UNMutableNotificationContent()
                content.title = "Ready to Practice?"
                content.body = "Keep your streak alive! Master your next kata."
                content.sound = .default
                
                // Create Trigger (One-time, not repeating)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                
                // Unique Identifier for each day (e.g., "reminder-2023-10-27")
                let id = "reminder-\(dayOffset)"
                
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
            print("Scheduled reminders for the week (Today skipped: \(isGoalMetForToday))")
        }
    }
    
    /// Cancels all practice reminders.
    func cancelAllReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// Specifically cancels ONLY today's notification (used when goal is hit).
    func cancelTodayReminder() {
        // Based on our logic above, today is always index 0
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["reminder-0"])
        print("Cancelled today's reminder.")
    }
}
