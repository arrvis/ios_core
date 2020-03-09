//
//  GroupTopViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - GroupTopViewController
final class GroupTopViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var barButtonItemGroupCreation: UIBarButtonItem!
    @IBOutlet weak private var heightOfSpacer: NSLayoutConstraint!

    // MARK: - Variables

    private var presenter: GroupTopPresenterInterface {
        return presenterInterface as! GroupTopPresenterInterface
    }

    private var filteredGroups = [GroupData]()
    private var groups = [GroupData]()
    private var searchWord: String? {
        didSet {
            refreshFilteredMessages()
        }
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.group()
        configureRightItemsToBlue()
        searchBar.textField?.textColor = AppStyles.colorBlack
        searchBar.textField?.tintColor = AppStyles.colorDarkGray
        tableView.register(R.nib.groupTopTableViewCell)
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor.white
    }

    // MARK: - Overrides

    override func didTapLeftBarButtonItem(_ index: Int) {
        presenter.didTapLatestNotifications()
    }

    override func didTapRightBarButtonItem(_ index: Int) {
        presenter.didTapGroupCreation()
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

    private func refreshFilteredMessages() {
        if let searchWord = searchWord, !searchWord.isEmpty {
            filteredGroups = groups.filter {
                $0.group.attributes.name.contains(searchWord)
            }
        } else {
            filteredGroups = groups
        }
        filteredGroups = filteredGroups.sorted(by: { l, r -> Bool in
            if let left = l.group.attributes.latestMessage?.createdAt {
                if let right = r.group.attributes.latestMessage?.createdAt {
                    return left > right
                }
                return false
            }
            return false
        })
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension GroupTopViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.groupTopTableViewCell, for: indexPath)!
        cell.groupData = filteredGroups[indexPath.row]
        cell.refreshFontSize()
        return cell
    }
}

// MARK: - UITableViewDelegate
extension GroupTopViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didTapGroup(filteredGroups[indexPath.row])
    }
}

// MARK: - UISearchBarDelegate
extension GroupTopViewController: UISearchBarDelegate {

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

// MARK: - GroupTopViewInterface
extension GroupTopViewController: GroupTopViewInterface {

    func showLoginUser(_ loginUser: UserData) {
        if loginUser.role.groupCreatableNumber == nil {
            navigationItem.rightBarButtonItems = nil
        }
    }

    func showGroups(_ groups: [GroupData]) {
        self.groups = groups
        refreshFilteredMessages()
    }
}
