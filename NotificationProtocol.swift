//
//  NotificationProtocol.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import Foundation

public protocol NotificationProtocol {
    static var name: Notification.Name { get }
    init?(_ n: Notification)
}

public typealias CodableNotification = Codable & NotificationProtocol

public extension NotificationProtocol {
    static var name: Notification.Name {
        return Notification.Name(rawValue: String(describing: self))
    }

    static func post(info: [AnyHashable: Any]) {
        NotificationCenter.default.post(name: Self.name, object: nil, userInfo: info)
    }

    static func post() {
        NotificationCenter.default.post(name: Self.name, object: nil, userInfo: nil)
    }
}

public extension NotificationProtocol where Self: Decodable {
    init?(_ n: Notification) {
        if let userInfo = n.userInfo as NSDictionary? {
            try? self.init(from: DictionaryDecoder(userInfo))
        } else {
            try? self.init(from: DictionaryDecoder([:]))
        }
    }
}

public extension NotificationProtocol where Self: Encodable {
    func post() {
        if MemoryLayout<Self>.size == 0 {
            NotificationCenter.default.post(name: Self.name, object: nil)
        } else {
            let encoder = DictionaryEncoder()
            try? self.encode(to: encoder)
            NotificationCenter.default.post(name: Self.name, object: nil, userInfo: encoder.dictionary.pointee)
        }
    }
}
