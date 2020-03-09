//
//  DateHeaderTableViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/12/01.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit

final class DateHeaderTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var labelTitle: AppLabel!

    // MARK: - Variables

    var date: Date! {
        didSet {
            labelTitle.text = date.toString(R.string.localizable.dateFormatFullDate())
        }
    }
}
