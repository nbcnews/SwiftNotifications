//
//  ReferenceCycleTests.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import XCTest
@testable import SwiftNotifications

class ReferenceCycleTests: XCTestCase {

    // returns true if ObserverBased class was released afer init()
    // i.e. init call did not introduce reference cycle
    func referenceCycleTest(_ factory: ObserverTestCase.Type) -> Bool {
        var released = false
        let block = { (cb: @escaping ObserverTestCase.CallbackType) in
            _ = factory.init(cb)
        }

        block {
            released = true
        }

        return released
    }

    func testMethodObserver() {
        let released = referenceCycleTest(MethodObserver<TestNotification>.self)

        XCTAssert(released, "class must be released")
    }

    func testMethodObserverWithoutParameters() {
        let released = referenceCycleTest(MethodWithoutParametersObserver<TestNotification>.self)

        XCTAssert(released, "class must be released")
    }

    func testMultiObserver() {
        let released = referenceCycleTest(MultiObserver.self)

        XCTAssert(released, "class must be released")
    }

    func testSelectorObserver() {
        let released = referenceCycleTest(SelectorObserver.self)

        XCTAssert(released, "class must be released")
    }

    #if BLOCK_OBSERVERS
    // block observers - they leak
    func testLeakyClosueObserver() {
        struct Notification: CodableNotification {}
        let released = referenceCycleTest(LeakyClosureObserver<Notification>.self)

        // we expect a leak due to circular reference. Failure is success
        XCTAssert(!released, "class must not be released")
    }

    func testLeakyMethodObserver() {
        struct Notification: CodableNotification {}
        let released = referenceCycleTest(LeakyMethodObserver<Notification>.self)

        // we expect a leak due to circular reference. Failure is success
        XCTAssert(!released, "class must not be released")
    }
    #endif
}
