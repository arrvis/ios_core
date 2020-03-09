//
//  LoginViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - LoginViewController
final class LoginViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var textFieldId: AppTextField!
    @IBOutlet weak private var textFieldPassword: AppTextField!

    // MARK: - Variables

    override var scrollViewForResizeKeyboard: UIScrollView? {
        return scrollView
    }

    private var presenter: LoginPresenterInterface {
        return presenterInterface as! LoginPresenterInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldId.nextInputResponder = textFieldPassword
        textFieldPassword.previousInputResponder = textFieldId
    }

    // MARK: - Action

    @IBAction private func didTapLogin(_ sender: Any) {
        presenter.didTapLogin(textFieldId.text!, textFieldPassword.text!)
    }
}

// MARK: - LoginViewInterface
extension LoginViewController: LoginViewInterface {
}
