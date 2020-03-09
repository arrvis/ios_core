//
//  MoreTopWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - MoreTopWireframe
final class MoreTopWireframe: NSObject, MoreTopWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.moreTopViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! MoreTopViewController
        let interactor = MoreTopInteractor()
        let presenter = MoreTopPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = MoreTopWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showLatestNotificationsScreen() {
        navigator.navigate(screen: AppScreens.latestNotifications)
    }

    func showHelpScreen() {
        navigator.navigate(screen: AppScreens.help)
    }

    func showChangeTextSizeScreen() {
        navigator.navigate(screen: AppScreens.selectFontSize, fromRoot: true)
    }

    func showTopScreen() {
        navigator.navigate(screen: AppScreens.top)
    }
}
