//
//  GroupSettingPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - GroupSettingPresenter
final class GroupSettingPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: GroupSettingInteractorInterface {
        return interactorInterface as! GroupSettingInteractorInterface
    }

    private weak var view: GroupSettingViewInterface? {
        return viewInterface as? GroupSettingViewInterface
    }

    private var wireframe: GroupSettingWireframeInterface {
        return wireframeInterface as! GroupSettingWireframeInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchLoginUser()
    }

    override func onBackFromNext(_ result: Any?) {
        if let edited = result as? GroupData {
            payload = edited
        }
    }
}

// MARK: - GroupSettingPresenterInterface
extension GroupSettingPresenter: GroupSettingPresenterInterface {

    func didTapMemberList() {
        wireframe.showGroupMemberListScreen(payload as! GroupData)
    }

    func didTapEditGroup() {
        wireframe.showEditGroupScreen(payload as! GroupData)
    }

    func didChangeNotificationEnabled(_ enabled: Bool) {
        view?.showOkAlert(nil, "TODO: 未実装", "OK", {})
    }

    func didTapUnsubscribeGroup() {
        view?.showConfirmAlert(nil, R.string.localizable.alertMessageConfirmLeaveGroup(), R.string.localizable.ok(), { [unowned self] in
            self.view?.showLoading()
            self.interactor.leaveGroup(self.payload as! GroupData)
        })
    }
}

// MARK: - GroupSettingInteractorOutputInterface
extension GroupSettingPresenter: GroupSettingInteractorOutputInterface {

    func fetchLoginUserCompleted(_ loginUser: UserData) {
        view?.showData(loginUser, payload as! GroupData)
    }

    func leaveGroupCompleted() {
        view?.hideLoading()
        wireframe.popToRootScreen()
    }
}
