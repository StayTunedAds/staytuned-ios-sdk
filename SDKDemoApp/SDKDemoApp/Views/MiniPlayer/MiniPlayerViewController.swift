//
//  MiniPlayerViewController.swift
//  SDKDemoApp
//
//  Created by Agylos on 15/12/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import UIKit
import StayTunedSDK

class MiniPlayerViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if STPlayer.shared?.currentTrack != nil {
            self.displayMiniPlayer()
        }
    }
    
    private var miniplayerIsDisplayed: Bool = false
    
    private func displayMiniPlayer() {
        guard
            !self.miniplayerIsDisplayed,
            let miniplayer = UINib(nibName: "MiniPlayer", bundle: .main)
                .instantiate(withOwner: nil, options: nil).first
                as? MiniPlayer
        else {
            return
        }
        
        miniplayer.viewController = self
        
        self.view.addSubview(miniplayer)
        miniplayer.translatesAutoresizingMaskIntoConstraints = false
        miniplayer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        miniplayer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        miniplayer.heightAnchor.constraint(equalToConstant: 90).isActive = true
        miniplayer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.miniplayerIsDisplayed = true
    }
    
}
