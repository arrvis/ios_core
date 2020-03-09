//
//  GroupTopPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - GroupTopPresenter
final class GroupTopPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: GroupTopInteractorInterface {
        return interactorInterface as! GroupTopInteractorInterface
    }

    private weak var view: GroupTopViewInterface? {
        return viewInterface as? GroupTopViewInterface
    }

    private var wireframe: GroupTopWireframeInterface {
        return wireframeInterface as! GroupTopWireframeInterface
    }

    private var isFirstAppear = true

    // MARK: - Life-Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstAppear {
            view?.showLoading()
        }
        interactor.fetchLoginUser()
        interactor.fetchGroupsWithData(isFirstAppear)
        isFirstAppear = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor.unsubscribe()
    }
}

// MARK: - GroupTopPresenterInterface
extension GroupTopPresenter: GroupTopPresenterInterface {

    func didTapLatestNotifications() {
        wireframe.showLatestNotificationsScreen()
    }

    func didTapGroupCreation() {
        wireframe.showSelectMemberScreen()
    }

    func didTapGroup(_ group: GroupData) {
        wireframe.showGroupChatScreen(group)
    }
}

// MARK: - GroupTopInteractorOutputInterface
extension GroupTopPresenter: GroupTopInteractorOutputInterface {

    func fetchLoginUserCompleted(_ loginUser: UserData) {
        view?.showLoginUser(loginUser)
    }

    func fetchGroupsWithDataCompleted(_ groups: [GroupData]) {
        view?.hideLoading()
        view?.showGroups(groups)
    }
}
