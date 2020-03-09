//
//  NotificationDetailTableViewHeaderContentCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/02/04.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class NotificationDetailTableViewHeaderContentCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var labelContent: LinkLabel!
    @IBOutlet weak private var stackViewAttachments: UIStackView!
    @IBOutlet weak private var btnApprove: AppButton!
    @IBOutlet weak private var heightOfScrollView: NSLayoutConstraint!

    // MARK: - Variables

    var didLongPress: (() -> Void)?
    var didTapAttachment: ((AttachmentData) -> Void)?
    var didTapApprove: (() -> Void)?

    // MARK: - Initializer

    override func awakeFromNib() {
        super.awakeFromNib()
        btnApprove.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.didTapApprove?()
        }).disposed(by: self)
        labelContent.rx.longPressGesture().when(.began).subscribe(onNext: { [unowned self] _ in
            self.didLongPress?()
        }).disposed(by: self)
    }

    // MARK: - Methods

    func setData(_ loginUser: UserData, _ notification: NotificationData) {
        labelContent.text = notification.notification.attributes.content
        heightOfScrollView.constant = notification.notification.attributes.attachments.count == 0 ? 0 : 72
        let loginUserId = Int(loginUser.data.id)!
        btnApprove.isHidden = true
        if notification.sender.data.id != loginUser.data.id {
            if notification.notification.attributes.notReadersIds.contains(loginUserId) {
                // notReadersIdsを確認、そこに自分のidがあれば「未読かつ未承認」である
                btnApprove.isHidden = false
            } else if notification.notification.attributes.notApprovingUserIds.contains(loginUserId) {
                // なかったらnotApprovingUserIdsを確認、そこに自分のidがあれば「未承認」のみである。
                btnApprove.isHidden = false
            } else {
                btnApprove.isHidden = true
            }
            btnApprove.setTitle(notification.notification.attributes.approvalConfirmation ?? "", for: .normal)
        }
        stackViewAttachments.removeAllSubView()
        notification.notification.attributes.attachments.forEach { [unowned self] attachment in
            let view = AttachmentIconView()
            view.width(72)
            view.data = AttachmentData(
                id: attachment.id,
                name: attachment.name,
                url: attachment.url == nil ? nil : URL(string: attachment.url!),
                canDelete: false,
                canSelect: attachment.url != nil)
            view.didTap.subscribe(onNext: { [unowned self] data in
                self.didTapAttachment?(data)
            }).disposed(by: self)
            self.stackViewAttachments.addArrangedSubview(view)
        }
    }
}
