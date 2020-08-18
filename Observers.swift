//
//  Observers.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import Foundation

public class NotificationObserver<T: ObservableNotification> {
    private var token: NSObjectProtocol? {
        willSet {
            remove()
        }
    }

    private var notificationCenter: NotificationCenter

    public init(_ notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.notificationCenter = notificationCenter
    }

    #if BLOCK_OBSERVERS
    public func observe(main: Bool = false, using block: @escaping (T) -> Void) {
        let queue = main ? OperationQueue.main : nil
        token = notificationCenter.addObserver(forName: T.name, object: nil, queue: queue) { n in
            guard let t = T(n) else { return }
            block(t)
        }
    }

    public func observe(main: Bool = false, using block: @escaping () -> Void) {
        let queue = main ? OperationQueue.main : nil
        token = notificationCenter.addObserver(forName: T.name, object: nil, queue: queue) { _ in
            block()
        }
    }
    #endif

    public func observe<U: AnyObject>(
        from source: Any? = nil,
        queue: OperationQueue? = nil,
        _ object: U, _ method: @escaping (U) -> (T) -> Void) {
        token = notificationCenter.addObserver(forName: T.name, object: source, queue: queue) { [weak object] notification in
            guard let object = object, let t = T(notification) else { return }
            method(object)(t)
        }
    }

    public func observe<U: AnyObject>(
        from source: Any? = nil,
        queue: OperationQueue? = nil,
        _ object: U, _ method: @escaping (U) -> () -> Void) {
        token = notificationCenter.addObserver(forName: T.name, object: nil, queue: queue) { [weak object] _ in
            guard let object = object else { return }
            method(object)()
        }
    }

    public func remove() {
        if let token = token {
            notificationCenter.removeObserver(token)
        }
    }

    deinit {
        remove()
    }
}

public class Observers<U: AnyObject> {
    private var tokens = [NSNotification.Name: NSObjectProtocol]()
    private weak var object: U?
    private let notificationCenter: NotificationCenter

    public init(_ object: U, notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.object = object
        self.notificationCenter = notificationCenter
    }

    @discardableResult
    public func observe<T: ObservableNotification>(
        from source: Any? = nil,
        queue: OperationQueue? = nil,
        _ method: @escaping (U) -> (T) -> Void) -> Self {
        remove(method)

        let token = notificationCenter.addObserver(forName: T.name, object: nil, queue: queue) { [weak self] notification in
            guard let object = self?.object, let t = T(notification) else { return }
            method(object)(t)
        }

        tokens[T.name] = token
        return self
    }

    public func remove<T: ObservableNotification>(_ c: @escaping (U) -> (T) -> Void) {
        remove(T.name)
    }

    public func remove(_ name: NSNotification.Name) {
        if let token = tokens.removeValue(forKey: name) {
            notificationCenter.removeObserver(token)
        }
    }

    deinit {
        for token in tokens.values {
            notificationCenter.removeObserver(token)
        }
    }
}
