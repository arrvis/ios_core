//
//  NotificationListInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - NotificationListInteractor
final class NotificationListInteractor {

    // MARK: - Variables

    weak var output: NotificationListInteractorOutputInterface?
}

// MARK: - NotificationListInteractorInterface
extension NotificationListInteractor: NotificationListInteractorInterface {
}
