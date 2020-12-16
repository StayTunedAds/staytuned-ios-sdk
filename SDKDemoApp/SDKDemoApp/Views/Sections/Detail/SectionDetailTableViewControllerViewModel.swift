//
//  SectionDetailTableViewControllerViewModel.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 11/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import Foundation

enum SectionDetailTableViewModel {
    
    struct Content {
        let title: String
        let cells: [Cell]?
    }
    
    struct Cell {
        let imageSource: String?
        let title: String
        let subtitle: String?
    }
}
