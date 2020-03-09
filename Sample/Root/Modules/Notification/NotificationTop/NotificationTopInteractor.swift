//
//  NotificationTopInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - NotificationTopInteractor
final class NotificationTopInteractor {

    // MARK: - Variables

    weak var output: NotificationTopInteractorOutputInterface?
}

// MARK: - NotificationTopInteractorInterface
extension NotificationTopInteractor: NotificationTopInteractorInterface {

    func fetchNotifications() {
        NotificationsService.fetchNotifications().subscribe(onNext: { [unowned self] ret in
            self.output?.fetchNotificationsCompleted(UserService.loginUser!, ret)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
