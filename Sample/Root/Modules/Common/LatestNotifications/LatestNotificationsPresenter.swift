//
//  LatestNotificationsPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 23/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - LatestNotificationsPresenter
final class LatestNotificationsPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: LatestNotificationsInteractorInterface {
        return interactorInterface as! LatestNotificationsInteractorInterface
    }

    private weak var view: LatestNotificationsViewInterface? {
        return viewInterface as? LatestNotificationsViewInterface
    }

    private var wireframe: LatestNotificationsWireframeInterface {
        return wireframeInterface as! LatestNotificationsWireframeInterface
    }
}

// MARK: - LatestNotificationsPresenterInterface
extension LatestNotificationsPresenter: LatestNotificationsPresenterInterface {
}

// MARK: - LatestNotificationsInteractorOutputInterface
extension LatestNotificationsPresenter: LatestNotificationsInteractorOutputInterface {
}
