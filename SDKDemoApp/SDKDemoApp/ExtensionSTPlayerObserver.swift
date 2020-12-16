//
//  ExtensionSTPlayerObserver.swift
//  SDKDemoApp
//
//  Created by Agylos on 15/12/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import Foundation
import StayTunedSDK

extension STPlayerObserver {
    func playerCurrentTrackDidChange(to track: STTrack) {}
    func playerCurrentTrackAudioQualityDidChange(to value: STAudioQuality) {}
    func playerCurrentContentDidChange(to content: STContent) {}
    func playerCurrentTimeDidChange(to value: Double) {}
    func playerWillSeek(from beginTime: Double?) {}
    func playerDidSeek(to endTime: Double) {}
    func playerStateDidChange(to value: STPlayerState) {}
    func playerRateDidChange(to value: Float) {}
    func playerTimerDidChange(to value: TimeInterval?) {}
    func playerTrackDidEnd(_ track: STTrack) {}
    func playerFailed(for track: STTrack) {}
}
