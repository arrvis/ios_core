//
//  HelpWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 04/03/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - HelpWireframe
final class HelpWireframe: NSObject, HelpWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.helpViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! HelpViewController
        let interactor = HelpInteractor()
        let presenter = HelpPresenter()
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = HelpWireframe()
        presenter.payload = payload
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showHelpDetailScreen(_ help: HelpData) {
        navigator.navigate(screen: AppScreens.helpDetail, payload: help)
    }
}
