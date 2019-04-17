//
//  ReferenceCycleTests.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import XCTest
@testable import SwiftNotifications

// ObserverTestCase helps with setup of test cases for various scenarios.
// Callback passed to init() gets called from deinit to verify that
// ObserverTestCase class was actually released
class ObserverTestCase {
    typealias CallbackType = () -> Void
    private let callback: CallbackType?
    var observed = false

    required init(_ callback: CallbackType? = nil) {
        self.callback = callback
    }

    deinit {
        callback?()
    }
}

// Test case for method observer.
class MethodObserver<T: NotificationProtocol>: ObserverTestCase {
    private let observer = NotificationObserver<T>()

    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        observer.observe(self, MethodObserver.observerMethod)
    }

    func observerMethod(notification: T) {
        observed = true
    }
}

// Test case for method without parameters observer 
class MethodWithoutParametersObserver<T: NotificationProtocol>: ObserverTestCase {
    private let observer = NotificationObserver<T>()

    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        observer.observe(self, MethodWithoutParametersObserver.observerMethod)
    }

    func observerMethod() {
        observed = true
    }
}

// LeakyClosureObserver demonstrates memory leak produced by reference
// cycle due to `self` capture by closure
class LeakyClosureObserver<T: NotificationProtocol>: ObserverTestCase {
    private let observer = NotificationObserver<T>()

    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        // without [weak self] closure creates reference cycle
        observer.observe {
            self.observed = true
        }
    }
}

// LeakyMethodObserver demonstrates memory leak produced by reference
// cycle due to passing method reference to wrong observe call
class LeakyMethodObserver<T: NotificationProtocol>: ObserverTestCase {
    private let observer = NotificationObserver<T>()

    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        // strong reference to self is implicitly created.
        // observerMethod == observerMethod(self)
        observer.observe(using: observerMethod)
    }

    func observerMethod(notification: T) {
        observed = true
    }
}

// Test of #selector based observer. Unrelated to SwiftNotifications.
// Just wanted to verify that #selector observer doesn't create ref cycle.
class SelectorObserver: ObserverTestCase {
    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        NotificationCenter.default.addObserver(self, selector: #selector(observe), name: Notification.Name("Poontik"), object: nil)
    }

    @objc
    func observe(notification: Notification) {
        observed = true
    }
}

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

    func testSelectorObserver() {
        let released = referenceCycleTest(SelectorObserver.self)

        XCTAssert(released, "class must be released")
    }
}
