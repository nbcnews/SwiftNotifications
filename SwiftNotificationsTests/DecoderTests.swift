//
//  DecoderTests.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import XCTest
@testable import SwiftNotifications

class EmptyDictionaryDecoderTests: XCTestCase {

    // should succeed decoding empty struct
    func testEmptyDecoder() {
        struct EmptyStruct: Decodable {}

        do {
            _ = try EmptyStruct(from: EmptyDictionaryDecoder())
        } catch {
            XCTFail("failed to decode EmptyStruct")
        }
    }

    func testGetters() {
        let decoder = EmptyDictionaryDecoder()
        XCTAssertEqual(decoder.codingPath.count, 0)
        XCTAssertEqual(decoder.userInfo.count, 0)
    }

    // should throw. Only empty structs/classes supported
    func testEmptyDecoderWithNonEmptyStruct() {
        struct NotEmptyStruct: Decodable {
            let val: Int = 0
        }

        do {
            _ = try NotEmptyStruct(from: EmptyDictionaryDecoder())
            XCTFail("EmptyDictionaryDecoder should throw")
        } catch {
            // Success
        }
    }

    // should throw. Decoding from arrays not supported
    func testEmptyDecoderWithArray() {
        do {
            _ = try [String](from: EmptyDictionaryDecoder())
            XCTFail("EmptyDictionaryDecoder should throw")
        } catch {
            // Success
        }
    }

    // should throw. Decoding from sigle value not supported
    func testEmptyDecoderWithSingleValue() {
        do {
            _ = try String(from: EmptyDictionaryDecoder())
            XCTFail("EmptyDictionaryDecoder should throw")
        } catch {
            // Success
        }
    }
}

class DictionaryDecoderTests: XCTestCase {

    func testGetters() {
        let decoder = DictionaryDecoder([:])
        XCTAssertEqual(decoder.codingPath.count, 0)
        XCTAssertNoThrow(decoder.userInfo)
    }

    // should throw. Decoding from arrays not supported
    func testDecoderWithArray() {
        do {
            _ = try [String](from: DictionaryDecoder([:]))
            XCTFail("DictionaryDecoder should throw")
        } catch {
            // Success
        }
    }

    // should throw. Decoding from sigle value not supported
    func testDecoderWithSingleValue() {
        do {
            _ = try String(from: DictionaryDecoder([:]))
            XCTFail("DictionaryDecoder should throw")
        } catch {
            // Success
        }
    }

    // test value supported by decoder
    func testDecoder() {
        struct Struct: Decodable {
            let zstring: String
            let bool: Bool
            let int: Int
            let float: Float
            let double: Double
            let int8: Int8
            let int16: Int16
            let int32: Int32
            let int64: Int64
            let uint: UInt
            let uint8: UInt8
            let uint16: UInt16
            let uint32: UInt32
            let uint64: UInt64
            let opt: String?
            let rect: CGRect
        }

        let dictionary: [String: Any] = [
            "zstring": "test",
            "bool": true,
            "int": 1,
            "float": Float(0.1),
            "double": 0.01,
            "int8": Int8(2),
            "int16": Int16(3),
            "int32": Int32(4),
            "int64": Int64(5),
            "uint": UInt(1000),
            "uint8": UInt8(7),
            "uint16": UInt16(8),
            "uint32": UInt32(9),
            "uint64": UInt64(10),
            "rect": CGRect.zero
        ]

        do {
            _ = try Struct(from: DictionaryDecoder(dictionary))
        } catch {
            XCTFail("failed decoding struct")
        }
    }
}

class DictionaryContainerTests: XCTestCase {
    enum Key: CodingKey {
        case foo
        case boo
        case bar
    }

    func testProperties() {
        let d = DictionaryContainer<Key>(["foo": 1, "bar": 2])
        XCTAssert(d.allKeys.count == 2)
        XCTAssert(d.allKeys.contains(.foo))
        XCTAssert(d.allKeys.contains(.bar))
        XCTAssert(d.codingPath.isEmpty)
    }

    func testContains() {
        let d = DictionaryContainer<Key>(["foo": true])
        XCTAssertTrue(d.contains(.foo))
        XCTAssertFalse(d.contains(.bar))
    }

    func testUnimplemented() {
        let d = DictionaryContainer<Key>([:])
        XCTAssertNil(try? d.nestedContainer(keyedBy: Key.self, forKey: .foo))
        XCTAssertNil(try? d.nestedUnkeyedContainer(forKey: .bar))
        XCTAssertNil(try? d.superDecoder())
        XCTAssertNil(try? d.superDecoder(forKey: .boo))
    }

    func testDecodeNil() {
        let d = DictionaryContainer<Key>(["foo": true])
        XCTAssertNotEqual(try? d.decodeNil(forKey: .foo), true)
    }

    func testDecodeBool() {
        decodeValueTest(val: true)
    }

    func testDecodeString() {
        decodeValueTest(val: "FooBar")
    }

    func testDecodeInt() {
        decodeValueTest(val: 3)
    }
    func testDecodeInt8() {
        decodeValueTest(val: Int8(3))
    }
    func testDecodeInt16() {
        decodeValueTest(val: Int16(3))
    }
    func testDecodeInt32() {
        decodeValueTest(val: Int32(3))
    }
    func testDecodeInt64() {
        decodeValueTest(val: Int64(3))
    }

    func testDecodeUInt() {
        decodeValueTest(val: UInt(3))
    }
    func testDecodeUInt8() {
        decodeValueTest(val: UInt8(3))
    }
    func testDecodeUInt16() {
        decodeValueTest(val: UInt16(3))
    }
    func testDecodeUInt32() {
        decodeValueTest(val: UInt32(3))
    }
    func testDecodeUInt64() {
        decodeValueTest(val: UInt64(3))
    }

    // helper to test various decode methods
    func decodeValueTest<T: Decodable & Equatable>(val: T) {
        let d = DictionaryContainer<Key>(["foo": val])
        XCTAssert((try? d.decode(T.self, forKey: .foo)) == val)
        // typeMismatch
        XCTAssertNil(try? d.decode(Other.self, forKey: .foo))
        // keyNotFound
        XCTAssertNil(try? d.decode(T.self, forKey: .bar))
    }
    struct Other: Decodable {}
}
