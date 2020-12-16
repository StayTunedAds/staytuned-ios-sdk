//
//  SectionsTableViewController.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 10/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import UIKit
import StayTunedSDK

protocol SectionsTableViewControllerInput: class {
    func updateViewModel(_ viewModel: SectionsTableViewControllerViewModel.Content)
    func show(section: STSection)
}

final class SectionsTableViewController: UITableViewController {
    
    private var viewModel: SectionsTableViewControllerViewModel.Content? {
        didSet { self.viewModelUpdated() }
    }
    
    private var presenter: SectionsTableViewControllerPresenterInput!

    override func loadView() {
        super.loadView()
        self.presenter = SectionsTableViewControllerPresenter(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.loading(true)
        self.presenter.loadContent()
    }
    
    private func viewModelUpdated() {
        guard let viewModel = self.viewModel else {
            return
        }
        self.tableView.loading(false)
        self.title = viewModel.title
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let section = sender as? STSection else {
            return
        }
        guard var destination = segue.destination as? SectionDetailTableViewControllerCoordinator else {
            return
        }
        destination.section = section
    }
}

// MARK: - UITableViewDelegate & UITableViewDatasource
extension SectionsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.cells?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let model = self.viewModel?.cells?[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return .init()
        }
        cell.textLabel?.text = model.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.userDidSelectRow(at: indexPath.row)
    }
}

// MARK: - SectionsTableViewControllerInput
extension SectionsTableViewController: SectionsTableViewControllerInput {
    
    func updateViewModel(_ viewModel: SectionsTableViewControllerViewModel.Content) {
        self.viewModel = viewModel
    }
    
    func show(section: STSection) {
        self.performSegue(withIdentifier: "showSection", sender: section)
    }
}
