//
//  SelectGroupInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 18/01/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

// MARK: - SelectGroupInteractor
final class SelectGroupInteractor {

    // MARK: - Variables

    weak var output: SelectGroupInteractorOutputInterface?
}

// MARK: - SelectGroupInteractorInterface
extension SelectGroupInteractor: SelectGroupInteractorInterface {

    func fetchGroups() {
        GroupService.fetchGroups().subscribe(onNext: { [unowned self] ret in
            self.output?.fetchGroupsCompleted(ret)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
