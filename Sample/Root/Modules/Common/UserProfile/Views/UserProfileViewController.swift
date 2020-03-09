//
//  UserProfileViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - UserProfileViewController
final class UserProfileViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var imageViewIcon: UIImageView!
    @IBOutlet weak private var labelUserName: AppLabel!
    @IBOutlet weak private var labelTitle: AppLabel!
    @IBOutlet weak private var labelComment: AppLabel!

    // MARK: - Variables

    private var presenter: UserProfilePresenterInterface {
        return presenterInterface as! UserProfilePresenterInterface
    }

    // MARK: - Life-Cycle

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UserProfileCoinViewController {
            vc.userId = presenter.getUserId()
        }
    }

    // MARK: - Action

    @IBAction private func didTapSendCoin(_ sender: Any) {
        self.presenter.didTapSendCoin()
    }
}

// MARK: - UserProfileViewInterface
extension UserProfileViewController: UserProfileViewInterface {

    func showUser(_ user: UserData) {
        title = user.data.attributes.fullName
        if let icon = user.data.attributes.icon {
            imageViewIcon.setImageWithUrlString(icon)
        } else {
            imageViewIcon.image = nil
        }
        labelUserName.text = user.data.attributes.fullName
        labelTitle.text = user.title
        labelComment.text = user.data.attributes.comment
    }
}
