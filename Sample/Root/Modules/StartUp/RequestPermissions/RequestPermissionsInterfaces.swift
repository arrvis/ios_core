//
//  RequestPermissionsInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore
import CoreLocation

protocol RequestPermissionsViewInterface: ViewInterface {
    func showRequestNotificationAuthorization()
    func showRequestLocationAuthorization()
}

protocol RequestPermissionsPresenterInterface: PresenterInterface {
    func didTapNext()
}

protocol RequestPermissionsInteractorInterface: InteractorInterface {
    func fetchNotificationAuthorizationStatus()
    func requestNotificationAuthorization()
    func fetchLocationAuthorizationStatus()
    func requestLocationAuthorization()
    func markAsRead()
}

protocol RequestPermissionsInteractorOutputInterface: InteractorOutputInterface {
    func fetchNotificationAuthorizationStatusCompleted(_ status: UNAuthorizationStatus)
    func requestNotificationAuthorizationCompleted()
    func fetchLocationAuthorizationStatusCompleted(_ status: CLAuthorizationStatus)
    func requestLocationAuthorizationCompleted()
    func markAsReadCompleted()
}

protocol RequestPermissionsWireframeInterface: WireframeInterface {
    func showWalkthroughScreen()
}
