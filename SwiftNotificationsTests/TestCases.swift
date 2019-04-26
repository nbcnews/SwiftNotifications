//
//  TestCases.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

@testable import SwiftNotifications

// ObserverTestCase helps with setup of test cases for various scenarios.
// Callback passed to init() gets called from deinit to verify that
// ObserverTestCase class was actually released
class ObserverTestCase {
    typealias CallbackType = () -> Void
    private let callback: CallbackType?
    var observed = false

    required init(_ callback: CallbackType? = nil) {
        self.callback = callback
    }

    deinit {
        callback?()
    }
}

// Test case for method observer.
class MethodObserver<T: ObservableNotification>: ObserverTestCase {
    private let observer = NotificationObserver<T>()

    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        observer.observe(self, MethodObserver.observerMethod)
    }

    func observerMethod(notification: T) {
        observed = true
    }
}

// Test case for method without parameters observer
class MethodWithoutParametersObserver<T: ObservableNotification>: ObserverTestCase {
    private let observer = NotificationObserver<T>()

    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        observer.observe(self, MethodWithoutParametersObserver.observerMethod)
    }

    func observerMethod() {
        observed = true
    }
}

#if BLOCK_OBSERVERS
// LeakyClosureObserver demonstrates memory leak produced by reference
// cycle due to `self` capture by closure
class LeakyClosureObserver<T: ObservableNotification>: ObserverTestCase {
    private let observer = NotificationObserver<T>()

    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        // without [weak self] closure creates reference cycle
        observer.observe {
            self.observed = true
        }
    }
}

// LeakyMethodObserver demonstrates memory leak produced by reference
// cycle due to passing method reference to wrong observe call
class LeakyMethodObserver<T: ObservableNotification>: ObserverTestCase {
    private let observer = NotificationObserver<T>()

    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        // strong reference to self is implicitly created.
        // observerMethod == observerMethod(self)
        observer.observe(using: observerMethod)
    }

    func observerMethod(notification: T) {
        observed = true
    }
}
#endif

// Observing pattern with Observers container
class MultiObserver: ObserverTestCase {
    //swiftlint:disable:next type_name
    private typealias Me = MultiObserver

    private lazy var observers = Observers(self)

    var observedTest = false
    var observedEmpty = false
    var observedCodable = false

    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        observers
            .observe(Me.on(test:))
            .observe(Me.on(empty:))
            .observe(Me.on(codable:))
    }

    private func on(test: TestNotification) {
        observedTest = true
    }

    private func on(empty: EmptyTestNotification) {
        observedEmpty = true
    }

    private func on(codable: CodableTestNotification) {
        observedCodable = true
    }

    deinit {
        observers.remove(Me.on(test:))
        observers.remove(TestNotification.name)
    }
}

// Test case for custom notification center observer.
class CustomNotificationCenterObserver<T: ObservableNotification>: ObserverTestCase {
    private let observer = NotificationObserver<T>()
    let notificationCenter = NotificationCenter()

    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        observer.observe(
            notificationCenter: notificationCenter,
            self, CustomNotificationCenterObserver.observerMethod)
    }

    func observerMethod(notification: T) {
        observed = true
    }
}

// Test case for custom notification center observer.
class ObjectObserver<T: ObservableNotification>: ObserverTestCase {
    private let observer = NotificationObserver<T>()

    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        observer.observe(from: self,
            self, ObjectObserver.observerMethod)
    }

    func observerMethod(notification: T) {
        observed = true
    }
}

// Test of #selector based observer. Unrelated to SwiftNotifications.
// Just wanted to verify that #selector observer doesn't create ref cycle.
class SelectorObserver: ObserverTestCase {
    required init(_ callback: CallbackType? = nil) {
        super.init(callback)

        NotificationCenter.default.addObserver(self, selector: #selector(observe), name: Notification.Name("Poontik"), object: nil)
    }

    @objc
    func observe(notification: Notification) {
        observed = true
    }
}
