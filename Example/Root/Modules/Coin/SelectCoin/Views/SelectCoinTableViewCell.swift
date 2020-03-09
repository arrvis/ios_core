//
//  SelectCoinTableViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/28.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit

final class SelectCoinTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var imageViewCoin: UIImageView!
    @IBOutlet weak private var labelCoinName: AppLabel!

    // MARK: - Variables

    var coin: Coin! {
        didSet {
            imageViewCoin.setImageWithUrlString(coin.attributes.icon)
            labelCoinName.text = coin.attributes.name
        }
    }
}
