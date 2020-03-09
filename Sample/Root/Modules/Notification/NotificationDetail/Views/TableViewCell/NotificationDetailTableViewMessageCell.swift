//
//  NotificationDetailTableViewMessageCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/01/31.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift

final class NotificationDetailTableViewMessageCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var btnIcon: UIButton!
    @IBOutlet weak private var labelName: AppLabel!
    @IBOutlet weak private var labelTime: AppLabel!
    @IBOutlet weak private var stackViewClappers: UIStackView!
    @IBOutlet weak private var btnClappCount: AppButton!
    @IBOutlet weak private var btnAddClap: AppButton!
    @IBOutlet weak private var labelMessage: AppLabel!
    @IBOutlet weak private var scrollViewAttachments: UIScrollView!
    @IBOutlet weak private var stackViewAttachments: UIStackView!
    @IBOutlet weak private var heightOfAttachments: NSLayoutConstraint!

    // MARK: - Variables

    var isClapped = false {
        didSet {
            refreshClapButtons()
        }
    }

    var didTapUser: (() -> Void)?
    var didTapRemoveClap: (() -> Void)?
    var didTapAddClap: (() -> Void)?
    var didTapAttachment: ((AttachmentData) -> Void)?
    var didLongPress: (() -> Void)?

    private var isLoginUserComment = false {
        didSet {
            btnAddClap.isHidden = isLoginUserComment
            btnClappCount.isUserInteractionEnabled = !isLoginUserComment
        }
    }
    private var clappCount = 0

    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initImpl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initImpl()
    }

    private func initImpl() {
        contentView.rx.longPressGesture().when(.began).subscribe(onNext: { [unowned self] _ in
            self.didLongPress?()
        }).disposed(by: disposeBag)
    }

    // MARK: - Methods

    func setData(_ loginUser: UserData, _ comment: NotificationCommentData) {
        if let icon = comment.sender.data.attributes.icon {
            btnIcon.setImageWithUrlString(for: .normal, icon)
            btnIcon.imageView?.contentMode = .scaleAspectFill
        } else {
            btnIcon.setImage(nil, for: .normal)
        }
        btnIcon.isUserInteractionEnabled = comment.sender.data.id != loginUser.data.id
        labelName.text = comment.sender.data.attributes.fullName
        labelTime.text = comment.notificationComment.attributes.createdAtValue.toString(R.string.localizable.dateFormatDateTime())
        labelMessage.text = comment.notificationComment.attributes.content
        isLoginUserComment = comment.sender.data.id == loginUser.data.id
        clappCount = comment.notificationComment.attributes.clapperIds.count
        refreshClapButtons()
        heightOfAttachments.constant = comment.notificationComment.attributes.attachments.count == 0 && comment.notificationComment.attributes.stamp == nil ? 0 : 72
        stackViewAttachments.isHidden = comment.notificationComment.attributes.attachments.count == 0 && comment.notificationComment.attributes.stamp == nil
        stackViewAttachments.removeAllSubView()
        comment.notificationComment.attributes.attachments.forEach { [unowned self] attachment in
            let view = AttachmentIconView()
            view.width(72)
            view.data = AttachmentData(
                id: attachment.id,
                name: attachment.name,
                url: attachment.url == nil ? nil : URL(string: attachment.url!),
                canDelete: false,
                canSelect: attachment.url != nil)
            view.imageContentMode = .scaleAspectFill
            view.didTap.subscribe(onNext: { [unowned self] data in
                self.didTapAttachment?(data)
            }).disposed(by: self)
            self.stackViewAttachments.addArrangedSubview(view)
         }
        if let stamp = comment.notificationComment.attributes.stamp, !stamp.isEmpty {
            let view = AttachmentIconView()
            view.width(72)
            view.data = AttachmentData(
                id: nil,
                name: stamp,
                url: Stamps.fromId(stamp),
                canDelete: false,
                canSelect: false)
            view.imageContentMode = .scaleAspectFit
            stackViewAttachments.addArrangedSubview(view)
        }
    }

    private func refreshClapButtons() {
        btnClappCount.setTitle(R.string.localizable.formatClapCount(clappCount.toNumberString()), for: .normal)
        if !isLoginUserComment {
            btnAddClap.isHidden = isClapped
            btnClappCount.isUserInteractionEnabled = isClapped
        }
        if isClapped {
            btnClappCount.setTitleColor(AppStyles.colorBlue, for: .normal)
        } else {
            btnClappCount.setTitleColor(AppStyles.colorDarkGray, for: .normal)
        }
    }

    // MARK: - Action

    @IBAction private func didTapIcon(_ sender: Any) {
        didTapUser?()
    }

    @IBAction private func didTapClapCount(_ sender: Any) {
        didTapRemoveClap?()
        clappCount -= 1
        isClapped = false
    }

    @IBAction private func didTapAddClap(_ sender: Any) {
        didTapAddClap?()
        clappCount += 1
        isClapped = true
    }
}
