//
//  SelectCoinWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 28/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - SelectCoinWireframe
final class SelectCoinWireframe: NSObject, SelectCoinWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.selectCoinViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = SelectCoinInteractor()
        let presenter = SelectCoinPresenter()
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = SelectCoinWireframe()
        presenter.payload = payload
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
