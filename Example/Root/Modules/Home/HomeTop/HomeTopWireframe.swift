//
//  HomeTopWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - HomeTopWireframe
final class HomeTopWireframe: NSObject, HomeTopWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.homeTopViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! HomeTopViewController
        let interactor = HomeTopInteractor()
        let presenter = HomeTopPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = HomeTopWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showLatestNotificationsScreen() {
        navigator.navigate(screen: AppScreens.latestNotifications)
    }

    func showEditCommentScreen() {
        navigator.navigate(screen: AppScreens.editComment)
    }

    func showExchangeCoinListScreen() {
        navigator.navigate(screen: AppScreens.exchangeCoinList)
    }
}
