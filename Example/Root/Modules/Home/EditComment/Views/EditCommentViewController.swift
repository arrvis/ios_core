//
//  EditCommentViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - EditCommentViewController
final class EditCommentViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var textFieldComment: AppTextField!
    @IBOutlet weak private var labelCommentLength: AppLabel!
    @IBOutlet weak private var btnSave: AppButton!

    // MARK: - Variables

    private var presenter: EditCommentPresenterInterface {
        return presenterInterface as! EditCommentPresenterInterface
    }

    private var original: String?

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.editComment()
        textFieldComment.rx.text.subscribe(onNext: { [unowned self] _ in
            if self.textFieldComment.markedTextRange == nil {
                self.textFieldComment.text = String(self.textFieldComment.text?.prefix(20) ?? "")
                self.labelCommentLength.text = self.textFieldComment.text?.count.toNumberString()
                self.btnSave.isEnabled = (self.textFieldComment.text?.count ?? 0) > 0 && self.original != self.textFieldComment.text
            }
        }).disposed(by: self)
    }

    // MARK: - Action

    @IBAction private func didTapSave(_ sender: Any) {
        presenter.didTapSave(textFieldComment.text)
    }
}

// MARK: - EditCommentViewInterface
extension EditCommentViewController: EditCommentViewInterface {

    func showComment(_ comment: String?) {
        original = comment
        textFieldComment.text = comment
    }
}
