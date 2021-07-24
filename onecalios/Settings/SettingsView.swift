//
//  SettingsView.swift
//  Onecalios
//
//  Created by Henry Kim on 2021/07/24.
//

import SwiftUI

struct SettingsView: View {
  @AppStorage("numberOfQuestions") var numberOfQuestions = 6
  @AppStorage("appearance") var appearance: Appearance = .automatic
  @State var learningEnabled: Bool = true
  @AppStorage("dailyReminderEnabled") var dailyReminderEnabled = false
  @State var dailyReminderTime = Date(timeIntervalSince1970: 0)
  @AppStorage("dailyReminderTime") var dailyReminderTimeShadow: Double = 0
  @State var cardBackgroundColor: Color = .red

  var body: some View {
    List {
      Text("Settings")
        .font(.largeTitle)
        .padding(.bottom, 8)
      
      Section(header: Text("Appearance")) {
        VStack(alignment: .leading) {
          Picker("", selection: $appearance) {
            ForEach(Appearance.allCases) { appearance in
              Text(appearance.name).tag(appearance)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
          
          ColorPicker(
            "Card Background Color",
            selection: $cardBackgroundColor
          )
        }
      }
      
      Section(header: Text("Game")) {
        VStack(alignment: .leading) {
          Stepper(
            "Number of Questions: \(numberOfQuestions)",
            value: $numberOfQuestions,
            in: 3 ... 20
          )
          Text("Any change will affect the next game")
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        
        Toggle("Learning Enabled", isOn: $learningEnabled)
      }
      
      Section(header: Text("Notifications")) {
        HStack {
          Toggle("Daily Reminder", isOn: Binding(
            get: { dailyReminderEnabled },
            set: { newValue in
              dailyReminderEnabled = newValue
              configureNotification()
            }
          ))
          DatePicker(
            "",
            selection: Binding(
              get: { dailyReminderTime },
              set: { newValue in
                dailyReminderTimeShadow = newValue.timeIntervalSince1970
                dailyReminderTime = newValue
                configureNotification()
              }
            ),
            displayedComponents: .hourAndMinute
          )
          .datePickerStyle(CompactDatePickerStyle())
          .disabled(dailyReminderEnabled == false)
        }
      }
    }
    .onAppear {
      dailyReminderTime = Date(timeIntervalSince1970: dailyReminderTimeShadow)
    }
  }
  
  func configureNotification() {
    if dailyReminderEnabled {
      LocalNotifications.shared.createReminder(time: dailyReminderTime)
    } else {
      LocalNotifications.shared.deleteReminder()
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
