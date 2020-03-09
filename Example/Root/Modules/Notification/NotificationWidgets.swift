//
//  NotificationWidgets.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/02/04.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import UIKit

final class ApprovalStatusLabel: AppLabel {

    var isApproved: Bool! {
        didSet {
            if isApproved {
                text = R.string.localizable.approved()
                appearanceType = AppLabel.AppearanceType.lineGrayRounded.rawValue
            } else {
                text = R.string.localizable.unapproved()
                appearanceType = AppLabel.AppearanceType.redRounded.rawValue
            }
        }
    }

    override var textInsets: UIEdgeInsets? {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

final class ReadStatusLabel: AppLabel {

    var isRead: Bool! {
        didSet {
            if isRead {
                text = R.string.localizable.alreadyRead()
                appearanceType = AppLabel.AppearanceType.lineGrayRounded.rawValue
            } else {
                text = R.string.localizable.unread()
                appearanceType = AppLabel.AppearanceType.redRounded.rawValue
            }
        }
    }

    override var textInsets: UIEdgeInsets? {
        return UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
    }
}
