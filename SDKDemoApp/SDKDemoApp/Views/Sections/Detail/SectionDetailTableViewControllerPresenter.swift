//
//  SectionDetailTableViewControllerPresenter.swift
//  SDKDemoApp
//
//  Created by Kevin Morais on 11/08/2020.
//  Copyright © 2020 STAYTUNED. All rights reserved.
//

import Foundation
import StayTunedSDK

protocol SectionDetailTableViewControllerPresenterInput {
    func loadSection(_ section: STSection)
    func presentContent(at index: Int)
}

final class SectionDetailTableViewControllerPresenter {
    
    private weak var viewController: SectionDetailTableViewControllerInput?
    
    private lazy var stSections: STSections? = {
        return try? STSections.getInstance()
    }()
    
    private var section: STSection? {
        didSet { self.buildViewModel() }
    }
    
    init(viewController: SectionDetailTableViewControllerInput) {
        self.viewController = viewController
    }
    
    private func buildViewModel() {
        guard let section = self.section else {
            return
        }
        let cellsViewModel = section.linkedContents?.compactMap({ lightContent -> SectionDetailTableViewModel.Cell in
            return .init(imageSource: lightContent.imgSrc, title: lightContent.title, subtitle: lightContent.author)
        })
        let contentViewModel = SectionDetailTableViewModel.Content(title: section.name, cells: cellsViewModel)
        self.viewController?.updatedViewModel(contentViewModel)
    }
    
    private func loadSection(for section: STSection) {
        STSections.shared?.getSection(by: section.id, completion: { result in
            switch result {
            case .success(let section):
                self.section = section
            case .failure(let error):
                print(error)
            }
        })
    }
}

extension SectionDetailTableViewControllerPresenter: SectionDetailTableViewControllerPresenterInput {
    
    func loadSection(_ section: STSection) {
        self.loadSection(for: section)
    }
    
    func presentContent(at index: Int) {
        guard let lightContent = self.section?.linkedContents?[index] else {
            return
        }
        self.viewController?.show(lightContent: lightContent)
    }
}
