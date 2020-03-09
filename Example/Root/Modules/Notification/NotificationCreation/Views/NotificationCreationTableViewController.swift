//
//  NotificationCreationTableViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/01/16.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TinyConstraints
import ArrvisCore

final class NotificationCreationTableViewController: AppTableViewController {

    // MARK: - Outlets

    @IBOutlet weak private var labelSelectedGroups: AppLabel!
    @IBOutlet weak private var textFieldTitle: AppTextField!
    @IBOutlet weak private var textViewContent: ReportCommentTextView!
    @IBOutlet weak private var labelPlaceHolder: AppLabel!
    @IBOutlet weak private var switchRequiredApproval: UISwitch!
    @IBOutlet weak private var labelApprovalConfirmation: AppLabel!
    @IBOutlet weak private var approvingDeadlineContentView: UIView!
    @IBOutlet weak private var labelApprovingDeadline: AppLabel!
    @IBOutlet weak private var switchRequiredRead: UISwitch!

    // MARK: - Variables

    private(set) var allGroupsCount: Int = 0
    private(set) var selectedGroups = [ResponsedGroup]()

    var notificationTitle: String {
        return textFieldTitle.text ?? ""
    }

    var notificationContent: String {
        return textViewContent.text
    }

    var isRequiredApproval: Bool {
        return switchRequiredApproval.isOn
    }

    var approvalConfirmation: String? {
        return labelApprovalConfirmation.text
    }

    var approvingDeadline: Date? {
        didSet {
            labelApprovingDeadline.text = approvingDeadline?.toString(R.string.localizable.dateFormatDateTime())
        }
    }

    var isRequiredRead: Bool {
        return switchRequiredRead.isOn
    }

    var didTapSelectGroup: Observable<Void> {
        return didTapSelectGroupSubject
    }
    private let didTapSelectGroupSubject = PublishSubject<Void>()

    var didTapAddFiles: Observable<Void> {
        return didTapAddFilesSubject
    }
    private let didTapAddFilesSubject = PublishSubject<Void>()

    var didTapAddImage: Observable<Void> {
        return didTapAddImageSubject
    }
    private let didTapAddImageSubject = PublishSubject<Void>()

    var didTapAttachment: Observable<AttachmentData> {
        return didTapAttachmentSubject
    }
    private let didTapAttachmentSubject = PublishSubject<AttachmentData>()

    var didTapRemoveAttachment: Observable<AttachmentData> {
        return didTapRemoveAttachmentSubject
    }
    private let didTapRemoveAttachmentSubject = PublishSubject<AttachmentData>()

    var didTapApprovalConfirmation: Observable<Void> {
        return didTapApprovalConfirmationSubject
    }
    private let didTapApprovalConfirmationSubject = PublishSubject<Void>()

    var didInputDataChanged: Observable<Void> {
        return didInputDataChangedSubject
    }
    private let didInputDataChangedSubject = PublishSubject<Void>()

    private let stackViewAttachments: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 12
        return view
    }()
    private let btnAddFiles: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(R.image.iconFile(), for: .normal)
        view.cornerRadius = 8
        view.backgroundColor = UIColor.white
        view.width(72)
        return view
    }()
    private let btnAddImage: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(R.image.iconImage(), for: .normal)
        view.cornerRadius = 8
        view.backgroundColor = UIColor.white
        view.width(72)
        return view
    }()

    private lazy var dateSelectPicker: DateSelectPicker = {
         let input =  DateSelectPicker(frame: .zero)
         approvingDeadlineContentView.addSubview(input)
         return input
     }()

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldTitle.nextInputResponder = textViewContent
        textFieldTitle.rx.text.subscribe(onNext: { [unowned self] _ in
            if self.textFieldTitle.markedTextRange == nil {
                self.textFieldTitle.text = String(self.notificationTitle.prefix(25))
                self.refreshPostButtonEnabled()
            }
        }).disposed(by: self)
        textViewContent.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textViewContent.previousInputResponder = textFieldTitle
        textViewContent.rx.text.subscribe(onNext: { [unowned self] _ in
            if self.textViewContent.markedTextRange == nil {
                self.textViewContent.text = String(self.notificationContent.prefix(500))
                self.refreshPostButtonEnabled()
            }
            self.labelPlaceHolder.isHidden = !self.textViewContent.text.isEmpty
        }).disposed(by: self)
        stackViewAttachments.addArrangedSubview(btnAddFiles)
        btnAddFiles.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.didTapAddFilesSubject.onNext(())
        }).disposed(by: self)
        stackViewAttachments.addArrangedSubview(btnAddImage)
        btnAddImage.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.didTapAddImageSubject.onNext(())
        }).disposed(by: self)

        switchRequiredApproval.rx.isOn.subscribe(onNext: { [unowned self] _ in
            self.refreshPostButtonEnabled()
            self.tableView.reloadData()
        }).disposed(by: self)

        refreshPostButtonEnabled()
    }

    // MARK: - Methods

    func showEditData(_ data: NotificationData) {
        textFieldTitle.text = data.notification.attributes.title
        textViewContent.text = data.notification.attributes.content
        switchRequiredApproval.isOn = data.notification.attributes.isRequiredApproval
        switchRequiredRead.isOn = data.notification.attributes.isRequiredRead
    }

    func showSelectedGroups(_ groups: [ResponsedGroup], _ allGroupsCount: Int) {
        self.selectedGroups = groups
        self.allGroupsCount = allGroupsCount
        if groups.count == allGroupsCount {
            labelSelectedGroups.text = R.string.localizable.allGroups()
        } else if groups.count > 1 {
            labelSelectedGroups.text = R.string.localizable.formatGroupCount(groups.count.toNumberString())
        } else {
            labelSelectedGroups.text = groups.first?.attributes.name ?? ""
        }
        refreshPostButtonEnabled()
    }

    func showSelectedAttachment(_ data: AttachmentData) {
        func refreshAddButtons() {
            btnAddFiles.isEnabled = stackViewAttachments.subviews.count < 5
            btnAddImage.isEnabled = stackViewAttachments.subviews.count < 5
        }
        let view = AttachmentIconView()
        view.width(72)
        view.data = data
        view.didTap.subscribe(onNext: { [unowned self] data in
            self.didTapAttachmentSubject.onNext(data)
        }).disposed(by: self)
        view.didTapDelete.subscribe(onNext: { [unowned self] data in
            self.stackViewAttachments.removeArrangedSubview(view)
            view.removeFromSuperview()
            refreshAddButtons()
            self.didTapRemoveAttachmentSubject.onNext(data)
        }).disposed(by: self)
        stackViewAttachments.addArrangedSubview(view)
        refreshAddButtons()
    }

    func showApprovalConfirmation(_ approvalConfirmation: String?) {
        labelApprovalConfirmation.text = approvalConfirmation
        refreshPostButtonEnabled()
    }

    // MARK: - Private

    func refreshPostButtonEnabled() {
        didInputDataChangedSubject.onNext(())
    }
}

// MARK: - UITableViewDataSource
extension NotificationCreationTableViewController {

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = self.tableView(tableView, titleForHeaderInSection: section) else {
            return nil
        }
        let view = UIView()
        view.backgroundColor = .clear
        let label = AppLabel()
        label.appearanceType = AppLabel.AppearanceType.primary.rawValue
        label.font = AppStyles.fontBold.withSize(13)
        label.text = title
        view.addSubview(label)
        label.edgesToSuperview(excluding: .bottom, insets: TinyEdgeInsets(top: 18, left: 16, bottom: 0, right: 0))
        return view
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 72
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            if stackViewAttachments.superview != nil {
                stackViewAttachments.removeFromSuperview()
            }
            let scrollView = UIScrollView()
            scrollView.addSubview(stackViewAttachments)
            stackViewAttachments.edgesToSuperview(insets: TinyEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
            stackViewAttachments.height(to: scrollView)
            let container = UIView()
            container.addSubview(scrollView)
            scrollView.edgesToSuperview()
            return container
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if indexPath.section == 3 && (indexPath.row == 1 || indexPath.row == 2) {
            cell.isHidden = !switchRequiredApproval.isOn
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        if cell.isHidden {
            return 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension NotificationCreationTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                didTapSelectGroupSubject.onNext(())
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 1 {
                didTapApprovalConfirmationSubject.onNext(())
            } else if indexPath.row == 2 {
                dateSelectPicker.show(.dateAndTime, nil, nil, approvingDeadline).subscribe(onNext: { [unowned self] approvingDeadline in
                    self.approvingDeadline = approvingDeadline
                }).disposed(by: self)
            }
        }
    }
}
