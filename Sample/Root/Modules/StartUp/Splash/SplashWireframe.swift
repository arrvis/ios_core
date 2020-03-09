//
//  SplashWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - SplashWireframe
final class SplashWireframe: NSObject, SplashWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.splashViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = SplashInteractor()
        let presenter = SplashPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = SplashWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showTopScreen() {
        navigator.navigate(screen: AppScreens.top)
    }

    func showRequestPermissionsScreen() {
        navigator.navigate(screen: AppScreens.requestPermissions)
    }

    func showWalkthroughScreen() {
        navigator.navigate(screen: AppScreens.walkthrough)
    }

    func showMainScreen() {
        navigator.navigate(screen: AppScreens.main)
    }
}
