//
//  EditApprovalConfirmationViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 22/01/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - EditApprovalConfirmationViewController
final class EditApprovalConfirmationViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var textFieldApprovalConfirmation: AppTextField!
    @IBOutlet weak private var labelApprovalConfirmationLength: AppLabel!

    // MARK: - Variables

    private var presenter: EditApprovalConfirmationPresenterInterface {
        return presenterInterface as! EditApprovalConfirmationPresenterInterface
    }

    // MARK: - Overrides

    override var rightBarButtonItems: [UIBarButtonItem]? {
        return [
            UIBarButtonItem(title: R.string.localizable.next(), style: .plain)
        ]
    }

    override func didTapRightBarButtonItem(_ index: Int) {
        presenter.didTapDone(textFieldApprovalConfirmation.text)
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.editApprovalConfirmation()
        textFieldApprovalConfirmation.rx.text.subscribe(onNext: { [unowned self] _ in
            if self.textFieldApprovalConfirmation.markedTextRange == nil {
                self.textFieldApprovalConfirmation.text = String(self.textFieldApprovalConfirmation.text?.prefix(20) ?? "")
                self.labelApprovalConfirmationLength.text = self.textFieldApprovalConfirmation.text?.count.toNumberString()
            }
        }).disposed(by: self)
    }
}

// MARK: - EditApprovalConfirmationViewInterface
extension EditApprovalConfirmationViewController: EditApprovalConfirmationViewInterface {

    func showApprovalConfirmation(_ approvalConfirmation: String?) {
        textFieldApprovalConfirmation.text = approvalConfirmation
    }
}
