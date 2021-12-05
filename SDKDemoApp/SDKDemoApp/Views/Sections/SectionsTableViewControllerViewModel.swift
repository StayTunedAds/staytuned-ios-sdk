//
//  SectionsTableViewControllerViewModel.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 10/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import Foundation

enum SectionsTableViewControllerViewModel {

    struct Content {
        let title: String
        let cells: [Cell]?
    }

    struct Cell {
        let title: String
    }

}
