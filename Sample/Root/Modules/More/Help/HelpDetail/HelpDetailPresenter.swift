//
//  HelpDetailPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 04/03/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - HelpDetailPresenter
final class HelpDetailPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: HelpDetailInteractorInterface {
        return interactorInterface as! HelpDetailInteractorInterface
    }

    private weak var view: HelpDetailViewInterface? {
        return viewInterface as? HelpDetailViewInterface
    }

    private var wireframe: HelpDetailWireframeInterface {
        return wireframeInterface as! HelpDetailWireframeInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.showHelp(payload as! HelpData)
    }
}

// MARK: - HelpDetailPresenterInterface
extension HelpDetailPresenter: HelpDetailPresenterInterface {
}

// MARK: - HelpDetailInteractorOutputInterface
extension HelpDetailPresenter: HelpDetailInteractorOutputInterface {
}
