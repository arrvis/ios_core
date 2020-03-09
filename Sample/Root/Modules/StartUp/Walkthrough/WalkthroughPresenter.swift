//
//  WalkthroughPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - WalkthroughPresenter
final class WalkthroughPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: WalkthroughInteractorInterface {
        return interactorInterface as! WalkthroughInteractorInterface
    }

    private weak var view: WalkthroughViewInterface? {
        return viewInterface as? WalkthroughViewInterface
    }

    private var wireframe: WalkthroughWireframeInterface {
        return wireframeInterface as! WalkthroughWireframeInterface
    }
}

// MARK: - WalkthroughPresenterInterface
extension WalkthroughPresenter: WalkthroughPresenterInterface {

    func didTapNext() {
        interactor.markAsRead()
    }
}

// MARK: - WalkthroughInteractorOutputInterface
extension WalkthroughPresenter: WalkthroughInteractorOutputInterface {

    func markAsReadCompleted() {
        wireframe.showMainScreen()
    }
}
