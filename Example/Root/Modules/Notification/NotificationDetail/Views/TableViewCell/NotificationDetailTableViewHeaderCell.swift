//
//  NotificationDetailTableViewHeaderCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/01/31.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import UIKit

final class NotificationDetailTableViewHeaderCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var labelTitle: AppLabel!
    @IBOutlet weak private var labelTime: AppLabel!
    @IBOutlet weak private var labelApprovalStatus: ApprovalStatusLabel!
    @IBOutlet weak private var btnIcon: UIButton!
    @IBOutlet weak private var labelName: AppLabel!
    @IBOutlet weak private var labelRole: AppLabel!
    @IBOutlet weak private var labelReadersCount: ReadersCountLabel!

    // MARK: - Variables

    var didTapUser: ((String) -> Void)?
    private var notification: NotificationData!

    // MARK: - Methods

    func setData(_ loginUser: UserData, _ notification: NotificationData) {
        self.notification = notification
        labelTitle.text = notification.notification.attributes.title
        if let publishedAt = notification.notification.attributes.publishedAtValue {
            labelTime.text = publishedAt.toString(R.string.localizable.dateFormatDateTime())
        } else {
            labelTime.text = R.string.localizable.draft()
        }
        if let approvingDeadlineAt = notification.notification.attributes.approvingDeadlineAtValue {
            labelTime.text = "\(labelTime.text!)\r\n\(approvingDeadlineAt.toString(R.string.localizable.dateTimeFormatApprovingDeadlineAt()))"
        }
        let loginUserId = Int(loginUser.data.id)!
        labelApprovalStatus.isHidden = true
        if notification.notification.attributes.isRequiredApproval {
             // 承認が必要なお知らせであったら、
             labelApprovalStatus.isHidden = false
            if notification.notification.attributes.notReadersIds.contains(loginUserId) {
                // notReadersIdsを確認、そこに自分のidがあれば「未読かつ未承認」である
                labelApprovalStatus.isApproved = false
            } else if notification.notification.attributes.notApprovingUserIds.contains(loginUserId) {
                // なかったらnotApprovingUserIdsを確認、そこに自分のidがあれば「未承認」のみである。
                labelApprovalStatus.isApproved = false
            } else {
                labelApprovalStatus.isApproved = true
            }
        }
        if let icon = notification.sender.data.attributes.icon {
            btnIcon.setImageWithUrlString(for: .normal, icon)
            btnIcon.imageView?.contentMode = .scaleAspectFill
        } else {
            btnIcon.setImage(nil, for: .normal)
        }
        btnIcon.isUserInteractionEnabled = notification.sender.data.id != loginUser.data.id
        labelName.text = notification.sender.data.attributes.fullName
        labelRole.text = notification.notification.attributes.authorDepartmentName
        labelReadersCount.text = R.string.localizable.formatReadersCount(notification.notification.attributes.readerIds.count.toNumberString())
    }

    // MARK: - Action
    @IBAction private func didTapIcon(_ sender: Any) {
        didTapUser?(notification.sender.data.id)
    }
}

final class ReadersCountLabel: AppLabel {

    override var textInsets: UIEdgeInsets? {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}
