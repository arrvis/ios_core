//
//  NotificationListWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - NotificationListWireframe
final class NotificationListWireframe: NotificationListWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.notificationListViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = NotificationListInteractor()
        let presenter = NotificationListPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = NotificationListWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
