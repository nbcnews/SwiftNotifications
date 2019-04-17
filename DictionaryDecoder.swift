//
//  DictionaryDecoder.swift
//  Copyright © 2018 NBC News Digital. All rights reserved.
//

typealias DictionaryType = [AnyHashable: Any]

struct DictionaryDecoder: Decoder {
    var codingPath: [CodingKey] {
        return []
    }
    var userInfo: [CodingUserInfoKey: Any] {
        return [:]
    }

    let dictionary: DictionaryType
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

private struct DictionaryContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey] {
        return []
    }
    var allKeys: [K] {
        return dictionary.keys.compactMap({ $0 as? String }).compactMap({ K(stringValue: $0) })
    }

    let dictionary: DictionaryType
    init(_ dictionary: DictionaryType) {
        self.dictionary = dictionary
    }

    func contains(_ key: K) -> Bool {
        return dictionary[key.stringValue] != nil
    }

    func decodeNil(forKey key: K) throws -> Bool {
        return dictionary[key.stringValue] == nil
    }

    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        guard let val = dictionary[key.stringValue] as? Bool else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: Int.Type, forKey key: K) throws -> Int {
        guard let val = dictionary[key.stringValue] as? Int else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
        guard let val = dictionary[key.stringValue] as? Int8 else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
        guard let val = dictionary[key.stringValue] as? Int16 else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
        guard let val = dictionary[key.stringValue] as? Int32 else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
        guard let val = dictionary[key.stringValue] as? Int64 else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
        guard let val = dictionary[key.stringValue] as? UInt else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
        guard let val = dictionary[key.stringValue] as? UInt8 else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
        guard let val = dictionary[key.stringValue] as? UInt16 else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
        guard let val = dictionary[key.stringValue] as? UInt32 else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
        guard let val = dictionary[key.stringValue] as? UInt64 else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: Float.Type, forKey key: K) throws -> Float {
        guard let val = dictionary[key.stringValue] as? Float else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: Double.Type, forKey key: K) throws -> Double {
        guard let val = dictionary[key.stringValue] as? Double else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode(_ type: String.Type, forKey key: K) throws -> String {
        guard let val = dictionary[key.stringValue] as? String else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: ""))
        }
        return val
    }

    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
        guard let val = dictionary[key.stringValue] as? T else {
            throw DecodingError.typeMismatch(type, .init(codingPath: [key], debugDescription: "Expecting dictionary"))
        }
        return val
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
