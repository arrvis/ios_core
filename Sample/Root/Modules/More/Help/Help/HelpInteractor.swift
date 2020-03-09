//
//  HelpInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 04/03/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

// MARK: - HelpInteractor
final class HelpInteractor {

    // MARK: - Variables

    weak var output: HelpInteractorOutputInterface?
}

// MARK: - HelpInteractorInterface
extension HelpInteractor: HelpInteractorInterface {

    func fetchHelps() {
        HelpService.fetchHelps().subscribe(onNext: { [unowned self] ret in
            self.output?.fetchHelpsCompleted(ret)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
