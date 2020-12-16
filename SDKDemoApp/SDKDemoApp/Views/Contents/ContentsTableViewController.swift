//
//  ContentsTableViewController.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 16/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import UIKit
import StayTunedSDK

protocol ContentsTableViewControllerInput: class {
    func updateViewModel(_ viewModel: ContentsTableViewControllerViewModel.Content)
    func show(content: STContentLight)
}

final class ContentsTableViewController: UITableViewController {
    
    private var presenter: ContentsTableViewControllerPresenterInput!
    
    private var viewModel: ContentsTableViewControllerViewModel.Content? {
        didSet { self.viewModelUpdated() }
    }
    
    override func loadView() {
        super.loadView()
        self.presenter = ContentsTableViewControllerPresenter(viewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.loading(true)
        self.presenter.loadContent()
    }
    
    private func viewModelUpdated() {
        guard let viewModel = viewModel else {
            return
        }
        self.tableView.loading(false)
        self.title = viewModel.title
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let content = sender as? STContentLight else {
            return
        }
        guard var destination = segue.destination as? ContentDetailTableViewControllerCoordinator else {
            return
        }
        destination.lightContent = content
    }
}

// MARK: - UITableViewDelegate & UITableViewDatasource
extension ContentsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cells?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let model = self.viewModel?.cells?[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell") as? ContentTableViewCell else {
                return .init()
        }
        cell.setViewModel(model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.userDidSelectRow(at: indexPath.row)
    }
    
}

extension ContentsTableViewController: ContentsTableViewControllerInput {
    
    func updateViewModel(_ viewModel: ContentsTableViewControllerViewModel.Content) {
        self.viewModel = viewModel
    }
    
    func show(content: STContentLight) {
        self.performSegue(withIdentifier: "showContent", sender: content)
    }
}
