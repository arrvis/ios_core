//
//  TopPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - TopPresenter
final class TopPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: TopInteractorInterface {
        return interactorInterface as! TopInteractorInterface
    }

    private weak var view: TopViewInterface? {
        return viewInterface as? TopViewInterface
    }

    private var wireframe: TopWireframeInterface {
        return wireframeInterface as! TopWireframeInterface
    }
}

// MARK: - TopPresenterInterface
extension TopPresenter: TopPresenterInterface {

    func didTapLogin() {
        wireframe.showLoginScreen()
    }

    func didTapForgotPassword() {
        wireframe.showResetPasswordScreen()
    }
}

// MARK: - TopInteractorOutputInterface
extension TopPresenter: TopInteractorOutputInterface {
}
