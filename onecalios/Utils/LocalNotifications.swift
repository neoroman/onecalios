//
//  LocalNotifications.swift
//  Onecalios
//
//  Created by Henry Kim on 2021/07/24.
//

import Foundation
import UserNotifications

class LocalNotifications {
  static var shared = LocalNotifications()

  var lastKnownPermission: UNAuthorizationStatus?
  var userNotificationCenter: UNUserNotificationCenter { UNUserNotificationCenter.current() }

  private init() {
    self.userNotificationCenter.getNotificationSettings { settings in
      let permission = settings.authorizationStatus
      if permission == .notDetermined || permission == .ephemeral || permission == .provisional {
        self.requestLocalNotificationPermission(completion: { _ in })
      }
    }
  }
  
  func createReminder(time: Date) {
    deleteReminder()
    self.userNotificationCenter.getNotificationSettings { settings in
      let content = UNMutableNotificationContent()
      content.title = "OneCaliOS"
      content.subtitle = "It's time to 1 Calendar for your iOS"
      
      if settings.soundSetting == .enabled {
        content.sound = UNNotificationSound.default
      }
          
      var date = DateComponents()
      date.calendar = Calendar.current
      date.timeZone = TimeZone.current
      date.hour = Calendar.current.component(.hour, from: time)
      date.minute = Calendar.current.component(.minute, from: time)
      
      let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
      
      let reminder = UNNotificationRequest(
        identifier: "OneCaliOS-reminder",
        content: content,
        trigger: trigger
      )
      
      self.userNotificationCenter.add(reminder)
    }
  }
  
  func deleteReminder() {
    self.userNotificationCenter.removeAllDeliveredNotifications()
  }
  
  func requestLocalNotificationPermission(completion: @escaping (_ granted: Bool) -> Void) {
    let options: UNAuthorizationOptions = [.alert, .sound]
    
    self.userNotificationCenter.requestAuthorization(options: options) { granted, error in
      DispatchQueue.main.async {
        if let error = error {
          print(error)
          completion(false)
          return
        }
        
        guard granted else {
          completion(false)
          return
        }
        
        completion(true)
      }
    }
  }
}
