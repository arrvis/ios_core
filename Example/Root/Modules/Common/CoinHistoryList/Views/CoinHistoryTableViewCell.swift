//
//  CoinHistoryTableViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/21.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit

final class CoinHistoryTableViewCell: UITableViewCell {

    // MARK: - Const

    private let minimumInfoLines = 4

    // MARK: - Outlets

    // Coin
    @IBOutlet weak private var imageViewCoin: UIImageView!

    // From
    @IBOutlet weak private var btnIconFrom: UIButton!
    @IBOutlet weak private var labelFromName: AppLabel!

    // To
    @IBOutlet weak private var btnIconTo: UIButton!
    @IBOutlet weak private var labelToName: AppLabel!
    @IBOutlet weak private var labelAddCoin: AppLabel!

    // Data
    @IBOutlet weak private var labelPresentInfo: LinkLabel!
    @IBOutlet weak private var btnClappersCount: AppButton!
    @IBOutlet weak private var btnAddClap: AppButton!
    @IBOutlet weak private var labelDateTime: AppLabel!

    @IBOutlet weak private var btnToggleLines: AppButton!

    // MARK: - Variables

    var didTapUser: ((String) -> Void)?
    var didTapRemoveClap: (() -> Void)?
    var didTapAddClap: (() -> Void)?
    private var present: Present!

    // MARK: - Action

    @IBAction private func didTapFrom(_ sender: Any) {
        didTapUser?(present.relationships.from.data.id)
    }

    @IBAction private func didTapTo(_ sender: Any) {
        didTapUser?(present.relationships.to.data.id)
    }

    @IBAction private func didTapToggleLines(_ sender: Any) {
        if labelPresentInfo.numberOfLines == minimumInfoLines {
            labelPresentInfo.numberOfLines = 0
            btnToggleLines.setTitle(R.string.localizable.hideTexts(), for: .normal)
        } else {
            labelPresentInfo.numberOfLines = minimumInfoLines
            btnToggleLines.setTitle(R.string.localizable.showAllTexts(), for: .normal)
        }
        (superview as? UITableView)?.performBatchUpdates(nil, completion: nil)
    }

    @IBAction private func didTapRemoveClap(_ sender: Any) {
        didTapRemoveClap?()
    }

    @IBAction private func didTapAddClap(_ sender: Any) {
        didTapAddClap?()
    }

    // MARK: - Methods

    func setData(_ present: Present, _ coins: [Coin], _ users: [UserRelation], _ isClapped: Bool, _ loginUser: UserData) {
        self.present = present
        let isSendBySelf = present.relationships.from.data.id == loginUser.data.id
        let isSendToSelf = present.relationships.to.data.id == loginUser.data.id
        let coin = coins.first(where: { present.relationships.coin.data.id == $0.id })!
        imageViewCoin.setImageWithUrlString(coin.attributes.icon)

        let from = users.first(where: { present.relationships.from.data.id == $0.id })!
        if let icon = from.attributes.icon {
            btnIconFrom.setImageWithUrlString(for: .normal, icon)
            btnIconFrom.imageView?.contentMode = .scaleAspectFill
        } else {
            btnIconFrom.setImage(nil, for: .normal)
        }
        btnIconFrom.isUserInteractionEnabled = !isSendBySelf
        labelFromName.text = from.attributes.fullName

        let to = users.first(where: { present.relationships.to.data.id == $0.id })!
        if let icon = to.attributes.icon {
            btnIconTo.setImageWithUrlString(for: .normal, icon)
            btnIconTo.imageView?.contentMode = .scaleAspectFill
        } else {
            btnIconTo.setImage(nil, for: .normal)
        }
        btnIconTo.isUserInteractionEnabled = !isSendToSelf
        labelToName.text = to.attributes.fullName
        labelAddCoin.text = R.string.localizable.formatAddedCoins(present.attributes.pointNumber.toNumberString())

        labelPresentInfo.text = present.attributes.comment
        labelPresentInfo.textInsets = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
        btnClappersCount.setTitle(R.string.localizable.formatClapCount(present.attributes.clapperIds.count.toNumberString()), for: .normal)
        labelDateTime.text = present.attributes.createdAtValue.toString(R.string.localizable.dateFormatDateTime())
        btnToggleLines.isHidden = labelPresentInfo.actualNumberOfLines <= minimumInfoLines

        if isSendBySelf {
            btnClappersCount.isUserInteractionEnabled = false
            btnAddClap.isHidden = true
        } else {
            btnClappersCount.isUserInteractionEnabled = isClapped
            btnAddClap.isHidden = isClapped
        }
        if isClapped {
            btnClappersCount.setTitleColor(AppStyles.colorBlue, for: .normal)
        } else {
            btnClappersCount.setTitleColor(AppStyles.colorDarkGray, for: .normal)
        }
    }
}
