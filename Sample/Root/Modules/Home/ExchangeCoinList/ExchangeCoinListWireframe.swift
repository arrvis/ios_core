//
//  ExchangeCoinListWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - ExchangeCoinListWireframe
final class ExchangeCoinListWireframe: NSObject, ExchangeCoinListWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.exchangeCoinListViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! ExchangeCoinListViewController
        let interactor = ExchangeCoinListInteractor()
        let presenter = ExchangeCoinListPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = ExchangeCoinListWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
