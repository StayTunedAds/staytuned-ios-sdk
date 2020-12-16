//
//  MainTabBarViewController.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 19/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import UIKit
import StayTunedSDK

class MainTabBarViewController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? STPlayer.getInstance().setMiniPlayer(in: self)
    }

}
