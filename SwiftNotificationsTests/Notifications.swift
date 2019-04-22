//
//  Notifications.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import SwiftNotifications

struct EmptyTestNotification: NotificationProtocol, PostableNotification, Equatable {
    init?(_ n: Notification) {}
    init() {}

    func post() {
        NotificationCenter.default.post(name: EmptyTestNotification.name, object: nil)
    }
}

struct EmptyCodableNotification: CodableNotification, PostableNotification, Equatable {
}

struct MockStruct: Codable, Equatable {
    let sval: String
    let fval: Float

    init(sval: String = "foobar", fval: Float = 100000000) {
        self.sval = sval
        self.fval = fval
    }
}

class MockClass: Codable, Equatable {
    let sval: String
    let fval: Float

    init() {
        sval = "Aha"
        fval = 3.0
    }

    static func == (lhs: MockClass, rhs: MockClass) -> Bool {
        return  lhs.sval == rhs.sval &&
            lhs.fval == rhs.fval
    }
}

// TestNotification implements notification with four stored properties,
// custom implemetation of constructor for NotificationObserver
// and custom post() implementation
struct TestNotification: NotificationProtocol, PostableNotification {
    let sval: String
    let ival: Int
    let uval: MockStruct
    let rval: MockClass

    init?(_ n: Notification) {
        guard let info = n.userInfo else {
            return nil
        }

        guard let sval = info["sval"] as? String,
            let ival = info["ival"] as? Int,
            let uval = info["uval"] as? MockStruct,
            let rval = info["rval"] as? MockClass
            else {
                return nil
        }

        self.sval = sval
        self.ival = ival
        self.uval = uval
        self.rval = rval
    }

    func post() {
        let info: [AnyHashable: Any] = [
            "sval": sval,
            "ival": ival,
            "uval": uval,
            "rval": rval
        ]

        NotificationCenter.default.post(name: TestNotification.name, object: nil, userInfo: info)
    }
}

extension TestNotification {
    init() {
        sval = "TestText"
        ival = 1
        uval = MockStruct()
        rval = MockClass()
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

// CodableTestNotification provides same functionality as TestNotification above
// but it does so without any additional code requirements
struct CodableTestNotification: CodableNotification, PostableNotification {
    let sval: String
    let ival: Int
    let uval: MockStruct
    let rval: MockClass
}

extension CodableTestNotification {
    init() {
        sval = "TestText"
        ival = 1
        uval = MockStruct()
        rval = MockClass()
    }
}

extension CodableTestNotification: Equatable {
    static func == (lhs: CodableTestNotification, rhs: CodableTestNotification) -> Bool {
        return  lhs.sval == rhs.sval &&
            lhs.ival == rhs.ival &&
            lhs.uval == rhs.uval &&
            lhs.rval == rhs.rval
    }
}
