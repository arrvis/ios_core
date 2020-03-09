//
//  HelpViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 04/03/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import UIKit
import TinyConstraints

// MARK: - HelpViewController
final class HelpViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var tableView: UITableView!

    // MARK: - Variables

    private var presenter: HelpPresenterInterface {
        return presenterInterface as! HelpPresenterInterface
    }

    private var groupedHelps: ([Included], [Int: [HelpData]]) = ([], [:])

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(R.nib.helpTableViewCell)
    }
}

// MARK: - UITableViewDataSource
extension HelpViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedHelps.0.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = groupedHelps.0[section]
        return groupedHelps.1[Int(key.id)!]!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.helpTableViewCell, for: indexPath)!
        let key = groupedHelps.0[indexPath.section]
        cell.help = groupedHelps.1[Int(key.id)!]![indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HelpViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let key = groupedHelps.0[section]
        let view = UIView()
        view.backgroundColor = .clear
        let label = AppLabel()
        label.appearanceType = AppLabel.AppearanceType.primary.rawValue
        label.font = AppStyles.fontBold.withSize(13)
        label.text = key.attributes["name"]?.value as? String
        view.addSubview(label)
        label.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 0, left: 18, bottom: 7, right: 0))
        view.refreshFontSize()
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = groupedHelps.0[indexPath.section]
        let help = groupedHelps.1[Int(key.id)!]![indexPath.row]
        presenter.didTapHelp(help)
    }
}

// MARK: - HelpViewInterface
extension HelpViewController: HelpViewInterface {

    func showHelps(_ helps: [HelpData]) {
        if helps.isEmpty {
            return
        }
        let grouped = Dictionary(grouping: helps, by: { help -> Int in
            help.help.attributes.helpCategoryId
        })
        let helpCategories = helps.first!.included.filter { $0.type == "help_category" }
        groupedHelps = (grouped.keys.flatMap { key in helpCategories.filter { $0.id == String(key) } }.sorted(by: { l, r -> Bool in
            return l.id < r.id
        }), grouped)
        tableView.reloadData()
    }
}
