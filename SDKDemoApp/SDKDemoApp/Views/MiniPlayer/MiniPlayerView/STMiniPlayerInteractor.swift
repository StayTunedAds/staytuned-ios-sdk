//
//  MiniPlayerInteractor.swift
//  StayTunedSDK
//
//  Created by Kevin Morais on 27/08/2020.
//  Copyright © 2020 StayTuned. All rights reserved.
//

import UIKit
import StayTunedSDK

protocol MiniPlayerInteractorInput {
    func didTapPlay()
    func didTapPause()
    func didTapMiniPlayer()
}

final class MiniPlayerInteractor {

    private var player: STPlayer! = STPlayer.shared

    private let presenter: MiniPlayerPresenterInput

    init(presenter: MiniPlayerPresenterInput) {
        self.presenter = presenter
        self.player?.add(observer: self)
        self.updateWithCurrentState()
    }

    private func updateWithCurrentState() {
        self.presenter.setStyle()
        self.setCurrentMedia()
        self.setCurrentPlayerState()
        self.setCurrentPosition()
    }

    private func setCurrentMedia() {
        if let track = self.player.currentTrack,
           let content = self.player.currentContent {
            self.presenter.update(for: track, and: content)
        }
    }

    private func setCurrentPlayerState() {
        self.presenter.update(for: self.player.currentState)
    }

    private func setCurrentPosition() {
        if let time = self.player.currentTime,
           let duration = self.player.getAudioDuration() {
            self.presenter.update(for: time, and: duration)
        }
    }

}

extension MiniPlayerInteractor: MiniPlayerInteractorInput {

    func didTapPlay() {
        self.player.resume()
    }

    func didTapPause() {
        self.player.stop()
    }

    func didTapMiniPlayer() {
        self.presenter.displayExpand()
    }
}

extension MiniPlayerInteractor: STPlayerObserver {

    func playerCurrentTrackDidChange(to track: STTrack) {
        self.setCurrentMedia()
    }

    func playerCurrentContentDidChange(to content: STContent) {
        self.setCurrentMedia()
    }

    func playerCurrentTimeDidChange(to value: Double) {
        self.setCurrentPosition()
    }

    func playerStateDidChange(to state: STPlayerState) {
        self.setCurrentPlayerState()
    }
}
