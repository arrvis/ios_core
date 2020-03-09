//
//  SelectCoinViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 28/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - SelectCoinViewController
final class SelectCoinViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Variables

    private var presenter: SelectCoinPresenterInterface {
        return presenterInterface as! SelectCoinPresenterInterface
    }

    private var coins = [Coin]()

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.selectCoin()
        tableView.tableFooterView = UIView()
        tableView.register(R.nib.selectCoinTableViewCell)
    }
}

// MARK: - UITableViewDataSource
extension SelectCoinViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.selectCoinTableViewCell, for: indexPath)!
        cell.coin = coins[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectCoinViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didTapCoin(coins[indexPath.row])
    }
}

// MARK: - SelectCoinViewInterface
extension SelectCoinViewController: SelectCoinViewInterface {

    func showCoins(_ coins: [Coin]) {
        self.coins = coins
        tableView.reloadData()
    }
}
