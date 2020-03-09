//
//  MemberCollectionViewCell.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/12/08.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MemberCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet weak private var btnIcon: AppButton!
    @IBOutlet weak private var btnDelete: UIButton!
    @IBOutlet weak private var labelName: AppLabel!

    // MARK: - Variables

    var user: UserData? {
        didSet {
            if let user = user {
                if let icon = user.data.attributes.icon {
                    btnIcon.setImageWithUrlString(for: .normal, icon)
                } else {
                    btnIcon.setImage(nil, for: .normal)
                }
                btnDelete.isHidden = false
                labelName.text = user.data.attributes.fullName
            } else {
                btnIcon.setImage(R.image.iconAdd(), for: .normal)
                btnDelete.isHidden = true
                labelName.text = R.string.localizable.add()
            }
            btnIcon.cornerRadius = btnIcon.bounds.height / 2
        }
    }

    var didTapUser: ((String) -> Void)?
    var didTapAdd: (() -> Void)?
    var didTapDelete: (() -> Void)?

    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    override func awakeFromNib() {
        super.awakeFromNib()
        btnIcon.rx.tap.subscribe(onNext: { [unowned self] _ in
            if let user = self.user {
                self.didTapUser?(user.data.id)
            } else {
                self.didTapAdd?()
            }
        }).disposed(by: disposeBag)
        btnDelete.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.didTapDelete?()
        }).disposed(by: disposeBag)
    }
}
