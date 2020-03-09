//
//  LoginInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - LoginInteractor
final class LoginInteractor {

    // MARK: - Variables

    weak var output: LoginInteractorOutputInterface?
}

// MARK: - LoginInteractorInterface
extension LoginInteractor: LoginInteractorInterface {

    func login(_ id: String, _ password: String) {
        UserService.signIn(id, password).subscribe(onNext: { [unowned self] _ in
            self.output?.onLoginSucceeded()
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
