//
//  GroupSettingViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - GroupSettingViewController
final class GroupSettingViewController: ViewBase {

    // MARK: - Variables

    private var presenter: GroupSettingPresenterInterface {
        return presenterInterface as! GroupSettingPresenterInterface
    }

    private var tableViewController: GroupSettingTableViewController!

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.group()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tableViewController = segue.destination as? GroupSettingTableViewController
        tableViewController?.didTapMemberList.subscribe(onNext: { [unowned self] _ in
            self.presenter.didTapMemberList()
        }).disposed(by: self)
        tableViewController?.didTapEditGroup.subscribe(onNext: { [unowned self] _ in
            self.presenter.didTapEditGroup()
        }).disposed(by: self)
        tableViewController?.didNotificationEnabledChanged.subscribe(onNext: { [unowned self] enabled in
            self.presenter.didChangeNotificationEnabled(enabled)
        }).disposed(by: self)
        tableViewController?.didTapUnsubscribeGroup.subscribe(onNext: { [unowned self] _ in
            self.presenter.didTapUnsubscribeGroup()
        }).disposed(by: self)
    }
}

// MARK: - GroupSettingViewInterface
extension GroupSettingViewController: GroupSettingViewInterface {

    func showData(_ loginUser: UserData, _ group: GroupData) {
        tableViewController.showData(loginUser, group)
    }
}
