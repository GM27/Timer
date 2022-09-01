//
//  NotificationManager.swift
//  Timer
//
//  Created by Jeremy Merezhko on 8/16/22.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared  = NotificationManager()
 
func requestAuthorization(completion: @escaping  (Bool) -> Void) {
  UNUserNotificationCenter.current()
    .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
     
      completion(granted)
    }
}
    
func scheduleNotification(task: Task) {
      // 2
      let content = UNMutableNotificationContent()
      content.title = task.name
      content.body = "Timer has expired!"
     content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "THE-KILLER-IS-ESCAPING.wav"))
      var trigger: UNNotificationTrigger?

        if let timeInterval = task.reminder.timeInterval {
          trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,repeats: task.reminder.repeats)
        }
     
      // 4
      if let trigger = trigger {
        let request = UNNotificationRequest(
          identifier: task.id,
          content: content,
          trigger: trigger)
          
        
        // 5
        UNUserNotificationCenter.current().add(request) { error in
          if let error = error {
            print(error)
          }
        }
      }
    }
    
}
 

struct Task: Identifiable, Codable {
  var id = UUID().uuidString
  var name: String
  var completed = false
  var reminderEnabled = false
  var reminder: Reminder
    
    
    
}


struct Reminder: Codable {
  var timeInterval: TimeInterval?
  var date: Date?
  var repeats = false
}

