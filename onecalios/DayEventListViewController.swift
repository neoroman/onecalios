//
//  ViewController.swift
//  onecalios
//
//  Created by Henry Kim on 2021/05/10.
//

import UIKit
import RxSwift
import ReactorKit
import RxViewController
import RxLifeCycle

class DayEventListViewController: UIViewController, StoryboardView {
  var disposeBag = DisposeBag()

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var refreshEventsButton: UIButton!
  var activityIndicator = UIActivityIndicatorView()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.view.backgroundColor = .systemPink
    title = "💳 Calendar"
    setupActivityIndicator()
  }

  private func setupActivityIndicator() {
    activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    activityIndicator.style = .gray
    let rightItem = UIBarButtonItem(customView: activityIndicator)
    self.navigationItem.leftBarButtonItem = rightItem
  }

  func bind(reactor: DayEventListReactor) {
    setupLifeCycle(reactor)
    setupTapHandling(reactor)
    setupLoading(reactor)
    setupCalendarAccessGrant(reactor)

    reactor.state
      .map { $0.events }
      .distinctUntilChanged()
      .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
      .bind(to: tableView.rx.items(cellIdentifier: "EventCell")) { _, element, cell in
        cell.textLabel?.text = element.title
        cell.detailTextLabel?.text = String(describing: element.startDate)
      }
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.error }
      .subscribe { [unowned self] event in
        guard let error = event.element else { return }
        if error {
          let alert = UIAlertController(
            title: "Information",
            message: "There's no event today...oops!",
            preferredStyle: .alert
          )
          alert.addAction(
            UIAlertAction(title: "Ok", style: .cancel, handler: nil)
          )

          self.present(alert, animated: true, completion: nil)
        }
      }
      .disposed(by: disposeBag)
  }

  private func setupLifeCycle(_ reactor: DayEventListReactor) {
    self.rx.viewDidAppear
      .debug()
      .map { _ in Reactor.Action.refreshEventsButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    self.rx.viewDidAppear.map { _ in Reactor.Action.checkAuthorizationStatus }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    UIApplication.shared
      .rxLifeCycle.didBecomeActive
      .debug()
      .map { _ in Reactor.Action.refreshEventsButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func setupTapHandling(_ reactor: DayEventListReactor) {
    refreshEventsButton.rx.tap
      .map { Reactor.Action.refreshEventsButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    tableView.rx.itemSelected
      .subscribe { selectedRowIndexPath in
        self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
      }
      .disposed(by: disposeBag)
  }

  private func setupLoading(_ reactor: DayEventListReactor) {
    reactor.state.map { $0.load }
      .bind(to: activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)

    reactor.state
      .map { !$0.load }
      .bind(to: activityIndicator.rx.isHidden)
      .disposed(by: disposeBag)
  }

  private func setupCalendarAccessGrant(_ reactor: DayEventListReactor) {
    reactor.state
      .take(1)
      .map { !$0.isAuthorized }
      .map { _ in Reactor.Action.requestAuthorization }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    reactor.state
      .take(1)
      .distinctUntilChanged { $0.isAuthorized }
      .map { _ in Reactor.Action.refreshEventsButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}
