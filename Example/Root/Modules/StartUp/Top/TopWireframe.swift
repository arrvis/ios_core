//
//  TopWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - TopWireframe
final class TopWireframe: NSObject, TopWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.topViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! TopViewController
        let interactor = TopInteractor()
        let presenter = TopPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = TopWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showLoginScreen() {
        navigator.navigate(screen: AppScreens.login)
    }

    func showResetPasswordScreen() {
        showOkAlert(nil, "TODO: 未実装", "OK", nil)
    }
}
