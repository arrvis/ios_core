//
//  SelectGroupTableViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/28.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit

final class SelectGroupTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var imageViewCheck: UIImageView!
    @IBOutlet weak private var labelName: AppLabel!

    // MARK: - Variables

    var group: ResponsedGroup? = nil {
        didSet {
            if let group = group {
                labelName.text = group.attributes.name
            } else {
                labelName.text = R.string.localizable.allGroups()
            }
        }
    }

    var isChecked: Bool = false {
        didSet {
            imageViewCheck.image = isChecked ? R.image.iconCheckOn() : R.image.iconCheckOff()
        }
    }
}
