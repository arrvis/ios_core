//
//  ExchangeCoinDetailWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - ExchangeCoinDetailWireframe
final class ExchangeCoinDetailWireframe: NSObject, ExchangeCoinDetailWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.exchangeCoinDetailViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = ExchangeCoinDetailInteractor()
        let presenter = ExchangeCoinDetailPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = ExchangeCoinDetailWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
