//
//  ReportMessageTableViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/12/19.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TinyConstraints

final class ReportMessageTableViewController: AppTableViewController {

    // MARK: - Outlet

    @IBOutlet weak private var textViewComment: ReportCommentTextView!
    @IBOutlet weak private var labelPlaceHolder: AppLabel!

    // MARK: - Variables

    var didCommentChanged: Observable<String> {
        return didCommentChangedSubject
    }
    private let didCommentChangedSubject = PublishSubject<String>()

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        textViewComment.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textViewComment.rx.text.subscribe(onNext: { [unowned self] _ in
            self.labelPlaceHolder.isHidden = !self.textViewComment.text.isEmpty
            self.didCommentChangedSubject.onNext(self.textViewComment.text)
        }).disposed(by: self)
    }
}

// MARK: - UITableViewDataSource
extension ReportMessageTableViewController {

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        let label = AppLabel()
        label.appearanceType = AppLabel.AppearanceType.primary.rawValue
        label.font = AppStyles.fontBold.withSize(13)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        view.addSubview(label)
        label.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 0, left: 18, bottom: 7, right: 0))
        view.refreshFontSize()
        return view
    }
}

final class ReportCommentTextView: AppTextView {

    override var hideBtnIfNotExists: Bool {
        return true
    }
}
