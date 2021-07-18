//
//  ViewController.swift
//  onecalios
//
//  Created by Henry Kim on 2021/05/10.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxViewController
import RxLifeCycle
import EventKitUI

class DayEventListViewController: UIViewController, StoryboardView {     
    var disposeBag = DisposeBag()
    let eventEditVC = EKEventEditViewController()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshEventsButton: UIButton!
    var activityIndicator = UIActivityIndicatorView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.reactor = DayEventListReactor()
    }   
    
    required init?(coder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        
        self.reactor = DayEventListReactor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemPink
        title = "💳 Calendar"
        setupActivityIndicator()
    }
        
    private func showEventVC(forEvent event: EKEvent) {
        eventEditVC.eventStore = CalendarManager.shared.eventStore
        eventEditVC.event = event
        eventEditVC.editViewDelegate = self
        
        self.navigationController?.present(eventEditVC, animated: true, completion: { 
            // code
        })
    }
    
    private func setupActivityIndicator() {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.style = .medium
        let leftItem = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    func bind(reactor: DayEventListReactor) {
        setupLifeCycle(reactor)
        setupTapHandling(reactor)
        setupLoading(reactor)
        setupCalendarAccessGrant(reactor)
        setupEventEditHandling(reactor)
        
        reactor.state
            .map { $0.events }
            .distinctUntilChanged()
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "EventCell")) { _, element, cell in
                cell.textLabel?.text = element.title
                if let start = element.startDate {
                    cell.detailTextLabel?.text = start.description
                }
                if let end = element.endDate {
                    cell.detailTextLabel?.text?.append(" ~ ")
                    cell.detailTextLabel?.text?.append(end.description)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.error }
            .subscribe { [unowned self] event in
                guard let error = event.element else { return }
                if error {
                    let alert = UIAlertController(
                        title: nil,
                        message: "There's no event today...oops!",
                        preferredStyle: .alert
                    )
//                    alert.addAction(
//                        UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//                    )
                    self.present(alert, animated: true, completion: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.3, execute: {
                        alert.dismiss(animated: true, completion: nil)
                        
                    })
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupLifeCycle(_ reactor: DayEventListReactor) {
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.refreshEventsButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewDidAppear.map { _ in Reactor.Action.checkAuthorizationStatus }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        UIApplication.shared
            .rxLifeCycle.didBecomeActive
            .map { _ in Reactor.Action.refreshEventsButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        UIApplication.shared
            .rxLifeCycle.willResignActive
            .debug()
            .map { _ in Reactor.Action.willResignActive }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func setupTapHandling(_ reactor: DayEventListReactor) {
        refreshEventsButton.rx.tap
            .map { Reactor.Action.refreshEventsButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        /* OK */
        tableView.rx.itemSelected
            .subscribe(onNext: { selectedRowIndexPath in 
                DispatchQueue.main.after(1) {
                    self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
                if let stateEvents = self.reactor?.currentState.events {
                    self.showEventVC(forEvent: stateEvents[selectedRowIndexPath.row])
                }
            })
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
    
    private func setupEventEditHandling(_ reactor: DayEventListReactor) {
        /* 
         Try this but failed with error of
         2021-06-05 15:37:22.741943+0900 Onecalios[16640:379162] RxCocoa/DelegateProxyType.swift:202: Assertion failed
         eventVC.rx.myEventEditViewDelegate.asObservable()
         .bind { _ in }
         .disposed(by: disposeBag)
         */
        eventEditVC.rx.viewWillDisappear.asObservable()
            .debug("Event edit view dismissed")
            .map { _ in Reactor.Action.refreshEventsButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        eventEditVC.rx.viewDidAppear.asObservable()
            .debug("Event edit view appear")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if let eventTableVC = self?.eventEditVC.viewControllers.first as? UITableViewController,
                   let eventTable = eventTableVC.tableView {
                    // let top = CGPoint(x: 0, y: -eventTable.contentInset.top)
                    // eventTable.setContentOffset(top, animated: false)
                    eventTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
                    if let titleCell = eventTable.cellForRow(at: IndexPath(row: 0, section: 0)) {
                        // TOOD: (2020.06.12) this should be moved into settings...!
                        if let title = (titleCell.contentView.subviews.first as? UITextField)?.text, 
                           title.hasPrefix("이동:") { 
                            return 
                        }
                        if let locationCell = eventTable.cellForRow(at: IndexPath(row: 1, section: 0)),
                           let title = locationCell.textLabel?.text,
                           let cellTitle = locationCell.description.components(separatedBy: "text = ")[1].components(separatedBy: ";").first,
                           cellTitle.contains(title) {
                            // TODO: (2021.06.12) Using currentEvent.structuredLocation for inserting current location forcefully
                            // guard let indexPath = self?.tableView.indexPathForSelectedRow else { return }
                            // guard let myReactor = self?.reactor else { return }
                            // let currentEvent = myReactor.currentState.events[indexPath.row]
                            // currentEvent.location = CLLocationManager
                            locationCell.textLabel?.text = "메롱"
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension DayEventListViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        switch action {
            case .canceled:
                print("event edit canceled...")
            case .deleted:
                print("event deleted...")
            case .saved:
                print("event saved...")
            case .cancelled:
                print("event cancelled...")
            @unknown default:
                fatalError("Fatal Error for event edit view action")
        }
        controller.dismiss(animated: true) { 
            // code
        }
    }
}
