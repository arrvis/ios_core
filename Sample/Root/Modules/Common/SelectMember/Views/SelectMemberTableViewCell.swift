//
//  SelectMemberTableViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/28.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit

final class SelectMemberTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var btnCheck: UIButton!
    @IBOutlet weak private var btnIcon: UIButton!
    @IBOutlet weak private var labelName: AppLabel!
    @IBOutlet weak private var labelTitle: AppLabel!

    // MARK: - Variables

    var didTapUser: ((String) -> Void)?

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

    var isCanTapUser: Bool = true {
        didSet {
            btnIcon.isUserInteractionEnabled = isCanTapUser
        }
    }

    var isChecked: Bool = false {
        didSet {
            btnCheck.setImage(isChecked ? R.image.iconCheckOn() : R.image.iconCheckOff(), for: .normal)
        }
    }

    // MARK: - Action

    @IBAction func didTapMember(_ sender: Any) {
        didTapUser?(member.data.id)
    }
}
