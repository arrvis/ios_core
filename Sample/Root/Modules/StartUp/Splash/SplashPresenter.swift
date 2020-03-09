//
//  SplashPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - SplashPresenter
final class SplashPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: SplashInteractorInterface {
        return interactorInterface as! SplashInteractorInterface
    }

    private weak var view: SplashViewInterface? {
        return viewInterface as? SplashViewInterface
    }

    private var wireframe: SplashWireframeInterface {
        return wireframeInterface as! SplashWireframeInterface
    }

    // MARK: - Life-Cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view?.showLoading()
        interactor.fetchIsSignedIn()
    }
}

// MARK: - SplashPresenterInterface
extension SplashPresenter: SplashPresenterInterface {
}

// MARK: - SplashInteractorOutputInterface
extension SplashPresenter: SplashInteractorOutputInterface {

    func fetchIsSignedInCompleted(
        _ isSignedIn: Bool,
        _ didDisplayRequestPermissions: Bool,
        _ didDisplayWalkthrough: Bool
    ) {
        view?.hideLoading()
        if !isSignedIn {
            wireframe.showTopScreen()
        } else if !didDisplayRequestPermissions {
            wireframe.showRequestPermissionsScreen()
        } else if !didDisplayWalkthrough {
            wireframe.showWalkthroughScreen()
        } else {
            wireframe.showMainScreen()
        }
    }
}
