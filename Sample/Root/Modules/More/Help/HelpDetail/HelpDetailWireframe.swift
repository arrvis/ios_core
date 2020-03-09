//
//  HelpDetailWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 04/03/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - HelpDetailWireframe
final class HelpDetailWireframe: NSObject, HelpDetailWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.helpDetailViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = HelpDetailInteractor()
        let presenter = HelpDetailPresenter()
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = HelpDetailWireframe()
        presenter.payload = payload
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
