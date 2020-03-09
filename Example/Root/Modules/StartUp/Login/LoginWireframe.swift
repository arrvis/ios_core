//
//  LoginWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - LoginWireframe
final class LoginWireframe: NSObject, LoginWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.loginViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = LoginWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showRequestPermissionsScreen() {
        navigator.navigate(screen: AppScreens.requestPermissions)
    }
}
