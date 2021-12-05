//
//  MiniPlayerModel.swift
//  StayTuned
//
//  Created by Agylos on 15/08/2019.
//  Copyright © 2019 StayTuned. All rights reserved.
//

import UIKit

struct MiniPlayerModel {

    struct Style {
        let backgroundColor: UIColor?
        let progressTintColor: UIColor?
        let trackTintColor: UIColor?
        let playButtonImage: UIImage?
        let pauseButtonImage: UIImage?
        let titleFont: UIFont?
        let titleColor: UIColor?
        let subtitleFont: UIFont?
        let subtitleColor: UIColor?
    }

    struct Content {
        let image: URL?
        let title: String?
        let subtitle: String?
    }

    struct AudioStatus {
        let playButtonIsDisplayed: Bool
        let pauseButtonIsDisplayed: Bool
    }

    struct AudioPosition {
        let progressValue: Float
    }

}
