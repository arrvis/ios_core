//
//  TopViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - TopViewController
final class TopViewController: ViewBase {

    // MARK: - Variables

    private var presenter: TopPresenterInterface {
        return presenterInterface as! TopPresenterInterface
    }

    // MARK: - Life-Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Action

    @IBAction private func didTapLogin(_ sender: Any) {
        presenter.didTapLogin()
    }

    @IBAction private func didTapForgotPassword(_ sender: Any) {
        presenter.didTapForgotPassword()
    }
}

// MARK: - TopViewInterface
extension TopViewController: TopViewInterface {
}
