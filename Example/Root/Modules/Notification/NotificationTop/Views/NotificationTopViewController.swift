//
//  NotificationTopViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - NotificationTopViewController
final class NotificationTopViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var tableView: UITableView!

    // MARK: - Variables

    private var presenter: NotificationTopPresenterInterface {
        return presenterInterface as! NotificationTopPresenterInterface
    }

    private var loginUser: UserData!
    private var notifications = [NotificationData]()

    // MARK: - Overrides

    override func didTapLeftBarButtonItem(_ index: Int) {
        presenter.didTapLatestNotifications()
    }

    override func didTapRightBarButtonItem(_ index: Int) {
        presenter.didTapNotificationCreation()
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.notification()
        configureRightItemsToBlue()
        tableView.register(R.nib.notificationTopTableViewCell)
        tableView.tableFooterView = UIView()
    }
}

// MARK: - NotificationTopViewInterface
extension NotificationTopViewController: NotificationTopViewInterface {

    func showNotifications(_ loginUser: UserData, _ notifications: [NotificationData]) {
        self.loginUser = loginUser
        self.notifications = notifications
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension NotificationTopViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.notificationTopTableViewCell, for: indexPath)!
        cell.refreshFontSize()
        cell.setData(loginUser, notifications[indexPath.row])
        cell.didTapUser = { [unowned self] userId in
            self.presenter.didTapUser(userId)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationTopViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didTapNotification(notifications[indexPath.row])
    }
}
