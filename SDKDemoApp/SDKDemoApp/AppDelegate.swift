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
            authToken: "95ab8c4d.bcaccc8b-4056-4da5-a9e9-12fe73a663b2",
            options: .init(uiOptions: .init(brandColor: .purple))
        )
        
        STPlayer.shared?.setConfiguration(
            .init(
                isContentCellVisible: true,
                onContentCellClick: { _ in
                    STExpand.shared?.dismiss(completion: nil )
                }
            )
        )
        
        // Favorites.shared = Favorites()
        
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
