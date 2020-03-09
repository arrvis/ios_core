//
//  SelectMemberViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 23/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit
import TinyConstraints

// MARK: - SelectMemberViewController
final class SelectMemberViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var labelMinGroupMemberNumber: AppLabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var heightOfSpacer: NSLayoutConstraint!

    // MARK: - Variables

    private var presenter: SelectMemberPresenterInterface {
        return presenterInterface as! SelectMemberPresenterInterface
    }

    private var filteredDepartmentsGroupedMember = [(String, [UserData])]()
    private var members = [UserData]()
    private var departments = [DepartmentData]()
    private var searchWord: String? {
        didSet {
            refreshFilteredMembers()
        }
    }
    // ほんとはこいつpresenterとかに持つべき...
    private var selectedMembers = [UserData]()
    private var loginUser: UserData!

    private var minGroupMemberNumber: Int?

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.selectMember()
        searchBar.textField?.textColor = AppStyles.colorBlack
        searchBar.textField?.tintColor = AppStyles.colorDarkGray
        tableView.register(R.nib.selectMemberTableViewCell)
        tableView.tableFooterView = UIView()
    }

    // MARK: - Overrides

    override var rightBarButtonItems: [UIBarButtonItem]? {
        return [
            UIBarButtonItem(title: R.string.localizable.next(), style: .plain)
        ]
    }

    override func didTapRightBarButtonItem(_ index: Int) {
        presenter.didTapNext(selectedMembers)
    }

    override func onKeyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        heightOfSpacer.constant = keyboardFrame.height - (safeAreaInsets?.bottom ?? 0)
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }

    override func onKeyboardWillHide(notification: Notification) {
        heightOfSpacer.constant = 0
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Private

    private func refreshFilteredMembers() {
        if let searchWord = searchWord, !searchWord.isEmpty {
            filteredDepartmentsGroupedMember = [("すべてのメンバー", members.filter { $0.isHit(searchWord) })]
            filteredDepartmentsGroupedMember.append(contentsOf: departments.map { ($0.department.attributes.name, $0.users.filter { $0.isHit(searchWord) }) })
        } else {
            filteredDepartmentsGroupedMember = [("すべてのメンバー", members)]
            filteredDepartmentsGroupedMember.append(contentsOf: departments.map { ($0.department.attributes.name, $0.users) })
        }
        tableView.reloadData()
        rightBarButtonItems?.forEach({ [unowned self] item in
            if let minGroupMemberNumber = self.minGroupMemberNumber {
                item.isEnabled = self.selectedMembers.count >= minGroupMemberNumber
            } else {
                item.isEnabled = !self.selectedMembers.isEmpty
            }
        })
    }
}

// MARK: - UITableViewDataSource
extension SelectMemberViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredDepartmentsGroupedMember.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        let label = AppLabel()
        label.appearanceType = AppLabel.AppearanceType.primary.rawValue
        label.font = AppStyles.fontBold.withSize(13)
        label.text = filteredDepartmentsGroupedMember[section].0
        view.addSubview(label)
        label.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 0, left: 18, bottom: 7, right: 0))
        view.refreshFontSize()
        return view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDepartmentsGroupedMember[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.selectMemberTableViewCell, for: indexPath)!
        cell.refreshFontSize()
        cell.member = filteredDepartmentsGroupedMember[indexPath.section].1[indexPath.row]
        cell.isChecked = selectedMembers.contains(cell.member)
        cell.isCanTapUser = cell.member.data.id != loginUser.data.id
        cell.didTapUser = { [unowned self] userId in
            self.presenter.didTapUser(userId)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectMemberViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selected = filteredDepartmentsGroupedMember[indexPath.section].1[indexPath.row]
        if let foundIndex = selectedMembers.firstIndex(of: selected) {
            selectedMembers.remove(at: foundIndex)
        } else {
            if !tableView.allowsMultipleSelection {
                selectedMembers.removeAll()
            }
            selectedMembers.append(selected)
        }
        NSObject.runAfterDelay(delayMSec: 100) { [unowned self] in
            self.refreshFilteredMembers()
        }
    }
}

// MARK: - UISearchBarDelegate
extension SelectMemberViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        NSObject.runAfterDelay(delayMSec: 10) { [unowned self] in
            self.searchWord = searchBar.text
        }
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = nil
        searchWord = nil
    }
}

// MARK: - SelectMemberViewInterface
extension SelectMemberViewController: SelectMemberViewInterface {

    func setCanMultipleSelection(_ canMultipleSelection: Bool) {
        tableView.allowsMultipleSelection = canMultipleSelection
    }

    func showMembers(_ members: [UserData], _ departments: [DepartmentData], _ loginUser: UserData) {
        self.members = members
        self.departments = departments
        self.loginUser = loginUser
        refreshFilteredMembers()
    }

    func showSelectedMembers(_ members: [UserData]) {
        selectedMembers = members
    }

    func showMinGroupMemberNumber(_ number: Int) {
        minGroupMemberNumber = number
        labelMinGroupMemberNumber.isHidden = false
        labelMinGroupMemberNumber.text = R.string.localizable.formatMemberSelectMinGroupMember(number.toNumberString())
        refreshFilteredMembers()
    }
}
