//
//  onecaliosTests.swift
//  onecaliosTests
//
//  Created by Henry Kim on 2021/05/10.
//

import XCTest
@testable import Onecalios

class OnecaliosTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}


import Combine
import RxSwift

final class PlaygroundTests: XCTestCase {
    private let input = stride(from: 0, to: 10_000_000, by: 1)
    
    override class var defaultPerformanceMetrics: [XCTPerformanceMetric] {
        return [
            XCTPerformanceMetric("com.apple.XCTPerformanceMetric_TransientHeapAllocationsKilobytes"),
            .wallClockTime
        ]
    }
    
    func testCombine() {
        self.measure {
            _ = Publishers.Sequence(sequence: input)
                .map { $0 * 2 }
                .filter { $0.isMultiple(of: 2) }
//                .flatMap { Publishers.Just($0) }
                .count()
                .sink(receiveValue: {
                    print($0)
                })
        }
    }
    
    func testRxSwift() {
        self.measure {
            _ = Observable.from(input)
                .map { $0 * 2 }
                .filter { $0.isMultiple(of: 2) }
                .flatMap { Observable.just($0) }
                .toArray()
                .map { $0.count }
                .subscribe(onSuccess: { print($0) })
        }
    }
}
