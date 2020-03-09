//
//  SelectFontSizeTableViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/02/21.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import UIKit

final class SelectFontSizeTableViewController: AppTableViewController {

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            appFontSize = .large
        } else if indexPath.row == 1 {
            appFontSize = .normal
        } else if indexPath.row == 2 {
            appFontSize = .small
        }
        refresh()
    }

    // MARK: - Private

    private func refresh() {
        tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)).accessoryType = .none
        tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)).accessoryType = .none
        tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0)).accessoryType = .none
        switch appFontSize {
        case .large:
            tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)).accessoryType = .checkmark
        case .normal:
            tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)).accessoryType = .checkmark
        case .small:
            tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0)).accessoryType = .checkmark
        }
    }
}
