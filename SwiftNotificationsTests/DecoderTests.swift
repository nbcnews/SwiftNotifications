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
            XCTFail()
        }
    }

    // make code covereage happy
    func testGetters() {
        let decoder = EmptyDictionaryDecoder()
        _ = decoder.codingPath
        _ = decoder.userInfo
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

    // make code covereage happy
    func testGetters() {
        let decoder = DictionaryDecoder([:])
        _ = decoder.codingPath
        _ = decoder.userInfo
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
            let string: String
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
            "string": "test",
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
            XCTFail()
        }
    }

    func testDictionaryContainer() {
        struct Struct: Decodable {
            let blah: String
        }
        //let d = DictionaryContainer<CodingKey>([:])

    }

}
