//
//  SectionsTableViewControllerPresenter.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 10/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import UIKit
import StayTunedSDK

protocol SectionsTableViewControllerPresenterInput {
    func loadContent()
    func userDidSelectRow(at index: Int)
}

final class SectionsTableViewControllerPresenter {

    private weak var viewController: SectionsTableViewControllerInput?

    private lazy var stSections: STSections? = {
        return try? STSections.getInstance()
    }()

    private var sections: [STSection]? {
        didSet { self.buildContentViewModel() }
    }

    init(viewController: SectionsTableViewControllerInput) {
        self.viewController = viewController
    }

    private func retrieveSections() {
        self.stSections?.getSections(completion: { [weak self] result in
            switch result {
            case .success(let sections):
                self?.sections = sections
            case .failure(let error):
                print(error)
            }
        })
    }

    private func buildContentViewModel() {
        guard let sections = self.sections else {
            return
        }
        let cells = sections.compactMap { section -> SectionsTableViewControllerViewModel.Cell in
            return .init(
                title: section.name
            )
        }
        let viewModel = SectionsTableViewControllerViewModel.Content(
            title: "Sections",
            cells: cells
        )
        self.viewController?.updateViewModel(viewModel)
    }

}

extension SectionsTableViewControllerPresenter: SectionsTableViewControllerPresenterInput {

    func loadContent() {
        self.retrieveSections()
    }

    func userDidSelectRow(at index: Int) {
        guard let section = self.sections?[index] else {
            return
        }
        self.viewController?.show(section: section)
    }
}
