//
//  WalkthroughWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - WalkthroughWireframe
final class WalkthroughWireframe: NSObject, WalkthroughWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.walkthroughViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! WalkthroughViewController
        let interactor = WalkthroughInteractor()
        let presenter = WalkthroughPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = WalkthroughWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showMainScreen() {
        navigator.navigate(screen: AppScreens.main)
    }
}
