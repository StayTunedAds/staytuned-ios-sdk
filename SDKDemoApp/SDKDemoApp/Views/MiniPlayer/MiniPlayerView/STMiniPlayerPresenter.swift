//
//  MiniPlayerInteractor.swift
//  StayTuned
//
//  Created by Agylos on 15/08/2019.
//  Copyright © 2019 StayTuned. All rights reserved.
//

import UIKit
import StayTunedSDK

protocol MiniPlayerPresenterInput {
    func setStyle()
    func update(for track: STTrack, and content: STContent)
    func update(for state: STPlayerState)
    func update(for time: Double, and duration: Double?)
    func displayExpand()
}

final class MiniPlayerPresenter {
    
    private weak var view: MiniPlayerInput?
    
    init(view: MiniPlayerInput) {
        self.view = view
    }
    
    private func styleModel() -> MiniPlayerModel.Style {
        return .init(
            backgroundColor: UIColor(named: "MiniplayerBackground")?.withAlphaComponent(0.25),
            progressTintColor: UIColor(named: "Brand"),
            trackTintColor: UIColor(named: "Decoration"),
            playButtonImage: UIImage(named: "PlayButton"),
            pauseButtonImage: UIImage(named: "PauseButton"),
            titleFont: UIFont(name: "AvenirNext-DemiBold", size: 15),
            titleColor: UIColor(named: "Base"),
            subtitleFont: UIFont(name: "AvenirNext-Regular", size: 13),
            subtitleColor: UIColor(named: "MainText")
        )
    }
    
    private func contentModel(track: STTrack, content: STContent) -> MiniPlayerModel.Content {
        return .init(
            image: URL(string: track.imgSrc ?? ""),
            title: track.title,
            subtitle: content.title
        )
    }
    
    private func stateModel(state: STPlayerState) -> MiniPlayerModel.AudioStatus {
        switch state {
        case .playing, .loading:
            return .init(
                playButtonIsDisplayed: false,
                pauseButtonIsDisplayed: true
            )
            
        case .paused:
            return .init(
                playButtonIsDisplayed: true,
                pauseButtonIsDisplayed: false
            )
        @unknown default:
            fatalError()
        }
    }
    
    private func positionModel(time: Double, and duration: Double) -> MiniPlayerModel.AudioPosition {
        return .init(progressValue: Float(time) / Float(duration))
    }
}

extension MiniPlayerPresenter: MiniPlayerPresenterInput {
    
    func setStyle() {
        self.view?.update(with: self.styleModel())
    }
    
    func update(for track: STTrack, and content: STContent) {
        self.view?.update(with: self.contentModel(track: track, content: content))
    }

    func update(for state: STPlayerState) {
        self.view?.update(with: self.stateModel(state: state))
    }
    
    func update(for time: Double, and duration: Double?) {
        guard let duration = duration else {
            return
        }
        self.view?.update(with: self.positionModel(time: time, and: duration))
    }
    
    func displayExpand() {
        self.view?.displayExpand()
    }
}
