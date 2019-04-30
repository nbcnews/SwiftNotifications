//
//  AVNotifications.swift
//  Copyright © 2019 NBC News Digital. All rights reserved.
//

import AVFoundation

typealias AudioSessionInterruptionObserver = NotificationObserver<AudioSessionInterruption>
struct AudioSessionInterruption: ObservableNotification {
    static let name = AVAudioSession.interruptionNotification

    let interruptionType: AVAudioSession.InterruptionType
    let interruptionOptions: AVAudioSession.InterruptionOptions

    init?(_ n: Notification) {
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

struct AudioSessionRouteChange: ObservableNotification {
    static let name = AVAudioSession.routeChangeNotification

    let reason: AVAudioSession.RouteChangeReason
    let previousRoute: AVAudioSessionRouteDescription

    init?(_ notification: Notification) {
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

struct MediaServicesWereLost: DecodableNotification {
    static let name = AVAudioSession.mediaServicesWereLostNotification
}

struct MediaServicesWereReset: DecodableNotification {
    static let name = AVAudioSession.mediaServicesWereResetNotification
}

struct SilenceSecondaryAudioHint: ObservableNotification {
    static let name = AVAudioSession.silenceSecondaryAudioHintNotification

    let hint: AVAudioSession.SilenceSecondaryAudioHintType

    init?(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
            let hint = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: typeValue) else {
                return nil
        }

        self.hint = hint
    }
}

typealias PlayerItemPlaybackStalledObserver = NotificationObserver<PlayerItemPlaybackStalled>
struct PlayerItemPlaybackStalled: ObservableNotification {
    static let name = Notification.Name.AVPlayerItemPlaybackStalled

    let playerItem: AVPlayerItem?

    init(_ n: Notification) {
        playerItem = n.object as? AVPlayerItem
    }
}

typealias PlayerItemFailedToPlayToEndTimeObserver = NotificationObserver<PlayerItemFailedToPlayToEndTime>
struct PlayerItemFailedToPlayToEndTime: ObservableNotification {
    static let name = Notification.Name.AVPlayerItemFailedToPlayToEndTime

    let playerItem: AVPlayerItem
    let error: NSError

    init?(_ n: Notification) {
        guard let error = n.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? NSError,
            let item = n.object as? AVPlayerItem else {
            return nil
        }
        playerItem = item
        self.error = error
    }
}

typealias PlayerItemDidPlayToEndTimeObserver = NotificationObserver<PlayerItemDidPlayToEndTime>
struct PlayerItemDidPlayToEndTime: ObservableNotification {
    static let name = NSNotification.Name.AVPlayerItemDidPlayToEndTime

    let playerItem: AVPlayerItem

    init?(_ n: Notification) {
        guard let playerItem = n.object as? AVPlayerItem else { return nil }
        self.playerItem = playerItem
    }
}

typealias PlayerItemNewErrorLogEntryObserver = NotificationObserver<PlayerItemNewErrorLogEntry>
struct PlayerItemNewErrorLogEntry: ObservableNotification {
    static let name = NSNotification.Name.AVPlayerItemNewErrorLogEntry

    let playerItem: AVPlayerItem

    init?(_ n: Notification) {
        guard let playerItem = n.object as? AVPlayerItem else { return nil }
        self.playerItem = playerItem
    }
}

typealias PlayerItemNewAccessLogEntryObserver = NotificationObserver<PlayerItemNewAccessLogEntry>
struct PlayerItemNewAccessLogEntry: ObservableNotification {
    static let name = NSNotification.Name.AVPlayerItemNewAccessLogEntry

    let playerItem: AVPlayerItem

    init?(_ n: Notification) {
        guard let playerItem = n.object as? AVPlayerItem else { return nil }
        self.playerItem = playerItem
    }
}
