//
//  NotificationProtocol.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

public protocol NotificationProtocol {
    static var name: Notification.Name { get }
    init?(_ notification: Notification)
}

public typealias CodableNotification = Codable & NotificationProtocol

public extension NotificationProtocol {
    static var name: Notification.Name {
        return Notification.Name(rawValue: String(describing: self))
    }

    static func post() {
        NotificationCenter.default.post(name: Self.name, object: nil, userInfo: nil)
    }

    static func post(to notificationCenter: NotificationCenter = NotificationCenter.default,
                     object: AnyObject? = nil,
                     info: [AnyHashable: Any]? = nil) {
        notificationCenter.post(name: Self.name, object: object, userInfo: info)
    }
}

public extension NotificationProtocol where Self: Decodable {
    init?(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            try? self.init(from: DictionaryDecoder(userInfo))
        } else {
            try? self.init(from: EmptyDictionaryDecoder())
        }
    }
}

public extension NotificationProtocol where Self: Encodable {
    func post() {
        if MemoryLayout<Self>.size == 0 {
            Self.post()
        } else {
            let encoder = DictionaryEncoder()
            try? self.encode(to: encoder)
            Self.post(info: encoder.dictionary.pointee)
        }
    }
}
