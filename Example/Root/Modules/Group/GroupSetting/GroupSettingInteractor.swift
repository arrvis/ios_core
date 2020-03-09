//
//  GroupSettingInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - GroupSettingInteractor
final class GroupSettingInteractor {

    // MARK: - Variables

    weak var output: GroupSettingInteractorOutputInterface?
}

// MARK: - GroupSettingInteractorInterface
extension GroupSettingInteractor: GroupSettingInteractorInterface {

    func fetchLoginUser() {
        output?.fetchLoginUserCompleted(UserService.loginUser!)
    }

    func leaveGroup(_ group: GroupData) {
        GroupService.leaveGroup(group.group.id).subscribe(onNext: { [unowned self] _ in
            self.output?.leaveGroupCompleted()
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
