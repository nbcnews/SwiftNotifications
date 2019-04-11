//
//  Observers.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import Foundation

public class NotificationObserver<T: NotificationProtocol> {
    private var token: NSObjectProtocol? {
        willSet {
            remove()
        }
    }

    public init() {
    }

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

    public func observe<U: AnyObject>(_ object: U, _ method: @escaping (U) -> (T) -> Void, main: Bool = false) {
        observe(main: main) { [weak object] notification in
            guard let object = object else { return }
            method(object)(notification)
        }
    }

    public func observe<U: AnyObject>(_ object: U, _ method: @escaping (U) -> () -> Void, main: Bool = false) {
        observe(main: main) { [weak object] in
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

public protocol Observer: class {
    var tokens: [NSNotification.Name: NSObjectProtocol] { get set }
}

public extension Observer {
    func observe<T: NotificationProtocol>(main: Bool = false, _ c: @escaping (Self) -> (T) -> Void) {
        let queue = main ? OperationQueue.main : nil
        remove(c)
        let token = NotificationCenter.default.addObserver(forName: T.name, object: nil, queue: queue) { [weak self] n in
            guard let s = self, let t = T(n) else { return }
            c(s)(t)
        }

        tokens[T.name] = token
    }

    func observe(_ name: NSNotification.Name, main: Bool = false, _ c: @escaping (Self) -> () -> Void) {
        let queue = main ? OperationQueue.main : nil
        remove(name)
        let token = NotificationCenter.default.addObserver(forName: name, object: nil, queue: queue) { [weak self] _ in
            guard let s = self else { return }
            c(s)()
        }

        tokens[name] = token
    }

    func remove<T: NotificationProtocol>(_ c: @escaping (Self) -> (T) -> Void) {
        guard let token = tokens[T.name] else { return }
        NotificationCenter.default.removeObserver(token)
    }

    func remove(_ name: NSNotification.Name) {
        guard let token = tokens[name] else { return }
        NotificationCenter.default.removeObserver(token)
    }
}

open class ObserverBase: Observer {
    public var tokens = [NSNotification.Name: NSObjectProtocol]()

    public init() {}
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token.value)
        }
    }
}
