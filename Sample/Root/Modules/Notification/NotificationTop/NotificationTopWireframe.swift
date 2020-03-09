//
//  NotificationTopWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - NotificationTopWireframe
final class NotificationTopWireframe: NSObject, NotificationTopWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.notificationTopViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! NotificationTopViewController
        let interactor = NotificationTopInteractor()
        let presenter = NotificationTopPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = NotificationTopWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showLatestNotificationsScreen() {
        navigator.navigate(screen: AppScreens.latestNotifications)
    }

    func showNotificationCreationScreen() {
        navigator.navigate(screen: AppScreens.notificationCreation)
    }

    func showNotificationDetailScreen(_ loginUser: UserData, _ notificationData: NotificationData) {
        navigator.navigate(screen: AppScreens.notificationDetail, payload: (loginUser, notificationData))
    }
}
