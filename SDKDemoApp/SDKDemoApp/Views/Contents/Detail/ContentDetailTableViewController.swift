//
//  ContentDetailTableViewController.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 16/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import UIKit
import StayTunedSDK
import SDWebImage

protocol ContentDetailTableViewControllerCoordinator {
    var lightContent: STContentLight! { get set }
}

protocol ContentDetailTableViewControllerInput: class {
    func updateViewModel(_ viewModel: ContentDetailTableViewControllerViewModel.Content)
    func updateViewModel(_ viewModel: ContentDetailTableViewControllerViewModel.Offline)
    func updateViewModel(_ viewModel: ContentDetailTableViewControllerViewModel.Favorites)
    func displayMiniPlayer()
}

final class ContentDetailTableViewController: UITableViewController, ContentDetailTableViewControllerCoordinator {

    @IBOutlet private weak var headerImage: UIImageView!
    @IBOutlet private weak var captionImage: UILabel!
    
    private var presenter: ContentDetailTableViewControllerPresenterInput?
    
    private var viewModel: ContentDetailTableViewControllerViewModel.Content? {
        didSet { self.updatedViewModel() }
    }
    
    private var offlineModel: ContentDetailTableViewControllerViewModel.Offline? {
        didSet { self.updatedOfflineModel() }
    }
    
    private var favoritesModel: ContentDetailTableViewControllerViewModel.Favorites? {
        didSet { self.updatedFaoritesModel() }
    }
    
    var lightContent: STContentLight!
    
    override func loadView() {
        super.loadView()
        self.presenter = ContentDetailTableViewControllerPresenter(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.loading(true)
        self.presenter?.loadContent(with: self.lightContent)
        self.presenter?.loadOfflineTracks()
        self.presenter?.loadFavoritesTracks()
    }
    
    private func updatedViewModel() {
        guard let viewModel = self.viewModel else {
            return
        }
        self.tableView.loading(false)
        self.title = viewModel.title
        self.headerImage.sd_setImage(with: URL(string: viewModel.header.imageSrc ?? ""), completed: nil)
        self.captionImage.text = viewModel.header.caption
        self.tableView.reloadData()
    }
    
    private func updatedOfflineModel() {
        self.tableView.indexPathsForVisibleRows?.forEach({ indexPath in
            self.updateCell(at: indexPath, with: self.offlineModel?.cells?[indexPath.row])
        })
    }
    
    private func updateCell(at indexPath: IndexPath, with viewModel: ContentDetailTableViewControllerViewModel.CellOfflineProgress?) {
        guard let viewModel = viewModel else {
            return
        }
        (self.tableView.cellForRow(at: indexPath) as? ContentTrackTableViewCell)?.setViewModel(viewModel)
    }
    
    private func updatedFaoritesModel() {
        self.tableView.indexPathsForVisibleRows?.forEach({ indexPath in
            self.updateCell(at: indexPath, with: self.favoritesModel?.cells?[indexPath.row])
        })
    }
    
    private func updateCell(at indexPath: IndexPath, with viewModel: ContentDetailTableViewControllerViewModel.CellFavorites?) {
        guard let viewModel = viewModel else {
            return
        }
        (self.tableView.cellForRow(at: indexPath) as? ContentTrackTableViewCell)?.setViewModel(viewModel)
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDatasource
extension ContentDetailTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.cells?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cellModel = self.viewModel?.cells?[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTrackTableViewCell") as? ContentTrackTableViewCell
            else {
                return .init()
        }
        
        cell.setViewModel(cellModel)
        cell.delegate = self
        
        if let offlineModel = self.offlineModel?.cells?[indexPath.row] {
            cell.setViewModel(offlineModel)
        }
        
        if let favoriteModel = self.favoritesModel?.cells?[indexPath.row] {
            cell.setViewModel(favoriteModel)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.userDidSelectRow(at: indexPath.row)
    }
    
}

extension ContentDetailTableViewController: ContentDetailTableViewControllerInput {
    
    func updateViewModel(_ viewModel: ContentDetailTableViewControllerViewModel.Content) {
        self.viewModel = viewModel
    }
    
    func updateViewModel(_ viewModel: ContentDetailTableViewControllerViewModel.Offline) {
        self.offlineModel = viewModel
    }
    
    func updateViewModel(_ viewModel: ContentDetailTableViewControllerViewModel.Favorites) {
        self.favoritesModel = viewModel
    }
    
    func displayMiniPlayer() {
        STPlayer.shared?.displayMiniPlayer(true)
    }
    
}

extension ContentDetailTableViewController: ContentTrackTableViewCellDelegate {
    func didTapToggleOffline(on cell: UITableViewCell) {
        guard let row = self.tableView.indexPath(for: cell)?.row else {
            return
        }
        self.presenter?.toggleOffline(on: row)
    }
    
    func didTapToggleFavorite(on cell: UITableViewCell) {
        guard let row = self.tableView.indexPath(for: cell)?.row else {
            return
        }
        self.presenter?.toggleFavorite(on: row)
    }
}
