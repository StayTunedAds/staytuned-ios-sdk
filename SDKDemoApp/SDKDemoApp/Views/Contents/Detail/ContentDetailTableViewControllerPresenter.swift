//
//  ContentDetailTableViewControllerPresenter.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 16/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import UIKit
import StayTunedSDK

protocol ContentDetailTableViewControllerPresenterInput {
    func loadContent(with content: STContentLight)
    func loadOfflineTracks()
    func loadFavoritesTracks()
    func userDidSelectRow(at index: Int)
    func toggleOffline(on index: Int)
    func toggleFavorite(on index: Int)
}

final class ContentDetailTableViewControllerPresenter {
    
    private weak var viewController: ContentDetailTableViewControllerInput?
    private var observationRetainers: [STObservable.Cancellable?] = []
    
    private lazy var contentsFeature: STContents? = {
        return try? STContents.getInstance()
    }()

    private lazy var player: STPlayer? = {
        return try? STPlayer.getInstance()
    }()
    
    private lazy var offline: STOffline? = {
        return try? STOffline.getInstance()
    }()
    
    private lazy var favorites: Favorites? = {
        return Favorites.shared
    }()
    
    private var content: STContent? {
        didSet {
            self.buildContentViewModel()
            self.buildOfflineViewModel()
            self.buildFavoritesViewModel()
        }
    }
    
    private var offlineTracks: [STTrackOfflineItem]? {
        didSet { self.buildOfflineViewModel() }
    }
    
    private var favoritesTracks: [STTrackListItem]? {
        didSet { self.buildFavoritesViewModel() }
    }
    
    init(viewController: ContentDetailTableViewControllerInput?) {
        self.viewController = viewController
        STOffline.shared?.add(observer: self)
        Favorites.shared?.add(observer: self)
    }
    
    private func retrieveContent(by key: String) {
        self.contentsFeature?.get(by: key, completion: { [weak self] result in
            switch result {
            case .success(let content):
                self?.content = content
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func buildContentViewModel() {
        guard let content = self.content else {
            return
        }
        let header = ContentDetailTableViewControllerViewModel.Header(imageSrc: content.imgSrc, caption: content.title)
        let cells = content.elementList?.compactMap({ track -> ContentDetailTableViewControllerViewModel.Cell? in
            return .init(imageSrc: track.imgSrc, title: track.title, subtitle: track.subtitle)
        })
        let viewModel = ContentDetailTableViewControllerViewModel.Content(
            title: content.title,
            header: header,
            cells: cells
        )
        self.viewController?.updateViewModel(viewModel)
    }
    
    private func buildOfflineViewModel() {
        guard let content = self.content else {
            return
        }
        let cellStates = content.elementList?.map({ track -> STOfflineState? in
            return self.offlineTracks?.first(where: { item -> Bool in
                item.audioItem == track
            })?.state
        })
        let cells = cellStates?.map { state -> ContentDetailTableViewControllerViewModel.CellOfflineProgress in
            switch state {
            case .downloading(let progress):
                return .init(progressViewIsHidden: false, progressValue: progress ?? 0, setProgressIsAnimated: true)
            case .downloaded:
                return .init(progressViewIsHidden: false, progressValue: 1, setProgressIsAnimated: false)
            default:
                return .init(progressViewIsHidden: true, progressValue: 0, setProgressIsAnimated: false)
            }
        }
        self.viewController?.updateViewModel(.init(cells: cells))
    }
    
    private func buildFavoritesViewModel() {
        guard let content = self.content else {
            return
        }
        let cellFavoriteStates = content.elementList?.map({ track -> Bool? in
            return self.favoritesTracks?.contains(where: { item -> Bool in
                item.key == track.key
            })
        })
        let cells = cellFavoriteStates?.map({ isFavorite -> ContentDetailTableViewControllerViewModel.CellFavorites in
            if isFavorite == true {
                return .init(image: "starFilled")
            } else {
                 return .init(image: "star")
            }
        })
        self.viewController?.updateViewModel(.init(cells: cells))
    }
}

extension ContentDetailTableViewControllerPresenter: ContentDetailTableViewControllerPresenterInput {
    
    func loadContent(with content: STContentLight) {
        self.retrieveContent(by: content.key)
    }
    
    func loadOfflineTracks() {
        self.offlineTracks = self.offline?.tracks
    }
    
    func loadFavoritesTracks() {
        if let list = self.favorites?.list {
            self.favoritesTracks = list.items
        }
    }

    func userDidSelectRow(at index: Int) {
        guard let content = self.content else {
            return
        }
        self.player?.play(playlist: STPlaylist(content: content), at: index)
    }
    
    func toggleOffline(on trackIndex: Int) {
        guard
            let tracks = self.content?.elementList,
            tracks.count > trackIndex else { return }
        
        let track = tracks[trackIndex]
        if self.offline?.tracks.contains(where: { item -> Bool in
            item.audioItem.key == track.key
        }) ?? false {
            try? self.offline?.remove(track: track)
        } else {
            self.offline?.add(track: track) { result in
                switch result {
                case .success():
                    break
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func toggleFavorite(on trackIndex: Int) {
        guard
            let tracks = self.content?.elementList,
            tracks.count > trackIndex else { return }
        
        let track = tracks[trackIndex]
        let listItem = self.favorites?.list?.items.first(where: { item -> Bool in
            item.key == track.key
        })
        if let item = listItem {
            self.favorites?.list?.deleteItem(item, completion: { error in
                print(error)
            })
        } else {
            self.favorites?.list?.addItem(STTrackListItem(track: track), completion: { error in
                print(error)
            })
        }
    }
    
}

extension ContentDetailTableViewControllerPresenter: STOfflineObserver {
    func offlineContentItemDidChange(_ item: STContentLightOfflineItem) {}
    
    func offlineTrackItemsDidChange(_ items: [STTrackOfflineItem]) {
        self.offlineTracks = self.offline?.tracks
    }
}

extension ContentDetailTableViewControllerPresenter: FavoritesObserver {
    func itemsDidChange(to value: [STTrackListItem]) {
        self.favoritesTracks = value
    }
}
