//
//  GroupSettingTableViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/12/08.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift
import TinyConstraints

final class GroupSettingTableViewController: AppTableViewController {

    // MARK: - Outlets

    @IBOutlet weak private var switchNotification: UISwitch!
    @IBOutlet weak private var editGroupCell: UITableViewCell!

    // MARK: - Variables

    var didTapMemberList: Observable<Void> {
        return didTapMemberListSubject
    }
    private let didTapMemberListSubject = PublishSubject<Void>()

    var didTapEditGroup: Observable<Void> {
        return didTapEditGroupSubject
    }
    private let didTapEditGroupSubject = PublishSubject<Void>()

    var didNotificationEnabledChanged: Observable<Bool> {
        return didNotificationEnabledChangedSubject
    }
    private let didNotificationEnabledChangedSubject = PublishSubject<Bool>()

    var didTapUnsubscribeGroup: Observable<Void> {
        return didTapUnsubscribeGroupSubject
    }
    private let didTapUnsubscribeGroupSubject = PublishSubject<Void>()

    private var loginUser: UserData!
    private var group: GroupData!

    private var canUnsubscribe: Bool {
        return  group.isJoined && !group.group.isOwner(loginUser)
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        switchNotification.rx.isOn.changed.subscribe { [unowned self] event in
            self.didNotificationEnabledChangedSubject.onNext(event.element ?? false)
        }.disposed(by: self)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 && !canUnsubscribe {
            return 0
        }
        return 37
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 && !canUnsubscribe {
            return UIView()
        }
        let view = UIView()
        let label = AppLabel()
        label.appearanceType = AppLabel.AppearanceType.primary.rawValue
        label.font = AppStyles.fontBold.withSize(13)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        view.addSubview(label)
        label.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 0, left: 18, bottom: 7, right: 0))
        view.refreshFontSize()
        return view
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                didTapMemberListSubject.onNext(())
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                didTapEditGroupSubject.onNext(())
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                didTapUnsubscribeGroupSubject.onNext(())
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if indexPath.section == 2 {
            cell.isHidden = !canUnsubscribe
        } else if indexPath.section == 1 && indexPath.row == 2 {
            cell.isHidden = true
        }
        cell.refreshFontSize()
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        if cell.isHidden {
            return 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    // MARK: - Methods

    func showData(_ loginUser: UserData, _ group: GroupData) {
        self.loginUser = loginUser
        self.group = group
        if loginUser.role.isAdmin || group.group.isOwner(loginUser) {
            editGroupCell.alpha = 1
            editGroupCell.contentView.alpha = 1
            editGroupCell.isUserInteractionEnabled = true
        } else {
            editGroupCell.alpha = 0.5
            editGroupCell.contentView.alpha = 0.5
            editGroupCell.isUserInteractionEnabled = false
        }
    }
}
