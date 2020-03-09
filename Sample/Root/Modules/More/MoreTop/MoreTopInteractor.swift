//
//  MoreTopInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore
import RxSwift

// MARK: - MoreTopInteractor
final class MoreTopInteractor {

    // MARK: - Variables

    weak var output: MoreTopInteractorOutputInterface?
}

// MARK: - MoreTopInteractorInterface
extension MoreTopInteractor: MoreTopInteractorInterface {

    func fetchLoginUser() {
        output?.fetchLoginUserCompleted(UserService.loginUser!)
    }

    func fetchNotificationEnabled() {
        NotificationService.fetchAuthorizationStatus()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] status in
                self.output?.fetchNotificationEnabledCompleted(status == .authorized)
            }).disposed(by: self)
    }

    func logout() {
        UserService.signOut().subscribe(onNext: { _ in
            self.output?.logoutCompleted()
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
