//
//  SelectGroupViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 18/01/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import UIKit
import TinyConstraints

// MARK: - SelectGroupViewController
final class SelectGroupViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var tableView: UITableView!

    // MARK: - Variables

    private var presenter: SelectGroupPresenterInterface {
        return presenterInterface as! SelectGroupPresenterInterface
    }

    private var groups = [ResponsedGroup]()
    private var selectedGroups = [ResponsedGroup]()

    // MARK: - Overrides

    override var rightBarButtonItems: [UIBarButtonItem]? {
        return [
            UIBarButtonItem(title: R.string.localizable.next(), style: .plain)
        ]
    }

    override func didTapRightBarButtonItem(_ index: Int) {
        self.presenter.didTapDone(selectedGroups)
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.selectGroups()
        tableView.register(R.nib.selectGroupTableViewCell)
        tableView.tableFooterView = UIView()
    }
}

// MARK: - SelectGroupViewInterface
extension SelectGroupViewController: SelectGroupViewInterface {

    func showGroups(_ groups: [ResponsedGroup], _ selectedGroups: [ResponsedGroup]) {
        self.groups = groups
        self.selectedGroups = selectedGroups
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SelectGroupViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        if section == 0 {
            label.text = R.string.localizable.allGroups()
        } else {
            label.text = R.string.localizable.formatGroupCount(groups.count.toNumberString())
        }
        view.addSubview(label)
        label.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 0, left: 18, bottom: 7, right: 0))
        view.refreshFontSize()
        return view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: R.reuseIdentifier.selectGroupTableViewCell,
            for: indexPath)!
        if indexPath.section == 0 {
            cell.group = nil
            cell.isChecked = groups.count == selectedGroups.count
            return cell
        }
        cell.group = groups[indexPath.row]
        cell.isChecked = groups.count != selectedGroups.count && selectedGroups.contains(cell.group!)
        cell.refreshFontSize()
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectGroupViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if groups.count == selectedGroups.count {
                selectedGroups.removeAll()
            } else {
                selectedGroups.removeAll()
                selectedGroups.append(contentsOf: groups)
            }
        } else {
            if groups.count == selectedGroups.count {
                selectedGroups.removeAll()
            }
            let group = groups[indexPath.row]
            if selectedGroups.contains(group) {
                selectedGroups.removeAll(where: { $0 == group })
            } else {
                selectedGroups.append(group)
            }
        }
        tableView.reloadData()
    }
}
