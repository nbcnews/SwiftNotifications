//
//  DictionaryDecoder.swift
//  Copyright © 2018 NBC News Digital. All rights reserved.
//

import Foundation

typealias DictionaryType = [AnyHashable: Any]

struct DictionaryDecoder: Decoder {
    var codingPath: [CodingKey] {
        return []
    }
    var userInfo: [CodingUserInfoKey: Any] {
        return [:]
    }

    private let dictionary: DictionaryType
    init(_ dictionary: DictionaryType) {
        self.dictionary = dictionary
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        return KeyedDecodingContainer(DictionaryContainer(dictionary))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "no arrays"))
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: ""))
    }
}

struct DictionaryContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
    private let dictionary: DictionaryType

    var codingPath: [CodingKey] {
        return []
    }

    var allKeys: [K] {
        return dictionary.keys
            .compactMap({ $0 as? String })
            .compactMap({ K(stringValue: $0) })
    }

    init(_ dictionary: DictionaryType) {
        self.dictionary = dictionary
    }

    func contains(_ key: K) -> Bool {
        return dictionary.keys.contains(key.stringValue)
    }

    func decodeNil(forKey key: K) throws -> Bool {
        return false
    }

    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        return try decode(forKey: key)
    }

    func decode(_ type: Int.Type, forKey key: K) throws -> Int {
        return try decode(forKey: key)
    }

    func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
        return try decode(forKey: key)
    }

    func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
        return try decode(forKey: key)
    }

    func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
        return try decode(forKey: key)
    }

    func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
        return try decode(forKey: key)
    }

    func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
        return try decode(forKey: key)
    }

    func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
        return try decode(forKey: key)
    }

    func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
        return try decode(forKey: key)
    }

    func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
        return try decode(forKey: key)
    }

    func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
        return try decode(forKey: key)
    }

    func decode(_ type: Float.Type, forKey key: K) throws -> Float {
        return try decode(forKey: key)
    }

    func decode(_ type: Double.Type, forKey key: K) throws -> Double {
        return try decode(forKey: key)
    }

    func decode(_ type: String.Type, forKey key: K) throws -> String {
        return try decode(forKey: key)
    }

    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
        return try decode(forKey: key)
    }

    private func decode<T>(forKey key: K) throws -> T where T: Decodable {
        guard let val = dictionary[key.stringValue] else {
            throw DecodingError.keyNotFound(key, .init(codingPath: [key], debugDescription: ""))
        }
        guard let tval = val as? T else {
            throw DecodingError.typeMismatch(T.self, .init(codingPath: [key], debugDescription: ""))
        }

        return tval
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        throw DecodingError.valueNotFound(type, .init(codingPath: [key], debugDescription: "nested containers not supported"))
    }

    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        throw DecodingError.valueNotFound(type(of: self), .init(codingPath: [key], debugDescription: "nested containers not supported"))
    }

    func superDecoder() throws -> Decoder {
        throw NSError()
    }

    func superDecoder(forKey key: K) throws -> Decoder {
        throw NSError()
    }

    typealias Key = K
}
