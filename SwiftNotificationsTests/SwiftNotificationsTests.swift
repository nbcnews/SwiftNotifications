//
//  SwiftNotificationsTests.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import XCTest
@testable import SwiftNotifications

protocol PostableNotification {
    func post()
}

struct EmptyTestNotification: NotificationProtocol, PostableNotification, Equatable {
    init?(_ n: Notification) {}
    init() {}

    func post() {
        EmptyTestNotification.post()
    }
}

struct EmptyCodableNotification: CodableNotification, PostableNotification, Equatable {
}

class MObserver<T: NotificationProtocol> {
    typealias CallbackType = () -> Void
    private let observer = NotificationObserver<T>()
    private let callback: CallbackType?
    var observed = false

    init(_ callback: CallbackType? = nil) {
        self.callback = callback

        observer.observe(self, MObserver.observerMethod)
    }

    func observerMethod(notification: T) {
        observed = true
    }

    deinit {
        callback?()
    }
}

// Leaky observer
class CObserver<T: NotificationProtocol> {
    typealias CallbackType = () -> Void
    private let observer = NotificationObserver<T>()
    private let callback: CallbackType?
    var observed = false

    init(_ callback: CallbackType? = nil) {
        self.callback = callback

        // without [weak self] closure creates referencr cycle
        observer.observe {
            self.observed = true
        }
    }

    deinit {
        callback?()
    }
}

class SwiftNotificationsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func emptyObserverTest<T: PostableNotification & NotificationProtocol>(_ t: T) {
        let observer = NotificationObserver<T>()
        var called = false
        observer.observe {
            called = true
        }

        t.post()

        XCTAssert(called, "observer not called")
    }

    func observerWithArgumentTest<T: PostableNotification & NotificationProtocol & Equatable>(_ t: T) {
        let observer = NotificationObserver<T>()
        var called = false
        observer.observe { received in
            called = true
            if received != t {
                XCTFail("received message not equal to sent message")
            }
        }

        t.post()

        XCTAssert(called, "observer not called")
    }

    func testEmpty() {
        emptyObserverTest(EmptyTestNotification())
    }

    func testEmpty2() {
        observerWithArgumentTest(EmptyTestNotification())
    }

    func testCodable() {
        emptyObserverTest(CodableTestNotification())
    }

    func testCodable2() {
        observerWithArgumentTest(CodableTestNotification())
    }

    func testEmptyCodable() {
        emptyObserverTest(EmptyCodableNotification())
    }

    func testEmptyCodable2() {
        observerWithArgumentTest(EmptyCodableNotification())
    }

    func testMethodObserver() {
        let m = MObserver<TestNotification>()
        TestNotification().post()

        XCTAssert(m.observed, "method observer not called")
    }

    func testRefCycleMethodObserver() {
        var released = false
        let block = { (cb: @escaping MObserver.CallbackType) in
            // should be destroyed at the end of the block
            _ = MObserver<TestNotification>(cb)
        }

        block {
            released = true
        }

        XCTAssert(released, "class must be released")
    }

    func testRefCycleClosueObserver() {
        struct Notification: CodableNotification {}
        var released = false
        let block = { (cb: @escaping CObserver.CallbackType) in
            // should be destroyed at the end of the block
            _ = CObserver<Notification>(cb)
        }

        block {
            released = true
        }

        // we expect a leak due to circular reference
        XCTAssert(!released, "class must be released")
    }
}
