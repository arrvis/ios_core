//
//  MoreTopViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - MoreTopViewController
final class MoreTopViewController: ViewBase {

    // MARK: - Variables

    private var presenter: MoreTopPresenterInterface {
        return presenterInterface as! MoreTopPresenterInterface
    }

    private var tableViewController: MoreTopTableViewController?

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.more()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tableViewController = segue.destination as? MoreTopTableViewController
        tableViewController?.didTapHelp.subscribe(onNext: { [unowned self] _ in
            self.presenter.didTapHelp()
        }).disposed(by: self)
        tableViewController?.didTapChangeTextSize.subscribe(onNext: { [unowned self] _ in
            self.presenter.didTapChangeTextSize()
        }).disposed(by: self)
        tableViewController?.didTapNotificationEnabled.subscribe(onNext: { [unowned self] _ in
            self.presenter.didTapNotificationEnabled()
        }).disposed(by: self)
    }

    // MARK: - Overrides

    override func didTapLeftBarButtonItem(_ index: Int) {
        presenter.didTapLatestNotifications()
    }

    override func didTapRightBarButtonItem(_ index: Int) {
        presenter.didTapMenu()
    }
}

// MARK: - MoreTopViewInterface
extension MoreTopViewController: MoreTopViewInterface {

    func showLoginUser(_ loginUser: UserData) {
        tableViewController?.showLoginUser(loginUser)
    }

    func showNotificationEnabled(_ enabled: Bool) {
        tableViewController?.showNotificationEnabled(enabled)
    }
}
