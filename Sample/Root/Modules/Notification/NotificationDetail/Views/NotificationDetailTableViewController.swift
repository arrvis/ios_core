//
//  NotificationDetailTableViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/28.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift
import TinyConstraints

final class NotificationDetailTableViewController: AppTableViewController {

    // MARK: - Variables

    var didLongPressContent: Observable<Void> {
        return didLongPressContentSubject
    }
    private let didLongPressContentSubject = PublishSubject<Void>()

    var didTapApproval: Observable<Void> {
        return didTapApprovalSubject
    }
    private let didTapApprovalSubject = PublishSubject<Void>()

    var didTapAttachment: Observable<AttachmentData> {
        return didTapAttachmentSubject
    }
    private let didTapAttachmentSubject = PublishSubject<AttachmentData>()

    var didTapUser: Observable<String> {
        return didTapUserSubject
    }
    private let didTapUserSubject = PublishSubject<String>()

    var didTapRemoveClap: Observable<NotificationCommentData> {
        return didTapRemoveClapSubject
    }
    private let didTapRemoveClapSubject = PublishSubject<NotificationCommentData>()

    var didTapAddClap: Observable<NotificationCommentData> {
        return didTapAddClapSubject
    }
    private let didTapAddClapSubject = PublishSubject<NotificationCommentData>()

    var didLongPress: Observable<NotificationCommentData> {
        return didLongPressSubject
    }
    private let didLongPressSubject = PublishSubject<NotificationCommentData>()

    var didReachBottom: Observable<Void> {
        return didReachBottomSubject
    }
    private let didReachBottomSubject = PublishSubject<Void>()

    private var loginUser: UserData!
    private var notification: NotificationData!
    private var comments = [NotificationCommentData]()

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(R.nib.notificationDetailTableViewHeaderCell)
        tableView.register(R.nib.notificationDetailTableViewHeaderContentCell)
        tableView.register(R.nib.notificationDetailTableViewMessageCell)
    }

    // MARK: - Methods

    func showNotification(_ loginUser: UserData, _ notification: NotificationData) {
        self.loginUser = loginUser
        self.notification = notification
        tableView.reloadData()
    }

    func reload(_ notification: NotificationData) {
        self.notification = notification
        tableView.reloadData()
    }

    func showComments(_ comments: [NotificationCommentData]) {
        self.comments = comments.sorted(by: { l, r -> Bool in
            return l.notificationComment.attributes.createdAtValue > r.notificationComment.attributes.createdAtValue
        })
        tableView.reloadData()
    }

    func showMoreComments(_ comments: [NotificationCommentData]) {
        self.comments += comments
        self.comments = self.comments.sorted(by: { l, r -> Bool in
            return l.notificationComment.attributes.createdAtValue > r.notificationComment.attributes.createdAtValue
        })
        tableView.reloadData()
    }

    func showSendComment(_ comment: NotificationCommentData) {
        comments.append(comment)
        comments = comments.sorted(by: { l, r -> Bool in
            return l.notificationComment.attributes.createdAtValue > r.notificationComment.attributes.createdAtValue
        })
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension NotificationDetailTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.notificationDetailTableViewHeaderCell, for: indexPath)!
                cell.refreshFontSize()
                cell.setData(loginUser, notification)
                cell.didTapUser = { [unowned self] userId in
                    self.didTapUserSubject.onNext(userId)
                }
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.notificationDetailTableViewHeaderContentCell, for: indexPath)!
                cell.refreshFontSize()
                cell.setData(loginUser, notification)
                cell.didLongPress = { [unowned self] in
                    self.didLongPressContentSubject.onNext(())
                }
                cell.didTapAttachment = { [unowned self] url in
                    self.didTapAttachmentSubject.onNext(url)
                }
                cell.didTapApprove = { [unowned self] in
                    self.didTapApprovalSubject.onNext(())
                }
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.notificationDetailTableViewMessageCell, for: indexPath)!
        cell.refreshFontSize()
        let comment = comments[indexPath.row]
        cell.setData(loginUser, comment)
        cell.isClapped = comment.notificationComment.attributes.clapperIds.contains(where: { "\($0)" == loginUser.data.id })
        cell.didTapUser = { [unowned self] in
            self.didTapUserSubject.onNext(comment.sender.data.id)
        }
        cell.didTapRemoveClap = { [unowned self] in
            self.didTapRemoveClapSubject.onNext(comment)
        }
        cell.didTapAddClap = {[unowned self] in
            self.didTapAddClapSubject.onNext(comment)
        }
        cell.didTapAttachment = { [unowned self] url in
            self.didTapAttachmentSubject.onNext(url)
        }
        cell.didLongPress = { [unowned self] in
            self.didLongPressSubject.onNext(comment)
        }
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension NotificationDetailTableViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isAtBottom {
            didReachBottomSubject.onNext(())
        }
    }
}
