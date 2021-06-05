//
//  EKEventUI+Rx.swift
//  Onecalios
//
//  Created by Henry Kim on 2021/06/05.
//

import Foundation
import RxSwift
import RxCocoa
import EventKitUI

class RxEKEventEditViewDelegateProxy: DelegateProxy<EKEventEditViewController, EKEventEditViewDelegate>,
                                      DelegateProxyType, EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) { }
    
    static func registerKnownImplementations() {
        self.register { eventEditView -> RxEKEventEditViewDelegateProxy in
            RxEKEventEditViewDelegateProxy(parentObject: eventEditView, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: EKEventEditViewController) -> EKEventEditViewDelegate? {
        return object.editViewDelegate
    }
    
    static func setCurrentDelegate(_ delegate: EKEventEditViewDelegate?, to object: EKEventEditViewController) {
        object.delegate = delegate as? UINavigationControllerDelegate
    }
}

extension Reactive where Base: EKEventEditViewController {
    var editViewDelegate: DelegateProxy<EKEventEditViewController, EKEventEditViewDelegate> {
        return RxEKEventEditViewDelegateProxy.proxy(for: self.base)
    }
    
    var myEventEditViewDelegate: Observable<Bool> {
        return editViewDelegate.methodInvoked(#selector(EKEventEditViewDelegate.eventEditViewController(_:didCompleteWith:)))
            .debug("Success to delegate...!")
            .map { _ in return true }
    }
}
