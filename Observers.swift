//
//  Observers.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

public class NotificationObserver<T: NotificationProtocol> {
    private var token: NSObjectProtocol? {
        willSet {
            remove()
        }
    }

    public init() {
    }

    #if BLOCK_OBSERVERS
    public func observe(main: Bool = false, using block: @escaping (T) -> Void) {
        let queue = main ? OperationQueue.main : nil
        token = NotificationCenter.default.addObserver(forName: T.name, object: nil, queue: queue) { n in
            guard let t = T(n) else { return }
            block(t)
        }
    }

    public func observe(main: Bool = false, using block: @escaping () -> Void) {
        let queue = main ? OperationQueue.main : nil
        token = NotificationCenter.default.addObserver(forName: T.name, object: nil, queue: queue) { _ in
            block()
        }
    }
    #endif

    public func observe<U: AnyObject>(_ object: U, _ method: @escaping (U) -> (T) -> Void, queue: OperationQueue? = nil) {
        token = NotificationCenter.default.addObserver(forName: T.name, object: nil, queue: queue) { [weak object] notification in
            guard let object = object, let t = T(notification) else { return }
            method(object)(t)
        }
    }

    public func observe<U: AnyObject>(_ object: U, _ method: @escaping (U) -> () -> Void, queue: OperationQueue? = nil) {
        token = NotificationCenter.default.addObserver(forName: T.name, object: nil, queue: queue) { [weak object] notification in
            guard let object = object else { return }
            method(object)()
        }
    }

    public func remove() {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
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

    init(_ object: U, notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.object = object
        self.notificationCenter = notificationCenter
    }

    @discardableResult
    func observe<T: NotificationProtocol>(queue: OperationQueue? = nil, _ method: @escaping (U) -> (T) -> Void) -> Self {
        remove(method)

        let token = notificationCenter.addObserver(forName: T.name, object: nil, queue: queue) { [weak self] notification in
            guard let object = self?.object, let t = T(notification) else { return }
            method(object)(t)
        }

        tokens[T.name] = token
        return self
    }

    func remove<T: NotificationProtocol>(_ c: @escaping (U) -> (T) -> Void) {
        guard let token = tokens[T.name] else { return }
        notificationCenter.removeObserver(token)
    }

    func remove(_ name: NSNotification.Name) {
        guard let token = tokens[name] else { return }
        notificationCenter.removeObserver(token)
    }

    deinit {
        for token in tokens {
            notificationCenter.removeObserver(token.value)
        }
    }
}
