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
            let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue),
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
