//
//  ReceivedMessageTableViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/12/01.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

final class ReceivedMessageTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var btnIcon: UIButton!
    @IBOutlet weak private var labelName: AppLabel!
    @IBOutlet weak private var labelContent: LinkLabel!
    @IBOutlet weak private var attachmentIconView: AttachmentIconView!
    @IBOutlet weak private var labelTime: AppLabel!
    @IBOutlet weak private var labelReadersCount: AppLabel!
    @IBOutlet weak private var btnClappCount: AppButton!
    @IBOutlet weak private var btnAddClap: AppButton!

    @IBOutlet private var topOfLabelContent: NSLayoutConstraint!
    @IBOutlet private var bottomOfLabelContent: NSLayoutConstraint!
    @IBOutlet private var topOfBtnAttachment: NSLayoutConstraint!
    @IBOutlet private var bottomOfBtnAttachment: NSLayoutConstraint!
    @IBOutlet private var heightOfAttachment: NSLayoutConstraint!
    @IBOutlet private var trailingOfAttachment: NSLayoutConstraint!
    @IBOutlet private var trailingOfClap: NSLayoutConstraint!

    // MARK: - Variables

    var userIcon: String? {
        didSet {
            if let icon = userIcon {
                btnIcon.setImageWithUrlString(for: .normal, icon)
                btnIcon.imageView?.contentMode = .scaleAspectFill
            } else {
                btnIcon.setImage(nil, for: .normal)
            }
        }
    }

    var userName: String! {
        didSet {
            labelName.text = userName
        }
    }

    var message: Message! {
        didSet {
            if let attachment = message.attributes.attachments.first {
                attachmentIconView.isHidden = false
                topOfBtnAttachment.isActive = true
                bottomOfBtnAttachment.isActive = true

                labelContent.isHidden = true
                topOfLabelContent.isActive = false
                bottomOfLabelContent.isActive = false

                attachmentIconView.data = AttachmentData(
                    id: attachment.id,
                    name: attachment.name,
                    url: attachment.url == nil ? nil : URL(string: attachment.url!),
                    canDelete: false,
                    canSelect: attachment.url != nil)
                if attachmentIconView.type == .document {
                    heightOfAttachment.constant = 72
                    trailingOfAttachment.constant = 286
                    bottomOfBtnAttachment.constant = 24
                    trailingOfClap.constant = 286
                } else {
                    heightOfAttachment.constant = 285
                    trailingOfAttachment.constant = 74
                    bottomOfBtnAttachment.constant = 14
                    trailingOfClap.constant = 86
                }
            } else if let stamp = message.attributes.stamp {
                attachmentIconView.isHidden = false
                topOfBtnAttachment.isActive = true
                bottomOfBtnAttachment.isActive = true

                labelContent.isHidden = true
                topOfLabelContent.isActive = false
                bottomOfLabelContent.isActive = false

                attachmentIconView.data = AttachmentData(
                    id: nil,
                    name: stamp,
                    url: Stamps.fromId(stamp),
                    canDelete: false,
                    canSelect: false)
                attachmentIconView.imageContentMode = .scaleAspectFit

                heightOfAttachment.constant = 102
                trailingOfAttachment.constant = 256
                bottomOfBtnAttachment.constant = 24
                trailingOfClap.constant = 256
            } else {
                labelContent.isHidden = false
                topOfLabelContent.isActive = true
                bottomOfLabelContent.isActive = true

                attachmentIconView.isHidden = true
                topOfBtnAttachment.isActive = false
                bottomOfBtnAttachment.isActive = false

                labelContent.text = message.attributes.content

                trailingOfAttachment.constant = 74
                trailingOfClap.constant = 86
            }
            labelTime.text = message.attributes.createdAtValue.toString(R.string.localizable.dateFormatTime())
            labelReadersCount.text = R.string.localizable.formatReadersCount(message.attributes.readerIds.count.toNumberString())
            btnClappCount.setTitle(
                R.string.localizable.formatClapCount(message.attributes.clapperIds.count.toNumberString()),
                for: .normal)
        }
    }

    var isJoinedGroup = false {
        didSet {
            refreshClapButtons()
        }
    }

    var isClapped = false {
        didSet {
            refreshClapButtons()
        }
    }

    var didTapUser: (() -> Void)?
    var didTapRemoveClap: (() -> Void)?
    var didTapAddClap: (() -> Void)?
    var didLongPress: (() -> Void)?
    var didTapAttachment: ((AttachmentData) -> Void)?

    private let disposeBag = DisposeBag()

    private func refreshClapButtons() {
        btnAddClap.isHidden = !isJoinedGroup || isClapped
        btnClappCount.isUserInteractionEnabled = isJoinedGroup && isClapped
        if isClapped {
            btnClappCount.setTitleColor(AppStyles.colorBlue, for: .normal)
        } else {
            btnClappCount.setTitleColor(AppStyles.colorDarkGray, for: .normal)
        }
    }

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

    override func awakeFromNib() {
        super.awakeFromNib()
        attachmentIconView.didTap.subscribe(onNext: { [unowned self] data in
            self.didTapAttachment?(data)
        }).disposed(by: self)
    }

    // MARK: - Action

    @IBAction func didTapIcon(_ sender: Any) {
        didTapUser?()
    }

    @IBAction private func didTapClapCount(_ sender: Any) {
        didTapRemoveClap?()
        isClapped = false
    }

    @IBAction private func didTapAddClap(_ sender: Any) {
        didTapAddClap?()
        isClapped = true
    }
}
