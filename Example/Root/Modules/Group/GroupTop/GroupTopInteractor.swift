//
//  GroupTopInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - GroupTopInteractor
final class GroupTopInteractor {

    // MARK: - Variables

    weak var output: GroupTopInteractorOutputInterface?

    private var groups = [GroupData]()
}

// MARK: - GroupTopInteractorInterface
extension GroupTopInteractor: GroupTopInteractorInterface {

    func unsubscribe() {
        groups.forEach { group in
            GroupService.unsubscribeGroupMessage(group)
        }
    }

    func fetchLoginUser() {
        output?.fetchLoginUserCompleted(UserService.loginUser!)
    }

    func fetchGroupsWithData(_ startSubscribe: Bool) {
        GroupService.fetchGroupsWithData().subscribe(onNext: { [unowned self] response in
            self.groups = response
            if startSubscribe {
                response.forEach { [unowned self] group in
                    GroupService.subscribeGroupMessage(group) { [unowned self] _ in
                        self.fetchGroupsWithData(false)
                    }
                }
            }
            self.output?.fetchGroupsWithDataCompleted(response)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
