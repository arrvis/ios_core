//
//  GroupCreationInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - GroupCreationInteractor
final class GroupCreationInteractor {

    // MARK: - Variables

    weak var output: GroupCreationInteractorOutputInterface?
}

// MARK: - GroupCreationInteractorInterface
extension GroupCreationInteractor: GroupCreationInteractorInterface {

    func fetchLoginUser() {
        output?.fetchLoginUserCompleted(UserService.loginUser!)
    }

    func createGroup(_ icon: UIImage?, _ members: [UserData], _ groupName: String) {
        GroupService.createGroup(groupName, icon, members).subscribe(onNext: { [unowned self] _ in
            self.output?.createGroupCompleted()
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func editGroup(_ group: GroupData, _ icon: UIImage?, _ members: [UserData], _ groupName: String) {
        GroupService.editGroup(group.group.id, groupName, icon, members).subscribe(onNext: { [unowned self] ret in
            self.output?.editGroupCompleted(ret)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
