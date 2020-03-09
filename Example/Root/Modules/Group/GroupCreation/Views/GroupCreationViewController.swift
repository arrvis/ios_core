//
//  GroupCreationViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - GroupCreationViewController
final class GroupCreationViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var imageViewIcon: UIImageView!
    @IBOutlet weak private var textFieldGroupName: UITextField!
    @IBOutlet weak private var labelGroupNameCount: AppLabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var labelMinGroupMemberNumber: AppLabel!
    @IBOutlet weak private var labelMemberCount: AppLabel!

    // MARK: - Variables

    private var presenter: GroupCreationPresenterInterface {
        return presenterInterface as! GroupCreationPresenterInterface
    }

    private var group: GroupData?
    private var members = [UserData]()
    private var minGroupMemberNumber: Int = 0

    // MARK: - Overrides

    override var rightBarButtonItems: [UIBarButtonItem]? {
        return [
            UIBarButtonItem(title: R.string.localizable.create(), style: .plain)
        ]
    }

    override func didTapRightBarButtonItem(_ index: Int) {
        presenter.didTapCreate(textFieldGroupName.text ?? "", members)
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = group == nil ? R.string.localizable.groupCreation() : R.string.localizable.groupEdit()
        collectionView.register(R.nib.memberCollectionViewCell)
        textFieldGroupName.rx.text.subscribe(onNext: { [unowned self] _ in
            if self.textFieldGroupName.markedTextRange == nil {
                self.textFieldGroupName.text = String(self.textFieldGroupName.text?.prefix(50) ?? "")
                self.labelGroupNameCount.text = "\(self.textFieldGroupName.text?.count.toNumberString() ?? 0.toNumberString())/50"
                self.refreshCreateButtonEnabled()
            }
        }).disposed(by: self)
    }

    // MARK: - Life-Cycle

    @IBAction private func didTapIcon(_ sender: Any) {
        presenter.didTapIcon()
    }
}

// MARK: - GroupCreationViewInterface
extension GroupCreationViewController: GroupCreationViewInterface {

    func showGroup(_ group: GroupData) {
        self.group = group
        if let icon = group.group.attributes.icon {
            imageViewIcon.setImageWithUrlString(icon)
        }
        textFieldGroupName.text = group.group.attributes.name
        rightBarButtonItems?.forEach({ item in
            item.title = "完了"
        })
    }

    func showIcon(_ image: UIImage) {
        imageViewIcon.image = image
    }

    func showMembers(_ members: [UserData]) {
        self.members = members
        labelMemberCount.text = R.string.localizable.formatMemberCount(members.count.toNumberString())
        collectionView.reloadData()
        refreshCreateButtonEnabled()
    }

    func showMinGroupMemberNumber(_ number: Int) {
        minGroupMemberNumber = number
        labelMinGroupMemberNumber.text = R.string.localizable.formatMemberSelectMinGroupMember(number.toNumberString())
        refreshCreateButtonEnabled()
    }

    private func refreshCreateButtonEnabled() {
        rightBarButtonItems?.forEach({ [unowned self] item in
            item.isEnabled = self.members.count >= self.minGroupMemberNumber && !(textFieldGroupName.text?.isEmpty ?? true)
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GroupCreationViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: floor(collectionView.bounds.width / 4), height: 100)
    }
}

// MARK: - UICollectionViewDataSource
extension GroupCreationViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.memberCollectionViewCell, for: indexPath)!
        if indexPath.row == 0 {
            cell.user = nil
        } else {
            let member = members[indexPath.row - 1]
            cell.user = members[indexPath.row - 1]
            cell.didTapDelete = { [unowned self] in
                var members = self.members
                members.removeAll(where: { $0.data.id == member.data.id })
                self.showMembers(members)
            }
        }
        cell.didTapUser = { [unowned self] userId in
            self.presenter.didTapUser(userId)
        }
        cell.didTapAdd = { [unowned self] in
            self.presenter.didTapAddMember(self.members)
        }
        cell.refreshFontSize()
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension GroupCreationViewController: UICollectionViewDelegate {
}

final class GroupNameTextField: AppTextField {

    override var hideBtnIfNotExists: Bool {
        return true
    }
}
