//
//  UserProfileInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit

// MARK: - UserProfileInteractor
final class UserProfileInteractor {

    // MARK: - Variables

    weak var output: UserProfileInteractorOutputInterface?
}

// MARK: - UserProfileInteractorInterface
extension UserProfileInteractor: UserProfileInteractorInterface {

    func fetchUser(_ userId: String) {
        UserService.fetchUser(userId).subscribe(onNext: { [unowned self] ret in
            self.output?.fetchUserCompleted(ret)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
