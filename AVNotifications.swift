//
//  AVNotifications.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import AVFoundation

public typealias AudioSessionInterruptionObserver = NotificationObserver<AudioSessionInterruption>
public struct AudioSessionInterruption: ObservableNotification {
    public static let name = AVAudioSession.interruptionNotification

    public let interruptionType: AVAudioSession.InterruptionType
    public let interruptionOptions: AVAudioSession.InterruptionOptions

    public init?(_ n: Notification) {
        guard let userInfo = n.userInfo,
            let typeInt = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let interruptionType = AVAudioSession.InterruptionType(rawValue: typeInt)
            else {
                return nil
        }

        self.interruptionType = interruptionType
        let optionsInt = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt
        self.interruptionOptions = AVAudioSession.InterruptionOptions(rawValue: optionsInt ?? 0)
    }
}

public struct AudioSessionRouteChange: ObservableNotification {
    public static let name = AVAudioSession.routeChangeNotification

    public let reason: AVAudioSession.RouteChangeReason
    public let previousRoute: AVAudioSessionRouteDescription

    public init?(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue),
            let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
        else {
                return nil
        }

        self.reason = reason
        self.previousRoute = previousRoute
    }
}

public struct MediaServicesWereLost: DecodableNotification {
    public static let name = AVAudioSession.mediaServicesWereLostNotification
}

public struct MediaServicesWereReset: DecodableNotification {
    public static let name = AVAudioSession.mediaServicesWereResetNotification
}

public struct SilenceSecondaryAudioHint: ObservableNotification {
    public static let name = AVAudioSession.silenceSecondaryAudioHintNotification

    public let hint: AVAudioSession.SilenceSecondaryAudioHintType

    public init?(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
            let hint = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: typeValue) else {
                return nil
        }

        self.hint = hint
    }
}

public typealias PlayerItemPlaybackStalledObserver = NotificationObserver<PlayerItemPlaybackStalled>
public struct PlayerItemPlaybackStalled: ObservableNotification {
    public static let name = Notification.Name.AVPlayerItemPlaybackStalled

    public let playerItem: AVPlayerItem?

    public init(_ n: Notification) {
        playerItem = n.object as? AVPlayerItem
    }
}

public typealias PlayerItemFailedToPlayToEndTimeObserver = NotificationObserver<PlayerItemFailedToPlayToEndTime>
public struct PlayerItemFailedToPlayToEndTime: ObservableNotification {
    public static let name = Notification.Name.AVPlayerItemFailedToPlayToEndTime

    public let playerItem: AVPlayerItem
    public let error: NSError

    public init?(_ n: Notification) {
        guard let error = n.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? NSError,
            let item = n.object as? AVPlayerItem else {
            return nil
        }
        playerItem = item
        self.error = error
    }
}

public typealias PlayerItemDidPlayToEndTimeObserver = NotificationObserver<PlayerItemDidPlayToEndTime>
public struct PlayerItemDidPlayToEndTime: ObservableNotification {
    public static let name = NSNotification.Name.AVPlayerItemDidPlayToEndTime

    public let playerItem: AVPlayerItem

    public init?(_ n: Notification) {
        guard let playerItem = n.object as? AVPlayerItem else { return nil }
        self.playerItem = playerItem
    }
}

public typealias PlayerItemNewErrorLogEntryObserver = NotificationObserver<PlayerItemNewErrorLogEntry>
public struct PlayerItemNewErrorLogEntry: ObservableNotification {
    public static let name = NSNotification.Name.AVPlayerItemNewErrorLogEntry

    public let playerItem: AVPlayerItem

    public init?(_ n: Notification) {
        guard let playerItem = n.object as? AVPlayerItem else { return nil }
        self.playerItem = playerItem
    }
}

public typealias PlayerItemNewAccessLogEntryObserver = NotificationObserver<PlayerItemNewAccessLogEntry>
public struct PlayerItemNewAccessLogEntry: ObservableNotification {
    public static let name = NSNotification.Name.AVPlayerItemNewAccessLogEntry

    public let playerItem: AVPlayerItem

    public init?(_ n: Notification) {
        guard let playerItem = n.object as? AVPlayerItem else { return nil }
        self.playerItem = playerItem
    }
}
