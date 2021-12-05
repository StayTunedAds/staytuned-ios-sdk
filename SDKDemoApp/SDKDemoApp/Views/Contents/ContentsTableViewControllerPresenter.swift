//
//  ContentsTableViewControllerPresenter.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 16/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import Foundation
import StayTunedSDK

protocol ContentsTableViewControllerPresenterInput {
    func loadContent()
    func userDidSelectRow(at index: Int)
}

final class ContentsTableViewControllerPresenter {

    private weak var viewController: ContentsTableViewControllerInput?

    private lazy var stContents: STContents? = {
        return try? STContents.getInstance()
    }()

    private var contents: [STContentLight]? {
        didSet { self.buildContentsViewModel() }
    }

    init(viewController: ContentsTableViewControllerInput) {
        self.viewController = viewController
    }

    private func retrieveContents() {
        self.stContents?.getAll(completion: { [weak self] result in
            switch result {
            case .success(let contents):
                self?.contents = contents
            case .failure(let error):
                print(error)
            }
        })
    }

    private func buildContentsViewModel() {

        guard let contents = self.contents else {
            return
        }
        let cells = contents.compactMap { content -> ContentsTableViewControllerViewModel.Cell in
            return .init(imageSource: content.imgSrc, title: content.title, subtitle: content.author)
        }
        let viewModel = ContentsTableViewControllerViewModel.Content(
            title: "Contents",
            cells: cells
        )
        self.viewController?.updateViewModel(viewModel)
    }

}

extension ContentsTableViewControllerPresenter: ContentsTableViewControllerPresenterInput {

    func userDidSelectRow(at index: Int) {
        guard let content = self.contents?[index] else {
            return
        }
        self.viewController?.show(content: content)
    }

    func loadContent() {
        self.retrieveContents()
    }

}
