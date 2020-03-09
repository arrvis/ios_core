//
//  SplashInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import RxSwift

// MARK: - SplashInteractor
final class SplashInteractor {

    // MARK: - Variables

    weak var output: SplashInteractorOutputInterface?
}

// MARK: - SplashInteractorInterface
extension SplashInteractor: SplashInteractorInterface {

    func fetchIsSignedIn() {
        output?.fetchIsSignedInCompleted(
            UserService.isSignedIn,
            UserService.didDisplayRequestPermissions,
            UserService.didDisplayWalkthrough
        )
    }
}
