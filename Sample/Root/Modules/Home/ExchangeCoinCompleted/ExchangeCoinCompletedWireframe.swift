//
//  ExchangeCoinCompletedWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - ExchangeCoinCompletedWireframe
final class ExchangeCoinCompletedWireframe: NSObject, ExchangeCoinCompletedWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.exchangeCoinCompletedViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = ExchangeCoinCompletedInteractor()
        let presenter = ExchangeCoinCompletedPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = ExchangeCoinCompletedWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
