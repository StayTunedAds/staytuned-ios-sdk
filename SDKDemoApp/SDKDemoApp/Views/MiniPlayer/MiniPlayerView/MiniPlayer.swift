//
//  MiniPlayer.swift
//  StayTuned
//
//  Created by Agylos on 01/08/2019.
//  Copyright © 2019 StayTuned. All rights reserved.
//

import UIKit
import StayTunedSDK
import SDWebImage

protocol MiniPlayerInput: class {
    func update(with model: MiniPlayerModel.Style)
    func update(with model: MiniPlayerModel.Content)
    func update(with model: MiniPlayerModel.AudioStatus)
    func update(with model: MiniPlayerModel.AudioPosition)
    func displayExpand()
}

final class MiniPlayer: UIView {
    
    @IBOutlet private weak var fixedView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var openExpandButton: UIButton!
    
    weak var viewController: UIViewController?
    
    private var interactor: MiniPlayerInteractorInput!
    
    override func awakeFromNib() {
        self.interactor = MiniPlayerInteractor(
            presenter: MiniPlayerPresenter(view: self)
        )
        self.progressView.setProgress(0, animated: false)
    }
    
    @IBAction private func didTapPlay(_ sender: Any) {
        self.interactor.didTapPlay()
    }
    
    @IBAction private func didTapPause(_ sender: Any) {
        self.interactor.didTapPause()
    }
    
    @IBAction private func didTapOpenMainPage(_ sender: Any) {
        self.interactor.didTapMiniPlayer()
    }
    
}

extension MiniPlayer: MiniPlayerInput {
    
    func update(with model: MiniPlayerModel.Style) {
        self.backgroundColor = model.backgroundColor
        self.progressView.progressTintColor = model.progressTintColor
        self.progressView.trackTintColor = model.trackTintColor
        self.playButton.setImage(model.playButtonImage, for: .normal)
        self.pauseButton.setImage(model.pauseButtonImage, for: .normal)
        self.titleLabel.font = model.titleFont
        self.titleLabel.textColor = model.titleColor
        self.subtitleLabel.font = model.subtitleFont
        self.subtitleLabel.textColor = model.subtitleColor
    }
    
    func update(with model: MiniPlayerModel.Content) {
        if let url = model.image {
            self.imageView.sd_setImage(with: URL(string: url.absoluteString), completed: nil)
        }
        self.titleLabel.text = model.title
        self.subtitleLabel.text = model.subtitle
    }
    
    func update(with model: MiniPlayerModel.AudioStatus) {
        self.playButton.isHidden = !model.playButtonIsDisplayed
        self.pauseButton.isHidden = !model.pauseButtonIsDisplayed
    }
    
    func update(with model: MiniPlayerModel.AudioPosition) {
        self.progressView.setProgress(model.progressValue, animated: false)
    }
    
    func displayExpand() {
        if let viewController = self.viewController {
            STExpand.shared?.present(from: viewController)
        }
    }
}
