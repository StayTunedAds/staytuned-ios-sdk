//
//  AppDelegate.swift
//  SDKDemoApp
//
//  Created by Agylos on 03/07/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import UIKit
import StayTunedSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let _ = try? StayTunedSDK(
            appId: "831932a3-d0d9-40b3-b3f3-955e478052d1",
            authToken: "33882518.e81c873d-fc8d-4190-97bc-90b08731d0b1",
            options: .init(uiOptions: .init(brandColor: .purple))
        )
        
        STPlayer.shared?.setConfiguration(
            .init(
                isContentCellVisible: true,
                preferredAudioQuality: .hd
            )
        )
        
         Favorites.shared = Favorites()
        
        STAuth.shared?.connectAnonymous(completion: { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }
        })
        
        return true
    }
}
