//
//  DispatchExtension.swift
//  Onecalios
//
//  Created by Henry Kim on 2021/06/05.
//

import Foundation

extension DispatchQueue {
    func after(_ delay: TimeInterval, execure closure: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: closure)
    }
}
