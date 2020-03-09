//
//  ReportMessageViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 19/12/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - ReportMessageViewController
final class ReportMessageViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var barButtonItemReport: UIBarButtonItem!

    // MARK: - Variables

    private var presenter: ReportMessagePresenterInterface {
        return presenterInterface as! ReportMessagePresenterInterface
    }

    private var tableViewController: ReportMessageTableViewController!
    private var comment: String!

    // MARK: - Overrides

    override func didTapRightBarButtonItem(_ index: Int) {
        self.presenter.didTapReport(comment)
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.reportMessage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ReportMessageTableViewController {
            tableViewController = vc
            vc.didCommentChanged.subscribe(onNext: { [unowned self] comment in
                self.barButtonItemReport.isEnabled = !comment.isEmpty
                self.comment = comment
            }).disposed(by: self)
        }
    }
}

// MARK: - ReportMessageViewInterface
extension ReportMessageViewController: ReportMessageViewInterface {
}
