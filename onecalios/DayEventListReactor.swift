//
//  DayEventListReactor.swift
//  onecalios
//
//  Created by Henry Kim on 2021/05/11.
//

import UIKit
import RxSwift
import ReactorKit
import EventKit


class DayEventListReactor: Reactor {
  enum Action {
    case refreshEventsButtonTapped
    case checkAuthorizationStatus
    case requestAuthorization
  }

  enum Mutation {
    case showActivity, hideActivity
    case checkAuthorization(EKAuthorizationStatus)
    case successWithEvents([EKEvent]), errorRequest
    case successWithAuth(Bool)
  }

  struct State {
    var authStatus: EKAuthorizationStatus = .notDetermined
    var isAuthorized = false
    var load = false
    var events: [EKEvent] = []
    var error = false
    var errorText = ""
  }

  let initialState: State
  init() {
    initialState = State()
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refreshEventsButtonTapped:
      return Observable.concat(
        [
          Observable.just(Mutation.showActivity),
          fetchEvents(),
          Observable.just(Mutation.hideActivity)
        ]
      )
    case .checkAuthorizationStatus:
      return Observable.concat([checkAuthorizationStatus()])
    case .requestAuthorization:
      return Observable.concat([requestAuth()])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .showActivity:
      newState.load = true
    case .hideActivity:
      newState.load = false
    case .errorRequest:
      newState.error = true
      newState.events = []
    case .successWithEvents(let data):
      newState.error = false
      newState.events = data
    case .checkAuthorization(let status):
      newState.authStatus = status
    case .successWithAuth(let yesOrNo):
      newState.isAuthorized = yesOrNo
    }
    return newState
  }

  // MARK: - Private

  private func fetchEvents() -> Observable<Mutation> {
    // Thanks to stackoverflow.com/a/48695958
    let date = Date() // current date or replace with a specific date
    let calendar = Calendar.current
    let startTime = calendar.startOfDay(for: date)
    guard let endTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date) else {
      return Observable.never()
    }

    let store = CalendarManager.shared.eventStore
    let predicate = store.predicateForEvents(withStart: startTime, end: endTime, calendars: nil)

    // Fetch all events that match the predicate
    // TODO: find more elegant way, plz...!
    if CalendarManager.shared.getAuthorizationStatus() == .authorized {
      let merong = store.events(matching: predicate)
      if merong.isEmpty {
        return .just(.errorRequest)
      } else {
        return .just(.successWithEvents(merong))
      }
    }
    return Observable.never()
  }

  private func checkAuthorizationStatus() -> Observable<Mutation> {
    CalendarManager.shared.authorizationStatus
      .map { authStatus in
        return .checkAuthorization(authStatus)
      }
  }

  private func requestAuth() -> Observable<Mutation> {
    CalendarManager.shared.requestAccess
      .observe(on: MainScheduler.instance)
      .flatMap { status -> Observable<Mutation> in
        if status {
          return .just(.successWithAuth(true))
        }
        return .just(.successWithAuth(false))
      }
  }
}
