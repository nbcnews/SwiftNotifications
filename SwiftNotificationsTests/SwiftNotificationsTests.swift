//
//  SwiftNotificationsTests.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import XCTest
import SwiftNotifications


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

struct MyStruct: Codable, Equatable {
    let sval: String
    let fval: Float
}

class MyClass: Codable, Equatable {
    let ptval: CGPoint
    let fval: Float

    init() {
        ptval = CGPoint.zero
        fval = 3.0
    }

    static func == (lhs: MyClass, rhs: MyClass) -> Bool {
        return  lhs.ptval == rhs.ptval &&
                lhs.fval == rhs.fval
    }
}

struct TestNotification: NotificationProtocol, PostableNotification {
    let sval: String
    let ival: Int
    let uval: MyStruct
    let rval: MyClass

    init?(_ n: Notification) {
        guard let info = n.userInfo else {
            return nil
        }

        guard let sval = info["sval"] as? String,
              let ival = info["ival"] as? Int,
              let uval = info["uval"] as? MyStruct,
              let rval = info["rval"] as? MyClass
        else {
            return nil
        }

        self.sval = sval
        self.ival = ival
        self.uval = uval
        self.rval = rval
    }

    init(sval: String, ival: Int, uval: MyStruct, rval: MyClass) {
        self.sval = sval
        self.ival = ival
        self.uval = uval
        self.rval = rval
    }

    func post() {
        let info: [String: Any] = [
            "sval": sval,
            "ival": ival,
            "uval": uval,
            "rval": rval
        ]

        NotificationCenter.default.post(Notification(name: TestNotification.name, object: nil, userInfo: info))
    }
}

extension TestNotification: Equatable {
    static func == (lhs: TestNotification, rhs: TestNotification) -> Bool {
        return  lhs.sval == rhs.sval &&
                lhs.ival == rhs.ival &&
                lhs.uval == rhs.uval &&
                lhs.rval == rhs.rval
    }
}

struct CodableTestNotification: CodableNotification, PostableNotification {
    let sval: String
    let ival: Int
    let uval: MyStruct
    let rval: MyClass
}

extension CodableTestNotification: Equatable {
    static func == (lhs: CodableTestNotification, rhs: CodableTestNotification) -> Bool {
        return  lhs.sval == rhs.sval &&
                lhs.ival == rhs.ival &&
                lhs.uval == rhs.uval &&
                lhs.rval == rhs.rval
    }
}


class MObserver<T: NotificationProtocol> {
    typealias callbackType = () -> ()
    private let observer = NotificationObserver<T>()
    private let callback: callbackType?
    var observed = false

    init(_ callback: callbackType? = nil) {
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
    typealias callbackType = () -> ()
    private let observer = NotificationObserver<T>()
    private let callback: callbackType?
    var observed = false

    init(_ callback: callbackType? = nil) {
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
        emptyObserverTest(CodableTestNotification(sval: "Test", ival: 1, uval: MyStruct(sval: "Foo", fval: 0.1), rval: MyClass()))
    }

    func testCodable2() {
        observerWithArgumentTest(CodableTestNotification(sval: "Test", ival: 1, uval: MyStruct(sval: "Foo", fval: 0.1), rval: MyClass()))
    }

    func testEmptyCodable() {
        emptyObserverTest(EmptyCodableNotification())
    }

    func testEmptyCodable2() {
        observerWithArgumentTest(EmptyCodableNotification())
    }

    func testMethodObserver() {
        let m = MObserver<TestNotification>()
        TestNotification(sval: "Test", ival: 1, uval: MyStruct(sval: "Foo", fval: 0.1), rval: MyClass()).post()

        XCTAssert(m.observed, "method observer not called")
    }

    func testRefCycleMethodObserver() {
        var released = false
        let block = { (cb: @escaping MObserver.callbackType) in
            // should be destroyed at the end of the block
            let _ = MObserver<TestNotification>(cb)
        }

        block {
            released = true
        }

        XCTAssert(released, "class must be released")
    }

    func testRefCycleClosueObserver() {
        struct Notification: CodableNotification {}
        var released = false
        let block = { (cb: @escaping CObserver.callbackType) in
            // should be destroyed at the end of the block
            let _ = CObserver<Notification>(cb)
        }

        block {
            released = true
        }

        // we expect a leak due to circular reference
        XCTAssert(!released, "class must be released")
    }

    // Performnce of sending codable notification
    func testPerformance2() {
        measure {
            for _ in 1...100000 {
                CodableTestNotification(sval: "Test", ival: 1, uval: MyStruct(sval: "Foo", fval: 0.1), rval: MyClass()).post()
            }
        }
    }

    // Performance of sending hand encoded notification
    func testPerformance3() {
        measure {
            for _ in 1...100000 {
                TestNotification(sval: "Test", ival: 1, uval: MyStruct(sval: "Foo", fval: 0.1), rval: MyClass()).post()
            }
        }
    }

    func testPerformance4() {
        measure {
            for _ in 1...100000 {
                EmptyCodableNotification().post()
            }
        }
    }

    func testPerformance5() {
        measure {
            for _ in 1...100000 {
                EmptyTestNotification().post()
            }
        }
    }

}
