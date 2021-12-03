//
//  Favorites.swift
//  SDKDemoApp
//
//  Created by Agylos on 11/09/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import Foundation
import StayTunedSDK

class Favorites {
    
    static var shared: Favorites?
    
    var observers: [STWeakRef] = []
    
    init() {
        STAuth.shared?.add(observer: self)
    }
    
    var list: STTrackList? {
        didSet {
            self.list?.add(observer: self)
        }
    }

    private func initialization() {
        STLists.shared?.getOrCreate(name: "DemoAppFavorites", type: .favorite, completion: { [weak self] (result: Result<STList<STTrack>, Error>) in
            switch result {
            case .success(let list):
                self?.list = list
            case .failure(let error):
                print(error)
            }
        })
    }
    
}

extension Favorites: STAuthObserver {
    
    func authStatusDidChange(to status: STAuth.Status) {
        switch status {
        case .authenticated:
            self.initialization()
        default:
            break
        }
    }
    
    func didConnect() {}
}

protocol FavoritesObserver: AnyObject {
    func itemsDidChange(to value: [STTrackListItem])
}

extension Favorites: STObservableProtocol {
    func add(observer: FavoritesObserver) {
        self.observers.append(STWeakRef(value: observer))
    }
    
    func remove(observer: FavoritesObserver) {
        self.observers.removeAll { ref -> Bool in
            ref.value === observer
        }
    }
}

extension Favorites: STListObserver {
    func itemsDidChange<Item>(to value: [STListItem<Item>]) {
        self.observers.forEach { ref in
            if let observer = ref.value as? FavoritesObserver, let value = value as? [STTrackListItem] {
                observer.itemsDidChange(to: value)
            }
        }
    }
}
