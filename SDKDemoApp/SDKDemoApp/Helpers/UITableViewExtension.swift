//
//  UITableViewExtension.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 16/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import UIKit

extension UITableView {

    func loading(_ loading: Bool) {
        if loading {
            self.tableFooterView = UIView()
            if #available(iOS 13.0, *) {
                let activityIndicator = UIActivityIndicatorView(style: .medium)
                activityIndicator.center = self.center
                activityIndicator.startAnimating()
                self.backgroundView = activityIndicator
            } else {
                let activityIndicator = UIActivityIndicatorView(style: .gray)
                activityIndicator.center = self.center
                activityIndicator.startAnimating()
                self.backgroundView = activityIndicator
            }

        } else {
            self.backgroundView = UIView()
        }
    }

}
