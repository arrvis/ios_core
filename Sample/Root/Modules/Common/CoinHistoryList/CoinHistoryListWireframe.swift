//
//  CoinHistoryListWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - CoinHistoryListWireframe
final class CoinHistoryListWireframe: NSObject, CoinHistoryListWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.coinHistoryListViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = CoinHistoryListInteractor()
        let presenter = CoinHistoryListPresenter()
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = CoinHistoryListWireframe()
        presenter.payload = payload
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
