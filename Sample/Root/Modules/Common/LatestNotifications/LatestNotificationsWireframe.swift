//
//  LatestNotificationsWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 23/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - LatestNotificationsWireframe
final class LatestNotificationsWireframe: NSObject, LatestNotificationsWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.latestNotificationsViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! LatestNotificationsViewController
        let interactor = LatestNotificationsInteractor()
        let presenter = LatestNotificationsPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = LatestNotificationsWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
