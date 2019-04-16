//
//  DictionaryEncoder.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

class MutableReference<T> {
    var pointee: T

    init(_ pointee: T) {
        self.pointee = pointee
    }
}

typealias DictionaryByRef = MutableReference<[AnyHashable: Any]>

extension DictionaryByRef {
    subscript(index: String) -> Any? {
        get {
            return pointee[index]
        }
        set {
            pointee[index] = newValue
        }
    }
}

struct DictionaryEncoder: Encoder {
    var dictionary = DictionaryByRef([:])

    var codingPath: [CodingKey] {
        return []
    }

    var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        return KeyedEncodingContainer(DictionaryEncodingContainer(dictionary))
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("DictionaryEncoder doesn't support arrays")
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        fatalError("DictionaryEncoder doesn't support single values")
    }
}

private struct DictionaryEncodingContainer<K: CodingKey>: KeyedEncodingContainerProtocol {
    var codingPath: [CodingKey] = []

    var dictionary: DictionaryByRef
    init(_ dictionary: DictionaryByRef) {
        self.dictionary = dictionary
    }

    func encodeNil(forKey key: K) throws {
        dictionary[key.stringValue] = nil
    }

    func encode(_ value: Bool, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: String, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: Double, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: Float, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: Int, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: Int8, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: Int16, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: Int32, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: Int64, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: UInt, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: UInt8, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: UInt16, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: UInt32, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode(_ value: UInt64, forKey key: K) throws {
        dictionary[key.stringValue] = value
    }

    func encode<T>(_ value: T, forKey key: K) throws where T: Encodable {
        dictionary[key.stringValue] = value
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: K) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError("DictionaryEncoder doesn't support nestedContainer(keyedBy:forKey:)")
    }

    func nestedUnkeyedContainer(forKey key: K) -> UnkeyedEncodingContainer {
        fatalError("DictionaryEncoder doesn't support nestedUnkeyedContainer(forKey:)")
    }

    func superEncoder() -> Encoder {
        fatalError("DictionaryEncoder doesn't have superEncoder")
    }

    func superEncoder(forKey key: K) -> Encoder {
        fatalError("DictionaryEncoder doesn't have superEncoder(forKey:)")
    }

    typealias Key = K
}
