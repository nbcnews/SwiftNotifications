//
//  PerformanceTests.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import XCTest
@testable import SwiftNotifications

class PerformanceTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    // Test performnce of sending notification with compiler generated post
    func testPostCodable() {
        measure {
            for _ in 1...100000 {
                CodableTestNotification().post()
            }
        }
    }

    // Test performance of sending notification with hand writen post
    func testPostManual() {
        measure {
            for _ in 1...100000 {
                TestNotification().post()
            }
        }
    }

    // Test performnce of sending empty notification with compiler generated post
    func testPostEmptyCodable() {
        measure {
            for _ in 1...100000 {
                EmptyCodableNotification().post()
            }
        }
    }

    // Test performance of sending empty notification with hand writen post
    func testPostEmptyManual() {
        measure {
            for _ in 1...100000 {
                EmptyTestNotification().post()
            }
        }
    }

    // Test decoding prformance of CodableNotification's init(Notification)
    func testDecodingCodable() {
        let info: [String: Any] = [
            "sval": "Test",
            "ival": 1,
            "uval": MockStruct(sval: "Foo", fval: 0.1),
            "rval": MockClass()
        ]

        let notification = Notification(name: CodableTestNotification.name, object: nil, userInfo: info)

        measure {
            for _ in 1...100000 {
                _ = CodableTestNotification(notification)
            }
        }
    }

    // Test decoding prformance of hand implemented init(Notification)
    func testDecodingManual() {
        let info: [String: Any] = [
            "sval": "Test",
            "ival": 1,
            "uval": MockStruct(sval: "Foo", fval: 0.1),
            "rval": MockClass()
        ]

        let notification = Notification(name: TestNotification.name, object: nil, userInfo: info)

        measure {
            for _ in 1...100000 {
                _ = TestNotification(notification)
            }
        }
    }

    // Test decoding prformance of empty CodableNotification's init(Notification)
    func testDecodingEmptyCodable() {
        let notification = Notification(name: EmptyCodableNotification.name, object: nil, userInfo: nil)

        measure {
            for _ in 1...100000 {
                _ = EmptyCodableNotification(notification)
            }
        }
    }

    // Test decoding prformance of empty init(Notification)
    func testDecodingEmptyManual() {
        let notification = Notification(name: EmptyCodableNotification.name, object: nil, userInfo: nil)

        measure {
            for _ in 1...100000 {
                _ = EmptyTestNotification(notification)
            }
        }
    }
}
