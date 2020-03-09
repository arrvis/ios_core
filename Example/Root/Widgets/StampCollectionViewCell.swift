//
//  StampCollectionViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/02/21.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import UIKit

final class StampCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var btn: UIButton!

    // MARK: - Variables

    var didTap: (() -> Void)?
    var image: UIImage? {
        didSet {
            btn.setBackgroundImage(image, for: .normal)
        }
    }

    // MARK: - Actions

    @IBAction private func didTapButton(_ sender: Any) {
        didTap?()
    }
}
