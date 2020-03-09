//
//  MoreTopPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore
import SwiftEventBus

// MARK: - MoreTopPresenter
final class MoreTopPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: MoreTopInteractorInterface {
        return interactorInterface as! MoreTopInteractorInterface
    }

    private weak var view: MoreTopViewInterface? {
        return viewInterface as? MoreTopViewInterface
    }

    private var wireframe: MoreTopWireframeInterface {
        return wireframeInterface as! MoreTopWireframeInterface
    }

    // MARK: Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = SwiftEventBus.onMainThread(self, SystemBusEvents.applicationWillEnterForeground) { [unowned self] _ in
            self.interactor.fetchNotificationEnabled()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.fetchLoginUser()
        interactor.fetchNotificationEnabled()
    }
}

// MARK: - MoreTopPresenterInterface
extension MoreTopPresenter: MoreTopPresenterInterface {

    func didTapLatestNotifications() {
        wireframe.showLatestNotificationsScreen()
    }

    func didTapMenu() {
        wireframe.showActionSheet(
            nil,
            nil,
            [
                UIAlertAction(
                    title: R.string.localizable.logout(),
                    style: .default,
                    handler: { [unowned self] _ in
                        self.view?.showConfirmAlert(nil, R.string.localizable.alertMessageConfirmLogout(), R.string.localizable.logout(), {
                            self.view?.showLoading()
                            self.interactor.logout()
                        })
                })
            ],
            R.string.localizable.cancel())
    }

    func didTapHelp() {
        wireframe.showHelpScreen()
    }

    func didTapChangeTextSize() {
        wireframe.showChangeTextSizeScreen()
    }

    func didTapNotificationEnabled() {
        wireframe.showAppSettings()
    }
}

// MARK: - MoreTopInteractorOutputInterface
extension MoreTopPresenter: MoreTopInteractorOutputInterface {

    func fetchLoginUserCompleted(_ loginUser: UserData) {
        view?.showLoginUser(loginUser)
    }

    func fetchNotificationEnabledCompleted(_ enabled: Bool) {
        view?.showNotificationEnabled(enabled)
    }

    func logoutCompleted() {
        view?.hideLoading()
        wireframe.showTopScreen()
    }
}
