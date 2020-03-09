//
//  NotificationTopInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol NotificationTopViewInterface: ViewInterface {
    func showNotifications(_ loginUser: UserData, _ notifications: [NotificationData])
}

protocol NotificationTopPresenterInterface: PresenterInterface {
    func didTapLatestNotifications()
    func didTapNotificationCreation()
    func didTapNotification(_ notificationData: NotificationData)
}

protocol NotificationTopInteractorInterface: InteractorInterface {
    func fetchNotifications()
}

protocol NotificationTopInteractorOutputInterface: InteractorOutputInterface {
    func fetchNotificationsCompleted(_ loginUser: UserData, _ notifications: [NotificationData])
}

protocol NotificationTopWireframeInterface: WireframeInterface {
    func showLatestNotificationsScreen()
    func showNotificationCreationScreen()
    func showNotificationDetailScreen(_ loginUser: UserData, _ notificationData: NotificationData)
}
