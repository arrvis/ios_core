//
//  NotificationDetailWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 27/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - NotificationDetailWireframe
final class NotificationDetailWireframe: NSObject, NotificationDetailWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.notificationDetailViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! NotificationDetailViewController
        let interactor = NotificationDetailInteractor()
        let presenter = NotificationDetailPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = NotificationDetailWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showEditNotificationScreen(_ notification: NotificationData) {
        navigator.navigate(screen: AppScreens.notificationCreation, payload: notification)
    }

    func showReportMessageScreen(_ notification: NotificationData, _ comment: NotificationCommentData) {
        navigator.navigate(screen: AppScreens.reportMessage, payload: (notification, comment))
    }
}
