//
//  CoinTopWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - CoinTopWireframe
final class CoinTopWireframe: NSObject, CoinTopWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.coinTopViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! CoinTopViewController
        let interactor = CoinTopInteractor()
        let presenter = CoinTopPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = CoinTopWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showLatestNotificationsScreen() {
        navigator.navigate(screen: AppScreens.latestNotifications)
    }

    func showSendCoinScreen() {
        navigator.navigate(screen: AppScreens.sendCoin)
    }
}
