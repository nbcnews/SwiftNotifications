//
//  SwiftNotificationsTests.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import XCTest
@testable import SwiftNotifications

protocol PostableNotification {
    func post()
}

class SwiftNotificationsTests: XCTestCase {
    func testMethodObserver() {
        let observer = MethodObserver<TestNotification>()
        TestNotification().post()

        XCTAssert(observer.observed, "method observer did not get called")
    }

    func testMethodWithoutParametersObserver() {
        let observer = MethodWithoutParametersObserver<TestNotification>()
        TestNotification().post()

        XCTAssert(observer.observed, "method observer did not get called")
    }

    func testMultiObserver() {
        let multi = MultiObserver()
        TestNotification().post()
        EmptyTestNotification().post()
        CodableTestNotification().post()

        XCTAssert(multi.observedTest)
        XCTAssert(multi.observedEmpty)
        XCTAssert(multi.observedCodable)
    }

    func testReleasingObservers() {
        class Foo: ObserverTestCase {
            func on(testNotification: TestNotification) {
                observed = true
            }
        }

        var f: Foo? = Foo()
        let o = Observers(f!)
        o.observe(Foo.on(testNotification:))
        f = nil
        TestNotification().post()
    }
}

#if BLOCK_OBSERVERS
class BlockObserversTests: XCTestCase {

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
}
#endif
