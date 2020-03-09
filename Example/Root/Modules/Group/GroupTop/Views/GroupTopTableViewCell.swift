//
//  GroupTopTableViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/20.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit

final class GroupTopTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var imageViewIcon: UIImageView!
    @IBOutlet weak private var labelName: AppLabel!
    @IBOutlet weak private var labelLatestMessageContent: AppLabel!
    @IBOutlet weak private var labelTime: AppLabel!
    @IBOutlet weak private var labelUnreadCount: AppLabel!

    // MARK: - Variables

    var groupData: GroupData? {
        didSet {
            guard let groupData = groupData else {
                return
            }
            if let icon = groupData.group.attributes.icon {
                imageViewIcon.setImageWithUrlString(icon)
            } else {
                imageViewIcon.image = nil
            }
            labelName.text = groupData.group.groupNameLabelText
            if let latestMessage = groupData.group.attributes.latestMessage {
                labelLatestMessageContent.text = latestMessage.content
                while labelLatestMessageContent.actualNumberOfLines < 2 {
                    labelLatestMessageContent.text = (labelLatestMessageContent.text ?? "") + "\r"
                }
                labelTime.isHidden = false
                if latestMessage.createdAtValue.startOfDay == Date.today {
                    labelTime.text = latestMessage.createdAtValue.toString(R.string.localizable.dateFormatTime())
                } else {
                    labelTime.text = latestMessage.createdAtValue.toString(R.string.localizable.dateFormatDateTime())
                }
                labelUnreadCount.text = groupData.group.attributes.notReadMessagesCount.toNumberString()
                labelUnreadCount.isHidden = !(groupData.isJoined && (groupData.group.attributes.notReadMessagesCount > 0))
            } else {
                labelLatestMessageContent.text = R.string.localizable.groupTopNewGroupMessageContent()
                labelTime.isHidden = true
                labelUnreadCount.isHidden = !groupData.isJoined
                labelUnreadCount.text = "N"
            }
        }
    }
}
