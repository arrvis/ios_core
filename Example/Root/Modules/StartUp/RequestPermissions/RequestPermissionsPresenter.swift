//
//  RequestPermissionsPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore
import CoreLocation

// MARK: - RequestPermissionsPresenter
final class RequestPermissionsPresenter: PresenterBase {

    // MARK: - Const

    private enum RequestStep {
        case notification
        case location
    }

    // MARK: - Variables

    private var interactor: RequestPermissionsInteractorInterface {
        return interactorInterface as! RequestPermissionsInteractorInterface
    }

    private weak var view: RequestPermissionsViewInterface? {
        return viewInterface as? RequestPermissionsViewInterface
    }

    private var wireframe: RequestPermissionsWireframeInterface {
        return wireframeInterface as! RequestPermissionsWireframeInterface
    }

    private var requestStep = RequestStep.notification {
        didSet {
            switch requestStep {
            case .notification:
                view?.showRequestNotificationAuthorization()
            case .location:
                view?.showRequestLocationAuthorization()
            }
        }
    }

    // MARK: - Life-cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchNotificationAuthorizationStatus()
    }
}

// MARK: - RequestPermissionsPresenterInterface
extension RequestPermissionsPresenter: RequestPermissionsPresenterInterface {

    func didTapNext() {
        switch requestStep {
        case .notification:
            interactor.requestNotificationAuthorization()
        case .location:
            interactor.requestLocationAuthorization()
        }
    }
}

// MARK: - RequestPermissionsInteractorOutputInterface
extension RequestPermissionsPresenter: RequestPermissionsInteractorOutputInterface {

    func fetchNotificationAuthorizationStatusCompleted(_ status: UNAuthorizationStatus) {
        if status == .notDetermined {
            requestStep = .notification
        } else {
            interactor.fetchLocationAuthorizationStatus()
        }
    }

    func requestNotificationAuthorizationCompleted() {
        interactor.fetchLocationAuthorizationStatus()
    }

    func fetchLocationAuthorizationStatusCompleted(_ status: CLAuthorizationStatus) {
        if status == .notDetermined {
            requestStep = .location
        } else {
            interactor.markAsRead()
        }
    }

    func requestLocationAuthorizationCompleted() {
        interactor.markAsRead()
    }

    func markAsReadCompleted() {
        wireframe.showWalkthroughScreen()
    }
}
