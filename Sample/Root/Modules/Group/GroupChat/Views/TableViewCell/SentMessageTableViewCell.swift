//
//  SentMessageTableViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/12/01.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift

final class SentMessageTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var labelTime: AppLabel!
    @IBOutlet weak private var labelReadersCount: AppLabel!
    @IBOutlet weak private var labelContent: LinkLabel!
    @IBOutlet weak private var btnClappCount: AppButton!
    @IBOutlet weak private var attachmentIconView: AttachmentIconView!

    @IBOutlet private var topOfLabelContent: NSLayoutConstraint!
    @IBOutlet private var bottomOfLabelContent: NSLayoutConstraint!
    @IBOutlet private var topOfBtnAttachment: NSLayoutConstraint!
    @IBOutlet private var bottomOfBtnAttachment: NSLayoutConstraint!
    @IBOutlet private var heightOfAttachment: NSLayoutConstraint!
    @IBOutlet private var leadingOfAttachment: NSLayoutConstraint!

    // MARK: - Variables

    var message: Message! {
        didSet {
            labelTime.text = message.attributes.createdAtValue.toString(R.string.localizable.dateFormatTime())
            labelReadersCount.text = R.string.localizable.formatReadersCount(message.attributes.readerIds.count.toNumberString())
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
                attachmentIconView.imageContentMode = .scaleAspectFill
                if attachmentIconView.type == .document {
                    heightOfAttachment.constant = 72
                    leadingOfAttachment.constant = 326
                    bottomOfBtnAttachment.constant = 24
                } else {
                    heightOfAttachment.constant = 285
                    leadingOfAttachment.constant = 113
                    bottomOfBtnAttachment.constant = 14
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
                leadingOfAttachment.constant = 296
                bottomOfBtnAttachment.constant = 24
            } else {
                labelContent.isHidden = false
                topOfLabelContent.isActive = true
                bottomOfLabelContent.isActive = true

                attachmentIconView.isHidden = true
                topOfBtnAttachment.isActive = false
                bottomOfBtnAttachment.isActive = false

                labelContent.text = message.attributes.content
                leadingOfAttachment.constant = 113
            }
            btnClappCount.setTitle(
                R.string.localizable.formatClapCount(message.attributes.clapperIds.count.toNumberString()),
                for: .normal)
        }
    }

    var didTapAttachment: ((AttachmentData) -> Void)?
    var didLongPress: (() -> Void)?

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

    override func awakeFromNib() {
        super.awakeFromNib()
        attachmentIconView.didTap.subscribe(onNext: { [unowned self] data in
            self.didTapAttachment?(data)
        }).disposed(by: self)
    }
}
