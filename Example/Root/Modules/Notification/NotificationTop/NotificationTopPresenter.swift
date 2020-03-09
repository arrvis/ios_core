//
//  NotificationTopPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - NotificationTopPresenter
final class NotificationTopPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: NotificationTopInteractorInterface {
        return interactorInterface as! NotificationTopInteractorInterface
    }

    private weak var view: NotificationTopViewInterface? {
        return viewInterface as? NotificationTopViewInterface
    }

    private var wireframe: NotificationTopWireframeInterface {
        return wireframeInterface as! NotificationTopWireframeInterface
    }

    private var isFirstAppear = true
    private var loginUser: UserData!

    // MARK: - Life-Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstAppear {
            view?.showLoading()
        }
        interactor.fetchNotifications()
        isFirstAppear = false
    }
}

// MARK: - NotificationTopPresenterInterface
extension NotificationTopPresenter: NotificationTopPresenterInterface {

    func didTapLatestNotifications() {
        wireframe.showLatestNotificationsScreen()
    }

    func didTapNotificationCreation() {
        wireframe.showNotificationCreationScreen()
    }

    func didTapNotification(_ notificationData: NotificationData) {
        wireframe.showNotificationDetailScreen(loginUser, notificationData)
    }
}

// MARK: - NotificationTopInteractorOutputInterface
extension NotificationTopPresenter: NotificationTopInteractorOutputInterface {

    func fetchNotificationsCompleted(_ loginUser: UserData, _ notifications: [NotificationData]) {
        self.loginUser = loginUser
        view?.hideLoading()
        view?.showNotifications(loginUser, notifications)
    }
}
