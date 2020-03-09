//
//  HelpPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 04/03/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - HelpPresenter
final class HelpPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: HelpInteractorInterface {
        return interactorInterface as! HelpInteractorInterface
    }

    private weak var view: HelpViewInterface? {
        return viewInterface as? HelpViewInterface
    }

    private var wireframe: HelpWireframeInterface {
        return wireframeInterface as! HelpWireframeInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.showLoading()
        interactor.fetchHelps()
    }
}

// MARK: - HelpPresenterInterface
extension HelpPresenter: HelpPresenterInterface {

    func didTapHelp(_ help: HelpData) {
        wireframe.showHelpDetailScreen(help)
    }
}

// MARK: - HelpInteractorOutputInterface
extension HelpPresenter: HelpInteractorOutputInterface {

    func fetchHelpsCompleted(_ helps: [HelpData]) {
        view?.hideLoading()
        view?.showHelps(helps)
    }
}
