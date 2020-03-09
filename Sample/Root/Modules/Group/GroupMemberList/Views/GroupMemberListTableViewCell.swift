//
//  GroupMemberListTableViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/28.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit

final class GroupMemberListTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var btnIcon: UIButton!
    @IBOutlet weak private var labelName: AppLabel!
    @IBOutlet weak private var labelTitle: AppLabel!
    @IBOutlet weak private var labelOwner: AppLabel!

    // MARK: - Variables

    var member: UserData! {
        didSet {
            if let icon = member.data.attributes.icon {
                btnIcon.setImageWithUrlString(for: .normal, icon)
                btnIcon.imageView?.contentMode = .scaleAspectFill
            } else {
                btnIcon.setImage(nil, for: .normal)
            }
            labelName.text = member.data.attributes.fullName
            labelTitle.text = member.department.name
        }
    }

    var isOwner = true {
        didSet {
            labelOwner.isHidden = !isOwner
        }
    }

    var didTapUser: ((String) -> Void)?

    // MARK: - Action
    @IBAction func didTapIcon(_ sender: Any) {
        didTapUser?(member.data.id)
    }
}
