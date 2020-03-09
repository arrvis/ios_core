//
//  GroupMemberListViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit
import TinyConstraints

// MARK: - GroupMemberListViewController
final class GroupMemberListViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var tableView: UITableView!

    // MARK: - Variables

    private var presenter: GroupMemberListPresenterInterface {
        return presenterInterface as! GroupMemberListPresenterInterface
    }

    private var group: GroupData!

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.groupMemberList()
        tableView.register(R.nib.groupMemberListTableViewCell)
        tableView.tableFooterView = UIView()
    }
}

// MARK: - GroupMemberListViewInterface
extension GroupMemberListViewController: GroupMemberListViewInterface {

    func showMembers(_ group: GroupData) {
        self.group = group
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension GroupMemberListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = AppLabel()
        label.appearanceType = AppLabel.AppearanceType.primary.rawValue
        label.font = AppStyles.fontBold.withSize(13)
        label.text = "メンバー \(group.users.count.toNumberString())人"
        view.addSubview(label)
        label.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 0, left: 18, bottom: 7, right: 0))
        view.refreshFontSize()
        return view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.groupMemberListTableViewCell, for: indexPath)!
        cell.refreshFontSize()
        cell.member = group.users[indexPath.row]
        cell.isOwner = group.group.isOwner(cell.member)
        cell.didTapUser = { [unowned self] userId in
            self.presenter.didTapUser(userId)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension GroupMemberListViewController: UITableViewDelegate {
}
