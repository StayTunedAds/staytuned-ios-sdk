//
//  ContentTrackTableViewcell.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 16/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import UIKit
import SDWebImage

protocol ContentTrackTableViewCellDelegate: AnyObject {
    func didTapToggleOffline(on cell: UITableViewCell)
    func didTapToggleFavorite(on cell: UITableViewCell)
}

final class ContentTrackTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentImage: UIImageView!
    @IBOutlet private weak var contentTitle: UILabel!
    @IBOutlet private weak var contentSubtitle: UILabel!
    @IBOutlet private weak var offlineProgress: UIProgressView!
    @IBOutlet private weak var toggleFavoriteButton: UIButton!

    weak var delegate: ContentTrackTableViewCellDelegate?

    @IBAction private func didTapToggleOffline(_ sender: Any) {
        self.delegate?.didTapToggleOffline(on: self)
    }

    @IBAction private func didTapToggleFavorite(_ sender: Any) {
        self.delegate?.didTapToggleFavorite(on: self)
    }

    func setViewModel(_ viewModel: ContentDetailTableViewControllerViewModel.Cell) {
        self.contentImage.sd_setImage(with: URL(string: viewModel.imageSrc ?? ""), completed: nil)
        self.contentTitle.text = viewModel.title
        self.contentSubtitle.text = viewModel.subtitle
    }

    func setViewModel(_ viewModel: ContentDetailTableViewControllerViewModel.CellOfflineProgress) {
        self.offlineProgress.isHidden = viewModel.progressViewIsHidden
        self.offlineProgress.setProgress(viewModel.progressValue, animated: viewModel.setProgressIsAnimated)
    }

    func setViewModel(_ viewModel: ContentDetailTableViewControllerViewModel.CellFavorites) {
        self.toggleFavoriteButton.setImage(UIImage(named: viewModel.image), for: .normal)
    }

}
