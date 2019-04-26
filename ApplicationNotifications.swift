//
//  ApplicationNotifications.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import UIKit

// swiftlint:disable type_name

typealias ApplicationWillEnterForegroundObserver = NotificationObserver<ApplicationWillEnterForeground>
struct ApplicationWillEnterForeground: CodableNotification {
    static let name = UIApplication.willEnterForegroundNotification
}

typealias ApplicationDidEnterBackgroundObserver = NotificationObserver<ApplicationDidEnterBackground>
struct ApplicationDidEnterBackground: CodableNotification {
    static let name = UIApplication.didEnterBackgroundNotification
}

typealias ApplicationDidFinishLaunchingObserver = NotificationObserver<ApplicationDidFinishLaunching>
struct ApplicationDidFinishLaunching: CodableNotification {
    static let name = UIApplication.didFinishLaunchingNotification
}

typealias ApplicationDidBecomeActiveObserver = NotificationObserver<ApplicationDidBecomeActive>
struct ApplicationDidBecomeActive: CodableNotification {
    static let name = UIApplication.didBecomeActiveNotification
}

typealias ApplicationWillResignActiveObserver = NotificationObserver<ApplicationWillResignActive>
struct ApplicationWillResignActive: CodableNotification {
    static let name = UIApplication.willResignActiveNotification
}

typealias ApplicationDidReceiveMemoryWarningObserver = NotificationObserver<ApplicationDidReceiveMemoryWarning>
struct ApplicationDidReceiveMemoryWarning: CodableNotification {
    static let name = UIApplication.didReceiveMemoryWarningNotification
}

typealias ApplicationWillTerminateObserver = NotificationObserver<ApplicationWillTerminate>
struct ApplicationWillTerminate: CodableNotification {
    static let name = UIApplication.willTerminateNotification
}

typealias ApplicationSignificantTimeChangeObserver = NotificationObserver<ApplicationSignificantTimeChange>
struct ApplicationSignificantTimeChange: CodableNotification {
    static let name = UIApplication.significantTimeChangeNotification
}

typealias ApplicationBackgroundRefreshStatusDidChangeObserver = NotificationObserver<ApplicationBackgroundRefreshStatusDidChange>
struct ApplicationBackgroundRefreshStatusDidChange: CodableNotification {
    static let name = UIApplication.backgroundRefreshStatusDidChangeNotification
}

typealias ApplicationProtectedDataWillBecomeUnavailableObserver = NotificationObserver<ApplicationProtectedDataWillBecomeUnavailable>
struct ApplicationProtectedDataWillBecomeUnavailable: CodableNotification {
    static let name = UIApplication.protectedDataWillBecomeUnavailableNotification
}

typealias ApplicationProtectedDataDidBecomeAvailableObserver = NotificationObserver<ApplicationProtectedDataDidBecomeAvailable>
struct ApplicationProtectedDataDidBecomeAvailable: CodableNotification {
    static let name = UIApplication.protectedDataDidBecomeAvailableNotification
}

#if os(iOS)

typealias ApplicationWillChangeStatusBarOrientationObserver = NotificationObserver<ApplicationWillChangeStatusBarOrientation>
struct ApplicationWillChangeStatusBarOrientation: ObservableNotification {
    static let name = UIApplication.willChangeStatusBarOrientationNotification

    let orientation: UIInterfaceOrientation

    init?(_ notification: Notification) {
        guard let info = notification.userInfo,
            let orientation = info[UIApplication.statusBarOrientationUserInfoKey] as? UIInterfaceOrientation
        else {
            return nil
        }

        self.orientation = orientation
    }
}

typealias ApplicationDidChangeStatusBarOrientationObserver = NotificationObserver<ApplicationDidChangeStatusBarOrientation>
struct ApplicationDidChangeStatusBarOrientation: ObservableNotification {
    static let name = UIApplication.didChangeStatusBarOrientationNotification

    let orientation: UIInterfaceOrientation

    init?(_ notification: Notification) {
        guard let info = notification.userInfo,
            let orientation = info[UIApplication.statusBarOrientationUserInfoKey] as? UIInterfaceOrientation
            else {
                return nil
        }

        self.orientation = orientation
    }
}

typealias ApplicationWillChangeStatusBarFrameObserver = NotificationObserver<ApplicationWillChangeStatusBarFrame>
struct ApplicationWillChangeStatusBarFrame: ObservableNotification {
    static let name = UIApplication.willChangeStatusBarFrameNotification

    let frame: CGRect

    init?(_ notification: Notification) {
        guard let info = notification.userInfo,
            let frame = info[UIApplication.statusBarFrameUserInfoKey] as? CGRect
            else {
                return nil
        }

        self.frame = frame
    }
}

typealias ApplicationDidChangeStatusBarFrameObserver = NotificationObserver<ApplicationDidChangeStatusBarFrame>
struct ApplicationDidChangeStatusBarFrame: ObservableNotification {
    static let name = UIApplication.didChangeStatusBarFrameNotification

    let frame: CGRect

    init?(_ notification: Notification) {
        guard let info = notification.userInfo,
            let frame = info[UIApplication.statusBarFrameUserInfoKey] as? CGRect
            else {
                return nil
        }

        self.frame = frame
    }
}

#endif
