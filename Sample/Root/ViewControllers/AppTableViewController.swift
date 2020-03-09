//
//  AppTableViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/02/21.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import UIKit

open class AppTableViewController: UITableViewController {

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.refreshFontSize()
    }

    open override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.refreshFontSize()
    }

    open override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.refreshFontSize()
    }

    open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.refreshFontSize()
    }
}
