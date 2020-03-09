//
//  SendCoinViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - SendCoinViewController
final class SendCoinViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var barButtonItemSend: UIBarButtonItem!
    @IBOutlet weak private var imageViewIconFrom: UIImageView!
    @IBOutlet weak private var labelFromName: AppLabel!
    @IBOutlet weak private var labelRemainCoin: AppLabel!
    @IBOutlet weak private var btnTo: UIButton!
    @IBOutlet weak private var labelToName: AppLabel!
    @IBOutlet weak private var labelCoinName: AppLabel!
    @IBOutlet weak private var imageViewCoinIcon: UIImageView!
    @IBOutlet weak private var textFieldUsePointNum: AppTextField!
    @IBOutlet weak private var textViewComment: AppTextView!
    @IBOutlet weak private var labelPlaceHolder: AppLabel!
    @IBOutlet weak private var heightOfSpacer: NSLayoutConstraint!

    // MARK: - Variables

    private var presenter: SendCoinPresenterInterface {
        return presenterInterface as! SendCoinPresenterInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.sendCoin()
        configureRightItemsToBlue()
        textViewComment.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textFieldUsePointNum.canAction = false
        textFieldUsePointNum.nextInputResponder = textViewComment
        textViewComment.previousInputResponder = textFieldUsePointNum
    }

    // MARK: - Overrides

    override func didTapRightBarButtonItem(_ index: Int) {
        presenter.didTapSend(Int(textFieldUsePointNum.text!)!, textViewComment.text)
    }

    override func onKeyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        labelPlaceHolder.isHidden = true
        heightOfSpacer.constant = keyboardFrame.height - (safeAreaInsets?.bottom ?? 0)
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }

    override func onKeyboardWillHide(notification: Notification) {
        labelPlaceHolder.isHidden = !textViewComment.text.isEmpty
        heightOfSpacer.constant = 0
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Action

    @IBAction private func didTapSelectMember(_ sender: Any) {
        presenter.didTapSelectMember()
    }

    @IBAction private func didTapSelectCoin(_ sender: Any) {
        presenter.didTapSelectCoin()
    }
}

// MARK: - SendCoinViewInterface
extension SendCoinViewController: SendCoinViewInterface {

    func showLoginUser(_ loginUser: UserData) {
        if let icon = loginUser.data.attributes.icon {
            imageViewIconFrom.setImageWithUrlString(icon)
        }
        labelFromName.text = loginUser.data.attributes.fullName
        labelRemainCoin.text = R.string.localizable.formatRemainPoint(loginUser.data.attributes.presentablePoints.toNumberString())
    }

    func showToUser(_ user: UserData?) {
        if let user = user {
            if let icon = user.data.attributes.icon {
                btnTo.setImageWithUrlString(for: .normal, icon)
            } else {
                btnTo.setImage(nil, for: .normal)
            }
        } else {
            btnTo.setImage(R.image.buttonAdd(), for: .normal)
        }
        labelToName.text = user?.data.attributes.fullName ?? R.string.localizable.sendCoinSelectTo()
        barButtonItemSend.isEnabled = user != nil
    }

    func showCoin(_ coin: Coin) {
        labelCoinName.text = coin.attributes.name
        imageViewCoinIcon.setImageWithUrlString(coin.attributes.icon)
        textFieldUsePointNum.text = "\(coin.attributes.defaultPointNumber)"
    }
}

// MARK: - UITextViewDelegate
extension SendCoinViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        labelPlaceHolder.isHidden = !textView.text.isEmpty
    }
}
