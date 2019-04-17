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
        let observer = MethodObserver<TestNotification>()
        TestNotification().post()

        XCTAssert(observer.observed, "method observer did not get called")
    }
}
