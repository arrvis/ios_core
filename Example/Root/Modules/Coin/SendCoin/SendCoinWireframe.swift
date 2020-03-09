//
//  SendCoinWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - SendCoinWireframe
final class SendCoinWireframe: NSObject, SendCoinWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.sendCoinViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! SendCoinViewController
        let interactor = SendCoinInteractor()
        let presenter = SendCoinPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = SendCoinWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showSelectMemberScreen() {
        navigator.navigate(screen: AppScreens.selectMember)
    }

    func showSelectCoinScreen() {
        navigator.navigate(screen: AppScreens.selectCoin)
    }
}
