//
//  RequestPermissionsWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - RequestPermissionsWireframe
final class RequestPermissionsWireframe: NSObject, RequestPermissionsWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.requestPermissionsViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! RequestPermissionsViewController
        let interactor = RequestPermissionsInteractor()
        let presenter = RequestPermissionsPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = RequestPermissionsWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showWalkthroughScreen() {
        navigator.navigate(screen: AppScreens.walkthrough)
    }
}
