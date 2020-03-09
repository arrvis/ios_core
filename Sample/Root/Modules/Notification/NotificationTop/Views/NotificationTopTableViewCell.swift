//
//  NotificationTopTableViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/01/22.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import UIKit

final class NotificationTopTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var labelTime: AppLabel!
    @IBOutlet weak private var labelCommentedCount: CommentedCountLabel!
    @IBOutlet weak private var labelTitle: AppLabel!
    @IBOutlet weak private var labelRequiredRead: AppLabel!
    @IBOutlet weak private var btnIcon: AppButton!
    @IBOutlet weak private var labelName: AppLabel!
    @IBOutlet weak private var labelApprovalStatus: ApprovalStatusLabel!
    @IBOutlet weak private var labelReadStatus: ReadStatusLabel!

    // MARK: - Variables

    var didTapUser: ((String) -> Void)?
    private var notification: NotificationData!

    // MARK: - Methods

    func setData(_ loginUser: UserData, _ notification: NotificationData) {
        self.notification = notification
        if let publishedAt = notification.notification.attributes.publishedAtValue {
            labelTime.text = publishedAt.toString(R.string.localizable.dateFormatDateTime())
        } else {
            labelTime.text = R.string.localizable.draft()
        }
        labelCommentedCount.text = R.string.localizable.formatCommentCount(notification.notification.attributes.commentedCount.toNumberString())
        labelTitle.text = notification.notification.attributes.title
        labelRequiredRead.isHidden = !notification.notification.attributes.isRequiredRead
        if let icon = notification.sender.data.attributes.icon {
            btnIcon.setImageWithUrlString(for: .normal, icon)
            btnIcon.imageView?.contentMode = .scaleAspectFill
        } else {
            btnIcon.setImage(nil, for: .normal)
        }
        btnIcon.isUserInteractionEnabled = notification.sender.data.id != loginUser.data.id
        labelName.text = notification.sender.data.attributes.fullName
        if notification.sender.data.id == loginUser.data.id {
            // 自分で投稿したお知らせは何も表示しない
            labelApprovalStatus.isHidden = true
            labelReadStatus.isHidden = true
            labelRequiredRead.isHidden = true
        } else {
            let loginUserId = Int(loginUser.data.id)!
            labelApprovalStatus.isHidden = true
            if notification.notification.attributes.isRequiredApproval {
                 // 承認が必要なお知らせであったら、
                 labelApprovalStatus.isHidden = false
                if notification.notification.attributes.notReadersIds.contains(loginUserId) {
                    // notReadersIdsを確認、そこに自分のidがあれば「未読かつ未承認」である
                    labelReadStatus.isRead = false
                    labelApprovalStatus.isApproved = false
                } else if notification.notification.attributes.notApprovingUserIds.contains(loginUserId) {
                    // なかったらnotApprovingUserIdsを確認、そこに自分のidがあれば「未承認」のみである。
                    labelReadStatus.isRead = true
                    labelRequiredRead.isHidden = true
                    labelApprovalStatus.isApproved = false
                } else {
                    labelReadStatus.isRead = true
                    labelRequiredRead.isHidden = true
                    labelApprovalStatus.isApproved = true
                }
            } else {
                // 承認不要のお知らせであったら既読未読の確認だけ行う
                if notification.notification.attributes.notReadersIds.contains(loginUserId) {
                    labelReadStatus.isRead = false
                } else {
                    labelReadStatus.isRead = true
                    labelRequiredRead.isHidden = true
                }
            }
        }
    }

    // MARK: - Action

    @IBAction private func didTapIcon(_ sender: Any) {
        didTapUser?(notification.sender.data.id)
    }
}

final class CommentedCountLabel: AppLabel {

    override var textInsets: UIEdgeInsets? {
        return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    }
}
