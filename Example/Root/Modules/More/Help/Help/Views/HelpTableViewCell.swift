//
//  HelpTableViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/03/04.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import UIKit

final class HelpTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var label: AppLabel!

    // MARK: - Variables

    var help: HelpData! {
        didSet {
            label.text = help.help.attributes.question
        }
    }
}
