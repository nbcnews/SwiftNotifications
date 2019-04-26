//
//  NotificationProtocols.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

public protocol ObservableNotification {
    static var name: Notification.Name { get }
    init?(_ notification: Notification)
}

public extension ObservableNotification {
    static var name: Notification.Name {
        return Notification.Name(rawValue: String(reflecting: self))
    }
}

public protocol PostableNotification: ObservableNotification {
    var userInfo: [AnyHashable: Any]? { get }
    func post(_ notificationCenter: NotificationCenter, from sender: Any?)
}

public extension PostableNotification {
    func post(_ notificationCenter: NotificationCenter = NotificationCenter.default,
              from sender: Any? = nil) {
        notificationCenter.post(name: Self.name, object: sender, userInfo: userInfo)
    }
}

public typealias CodableNotification = Codable & PostableNotification
public typealias DecodableNotification = Decodable & ObservableNotification

public extension ObservableNotification where Self: Decodable {
    init?(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            try? self.init(from: DictionaryDecoder(userInfo))
        } else {
            try? self.init(from: EmptyDictionaryDecoder())
        }
    }
}

public extension PostableNotification where Self: Encodable {
    var userInfo: [AnyHashable: Any]? {
        if MemoryLayout<Self>.size == 0 {
            return nil
        }

        let encoder = DictionaryEncoder()
        try? self.encode(to: encoder)
        return encoder.dictionary.pointee
    }
}
