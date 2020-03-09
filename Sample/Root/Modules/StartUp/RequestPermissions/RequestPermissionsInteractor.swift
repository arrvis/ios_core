//
//  RequestPermissionsInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore
import RxSwift

// MARK: - RequestPermissionsInteractor
final class RequestPermissionsInteractor {

    // MARK: - Variables

    weak var output: RequestPermissionsInteractorOutputInterface?
}

// MARK: - RequestPermissionsInteractorInterface
extension RequestPermissionsInteractor: RequestPermissionsInteractorInterface {

    func fetchNotificationAuthorizationStatus() {
        NotificationService.fetchAuthorizationStatus()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] status in
                self.output?.fetchNotificationAuthorizationStatusCompleted(status)
            }, onError: { [unowned self] error in
                self.output?.handleError(error, nil)
            }).disposed(by: self)
    }

    func requestNotificationAuthorization() {
        NotificationService.requestAuthorization()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                NotificationService.requestDeviceToken().subscribe().disposed(by: self)
                self.output?.requestNotificationAuthorizationCompleted()
            }, onError: { [unowned self] error in
                self.output?.handleError(error, nil)
            }).disposed(by: self)
    }

    func fetchLocationAuthorizationStatus() {
        LocationService.fetchAuthorizationStatus()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] status in
                self.output?.fetchLocationAuthorizationStatusCompleted(status)
            }).disposed(by: self)
    }

    func requestLocationAuthorization() {
        LocationService.requestAuthorization(true)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                self.output?.requestLocationAuthorizationCompleted()
            }).disposed(by: self)
    }

    func markAsRead() {
        UserService.didDisplayRequestPermissions = true
        output?.markAsReadCompleted()
    }
}
