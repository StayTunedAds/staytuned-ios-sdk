//
//  ContentDetailTableViewControllerViewModel.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 16/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import Foundation
import StayTunedSDK

enum ContentDetailTableViewControllerViewModel {
    
    struct Content {
        let title: String
        let header: Header
        let cells: [Cell]?
    }
    
    struct Header {
        let imageSrc: String?
        let caption: String?
    }
    
    struct Cell {
        let imageSrc: String?
        let title: String?
        let subtitle: String?
    }
    
    struct Offline {
        let cells: [CellOfflineProgress]?
    }
    
    struct CellOfflineProgress {
        let progressViewIsHidden: Bool
        let progressValue: Float
        let setProgressIsAnimated: Bool
    }
    
    struct Favorites {
        let cells: [CellFavorites]?
    }
    
    struct CellFavorites {
        let image: String
    }
}
