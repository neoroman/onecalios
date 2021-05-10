//
//  CalendarManager.swift
//  onecalios
//
//  Created by Henry Kim on 2021/05/15.
//

import Foundation
import EventKit
import RxSwift

// The "singleton" instance
let calendarInstance = CalendarManager()

public final class CalendarManager: NSObject {
  var eventStore: EKEventStore

  public class var shared: CalendarManager {
    return calendarInstance
  }

  public init(withEventStore eventStore: EKEventStore = EKEventStore()) {
    self.eventStore = eventStore
  }

  // Get Calendar auth status
  public var authorizationStatus: Observable<EKAuthorizationStatus> {
    return Observable<EKAuthorizationStatus>.create { single in
      let authStatus = self.getAuthorizationStatus()
      switch authStatus {
      case .notDetermined, .authorized, .restricted, .denied:
        single.onNext(authStatus)
      @unknown default:
        single.onError(RxError.unknown)
        assertionFailure("EKEventStore.authorizationStatus() is not available on this version of OS.")
      }
      return Disposables.create()
    }
  }

  // Request access to the Calendar
  public var requestAccess: Observable<Bool> {
    return Observable<Bool>.create { single in
      self.eventStore.requestAccess(to: EKEntityType.event) { authorizationStatus, error in
        if let error = error {
          single.onError(error)
        }
        single.onNext(authorizationStatus)
      }
      return Disposables.create()
    }
  }

  // Get Calendar Authorization status
  // TODO: Should it be private, right?
  func getAuthorizationStatus() -> EKAuthorizationStatus {
    return EKEventStore.authorizationStatus(for: EKEntityType.event)
  }
}
