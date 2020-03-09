//
//  NotificationListPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - NotificationListPresenter
final class NotificationListPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: NotificationListInteractorInterface {
        return interactorInterface as! NotificationListInteractorInterface
    }

    private weak var view: NotificationListViewInterface? {
        return viewInterface as? NotificationListViewInterface
    }

    private var wireframe: NotificationListWireframeInterface {
        return wireframeInterface as! NotificationListWireframeInterface
    }
}

// MARK: - NotificationListPresenterInterface
extension NotificationListPresenter: NotificationListPresenterInterface {
}

// MARK: - NotificationListInteractorOutputInterface
extension NotificationListPresenter: NotificationListInteractorOutputInterface {
}
