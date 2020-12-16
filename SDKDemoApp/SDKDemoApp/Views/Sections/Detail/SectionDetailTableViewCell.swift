//
//  SectionDetailTableViewCell.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 16/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import UIKit
import SDWebImage

class SectionDetailTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var contentImage: UIImageView!
    @IBOutlet private weak var contentTitle: UILabel!
    @IBOutlet private weak var contentSubtitle: UILabel!
    
    func setViewModel(_ viewModel: SectionDetailTableViewModel.Cell) {
        self.contentImage.sd_setImage(with: URL(string: viewModel.imageSource ?? ""), completed: nil)
        self.contentTitle.text = viewModel.title
        self.contentSubtitle.text = viewModel.subtitle
    }
    
}
