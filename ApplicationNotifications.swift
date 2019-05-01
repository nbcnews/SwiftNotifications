//
//  ApplicationNotifications.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import UIKit

// swiftlint:disable type_name

public typealias ApplicationWillEnterForegroundObserver = NotificationObserver<ApplicationWillEnterForeground>
public struct ApplicationWillEnterForeground: CodableNotification {
    public static let name = UIApplication.willEnterForegroundNotification
}

public typealias ApplicationDidEnterBackgroundObserver = NotificationObserver<ApplicationDidEnterBackground>
public struct ApplicationDidEnterBackground: CodableNotification {
    public static let name = UIApplication.didEnterBackgroundNotification
}

public typealias ApplicationDidFinishLaunchingObserver = NotificationObserver<ApplicationDidFinishLaunching>
public struct ApplicationDidFinishLaunching: CodableNotification {
    public static let name = UIApplication.didFinishLaunchingNotification
}

public typealias ApplicationDidBecomeActiveObserver = NotificationObserver<ApplicationDidBecomeActive>
public struct ApplicationDidBecomeActive: CodableNotification {
    public static let name = UIApplication.didBecomeActiveNotification
}

public typealias ApplicationWillResignActiveObserver = NotificationObserver<ApplicationWillResignActive>
public struct ApplicationWillResignActive: CodableNotification {
    public static let name = UIApplication.willResignActiveNotification
}

public typealias ApplicationDidReceiveMemoryWarningObserver = NotificationObserver<ApplicationDidReceiveMemoryWarning>
public struct ApplicationDidReceiveMemoryWarning: CodableNotification {
    public static let name = UIApplication.didReceiveMemoryWarningNotification
}

public typealias ApplicationWillTerminateObserver = NotificationObserver<ApplicationWillTerminate>
public struct ApplicationWillTerminate: CodableNotification {
    public static let name = UIApplication.willTerminateNotification
}

public typealias ApplicationSignificantTimeChangeObserver = NotificationObserver<ApplicationSignificantTimeChange>
public struct ApplicationSignificantTimeChange: CodableNotification {
    public static let name = UIApplication.significantTimeChangeNotification
}

public typealias ApplicationBackgroundRefreshStatusDidChangeObserver = NotificationObserver<ApplicationBackgroundRefreshStatusDidChange>
public struct ApplicationBackgroundRefreshStatusDidChange: CodableNotification {
    public static let name = UIApplication.backgroundRefreshStatusDidChangeNotification
}

public typealias ApplicationProtectedDataWillBecomeUnavailableObserver = NotificationObserver<ApplicationProtectedDataWillBecomeUnavailable>
public struct ApplicationProtectedDataWillBecomeUnavailable: CodableNotification {
    public static let name = UIApplication.protectedDataWillBecomeUnavailableNotification
}

public typealias ApplicationProtectedDataDidBecomeAvailableObserver = NotificationObserver<ApplicationProtectedDataDidBecomeAvailable>
public struct ApplicationProtectedDataDidBecomeAvailable: CodableNotification {
    public static let name = UIApplication.protectedDataDidBecomeAvailableNotification
}

#if os(iOS)

public typealias ApplicationWillChangeStatusBarOrientationObserver = NotificationObserver<ApplicationWillChangeStatusBarOrientation>
public struct ApplicationWillChangeStatusBarOrientation: ObservableNotification {
    public static let name = UIApplication.willChangeStatusBarOrientationNotification

    public let orientation: UIInterfaceOrientation

    public init?(_ notification: Notification) {
        guard let info = notification.userInfo,
            let orientation = info[UIApplication.statusBarOrientationUserInfoKey] as? UIInterfaceOrientation
        else {
            return nil
        }

        self.orientation = orientation
    }
}

public typealias ApplicationDidChangeStatusBarOrientationObserver = NotificationObserver<ApplicationDidChangeStatusBarOrientation>
public struct ApplicationDidChangeStatusBarOrientation: ObservableNotification {
    public static let name = UIApplication.didChangeStatusBarOrientationNotification

    public let orientation: UIInterfaceOrientation

    public init?(_ notification: Notification) {
        guard let info = notification.userInfo,
            let orientation = info[UIApplication.statusBarOrientationUserInfoKey] as? UIInterfaceOrientation
            else {
                return nil
        }

        self.orientation = orientation
    }
}

public typealias ApplicationWillChangeStatusBarFrameObserver = NotificationObserver<ApplicationWillChangeStatusBarFrame>
public struct ApplicationWillChangeStatusBarFrame: ObservableNotification {
    public static let name = UIApplication.willChangeStatusBarFrameNotification

    public let frame: CGRect

    public init?(_ notification: Notification) {
        guard let info = notification.userInfo,
            let frame = info[UIApplication.statusBarFrameUserInfoKey] as? CGRect
            else {
                return nil
        }

        self.frame = frame
    }
}

public typealias ApplicationDidChangeStatusBarFrameObserver = NotificationObserver<ApplicationDidChangeStatusBarFrame>
public struct ApplicationDidChangeStatusBarFrame: ObservableNotification {
    public static let name = UIApplication.didChangeStatusBarFrameNotification

    public let frame: CGRect

    public init?(_ notification: Notification) {
        guard let info = notification.userInfo,
            let frame = info[UIApplication.statusBarFrameUserInfoKey] as? CGRect
            else {
                return nil
        }

        self.frame = frame
    }
}

#endif
