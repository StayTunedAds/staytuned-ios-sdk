//
//  SectionDetailTableViewController.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 11/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import UIKit
import StayTunedSDK

protocol SectionDetailTableViewControllerCoordinator {
    var section: STSection! { get set }
}

protocol SectionDetailTableViewControllerInput: class {
    func updatedViewModel(_ viewModel: SectionDetailTableViewModel.Content)
    func show(lightContent: STContentLight)
}

final class SectionDetailTableViewController: UITableViewController, SectionDetailTableViewControllerCoordinator {

    var section: STSection!
    
    private var viewModel: SectionDetailTableViewModel.Content? {
        didSet { self.viewModelUpdated() }
    }
    
    private var presenter: SectionDetailTableViewControllerPresenterInput!
    
    override func loadView() {
        super.loadView()
        self.tableView.loading(true)
        self.presenter = SectionDetailTableViewControllerPresenter(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.loadSection(self.section)
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
        guard let lightContent = sender as? STContentLight else {
                return
        }
        guard var destination = segue.destination as? ContentDetailTableViewControllerCoordinator else {
            return
        }
        destination.lightContent = lightContent
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDatasource
extension SectionDetailTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cells?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionDetailTableViewCell") as? SectionDetailTableViewCell,
            let cellViewModel = viewModel?.cells?[indexPath.row]
            else {
                return .init()
        }
        cell.setViewModel(cellViewModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.presentContent(at: indexPath.row)
    }
}

// MARK: - SectionDetailTableViewControllerInput
extension SectionDetailTableViewController: SectionDetailTableViewControllerInput {
    func updatedViewModel(_ viewModel: SectionDetailTableViewModel.Content) {
        self.viewModel = viewModel
    }
    
    func show(lightContent: STContentLight) {
        self.performSegue(withIdentifier: "showContent", sender: lightContent)
    }
}
