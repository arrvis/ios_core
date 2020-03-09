//
//  LoginPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - LoginPresenter
final class LoginPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: LoginInteractorInterface {
        return interactorInterface as! LoginInteractorInterface
    }

    private weak var view: LoginViewInterface? {
        return viewInterface as? LoginViewInterface
    }

    private var wireframe: LoginWireframeInterface {
        return wireframeInterface as! LoginWireframeInterface
    }

    // MARK: - Overrides

    override func handleError(_ error: Error, _ completion: (() -> Void)?) {
        if let view = view {
            view.hideLoading()
            if !view.showHTTPError(error, false, completion) {
                view.showErrorWithLocalizedDescription(error, completion)
            }
        }
    }
}

// MARK: - LoginPresenterInterface
extension LoginPresenter: LoginPresenterInterface {

    func didTapLogin(_ id: String, _ password: String) {
        view?.showLoading()
        interactor.login(id, password)
    }
}

// MARK: - LoginInteractorOutputInterface
extension LoginPresenter: LoginInteractorOutputInterface {

    func onLoginSucceeded() {
        view?.hideLoading()
        wireframe.showRequestPermissionsScreen()
    }
}
