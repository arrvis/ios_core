//
//  HomeTopInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - HomeTopInteractor
final class HomeTopInteractor {

    // MARK: - Variables

    weak var output: HomeTopInteractorOutputInterface?
}

// MARK: - HomeTopInteractorInterface
extension HomeTopInteractor: HomeTopInteractorInterface {

    func fetchLoginUser() {
        UserService.refreshLoginUser().subscribe(onNext: { [unowned self] _ in
            self.output?.fetchLoginUserCompleted(UserService.loginUser!)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func updateIcon(_ image: UIImage?) {
        UserService.updateIcon(image).subscribe(onNext: { [unowned self] ret in
            self.output?.updateIconCompleted(ret)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
