//
//  EncoderTests.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import XCTest
@testable import SwiftNotifications

class DictionaryEncoderTests: XCTestCase {

    func testGetters() {
        let encoder = DictionaryEncoder()
        XCTAssertEqual(encoder.codingPath.count, 0)
        XCTAssertNoThrow(encoder.userInfo)
    }
}

class DictionaryEncodingContainerTests: XCTestCase {
    enum Key: CodingKey {
        case foo
        case boo
        case bar
    }

    func testProperties() {
        let ref = DictionaryByRef([:])
        let d = DictionaryEncodingContainer<Key>(ref)
        XCTAssert(d.codingPath.isEmpty)
    }

    func testEncodeNil() {
        let ref = DictionaryByRef([:])
        let d = DictionaryEncodingContainer<Key>(ref)
        do {
            try d.encodeNil(forKey: .foo)
            XCTAssertNil(ref["foo"])
        } catch {
            XCTFail("encodeNil(forKey:) threw exception")
        }
    }
    
    func testEncodeBool() {
        encodeValueTest(val: true)
    }

    func testEncodeString() {
        encodeValueTest(val: "FooBar")
    }

    func testEncodeFloat() {
        encodeValueTest(val: Float(1.1))
    }
    func testEncodeDouble() {
        encodeValueTest(val: Double(1.111))
    }

    func testEncodeInt() {
        encodeValueTest(val: 3)
    }
    func testEncodeInt8() {
        encodeValueTest(val: Int8(3))
    }
    func testEncodeInt16() {
        encodeValueTest(val: Int16(3))
    }
    func testEncodeInt32() {
        encodeValueTest(val: Int32(3))
    }
    func testEncodeInt64() {
        encodeValueTest(val: Int64(3))
    }

    func testEncodeUInt() {
        encodeValueTest(val: UInt(3))
    }
    func testEncodeUInt8() {
        encodeValueTest(val: UInt8(3))
    }
    func testEncodeUInt16() {
        encodeValueTest(val: UInt16(3))
    }
    func testEncodeUInt32() {
        encodeValueTest(val: UInt32(3))
    }
    func testEncodeUInt64() {
        encodeValueTest(val: UInt64(3))
    }

    func testEncodeEncodable() {
        struct MyEncodable: Encodable, Equatable {}
        encodeValueTest(val: MyEncodable())
    }

    // helper to test various encode methods
    func encodeValueTest<T: Encodable & Equatable>(val: T) {
        let ref = DictionaryByRef([:])
        let d = DictionaryEncodingContainer<Key>(ref)
        do {
            // must use switch to call specific encode methods
            // instead of generic encode<T>
            switch val {
            case let val as Bool:
                try d.encode(val, forKey: .bar)
            case let val as String:
                try d.encode(val, forKey: .bar)
            case let val as Int:
                try d.encode(val, forKey: .bar)
            case let val as Int8:
                try d.encode(val, forKey: .bar)
            case let val as Int16:
                try d.encode(val, forKey: .bar)
            case let val as Int32:
                try d.encode(val, forKey: .bar)
            case let val as Int64:
                try d.encode(val, forKey: .bar)
            case let val as UInt:
                try d.encode(val, forKey: .bar)
            case let val as UInt8:
                try d.encode(val, forKey: .bar)
            case let val as UInt16:
                try d.encode(val, forKey: .bar)
            case let val as UInt32:
                try d.encode(val, forKey: .bar)
            case let val as UInt64:
                try d.encode(val, forKey: .bar)
            case let val as Float:
                try d.encode(val, forKey: .bar)
            case let val as Double:
                try d.encode(val, forKey: .bar)
            default:
                try d.encode(val, forKey: .bar)
            }

            if let stored = ref["bar"] as? T {
                XCTAssertEqual(stored, val)
            } else {
                XCTFail("type mismatch. expecting \(T.self)")
            }
        } catch {
            XCTFail("encode(value:forKey:) threw exception")
        }
    }
}

