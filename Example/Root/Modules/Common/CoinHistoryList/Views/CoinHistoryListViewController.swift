//
//  CoinHistoryListViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import XLPagerTabStrip
import RxSwift
import TinyConstraints

// MARK: - CoinHistoryListViewController
final class CoinHistoryListViewController: ViewBase, IndicatorInfoProvider {

    // MARK: - Outlets

    @IBOutlet weak private var tableView: UITableView!

    // MARK: - Variables

    var didContentSizeChanged: Observable<CGSize> {
        return didContentSizeChangedSubject
    }
    private let didContentSizeChangedSubject = PublishSubject<CGSize>()

    var isScrollEnabled = true {
        didSet {
            tableView.isScrollEnabled = isScrollEnabled
        }
    }

    private var presenter: CoinHistoryListPresenterInterface {
        return presenterInterface as! CoinHistoryListPresenterInterface
    }

    private var presents = [Present]()
    private var coins = [Coin]()
    private var users = [UserRelation]()
    private var loginUser: UserData!

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: title)
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(R.nib.coinHistoryTableViewCell)
        tableView.rx.observe(CGSize.self, "contentSize").compactMap { $0 }.subscribe(onNext: { [unowned self] size in
            NSObject.runAfterDelay(delayMSec: 100) {
                self.didContentSizeChangedSubject.onNext(size)
            }
        }).disposed(by: self)
    }
}

// MARK: - CoinHistoryListViewInterface
extension CoinHistoryListViewController: CoinHistoryListViewInterface {

    func showType(_ type: CoinHistoryListType) {
        switch type {
        case .received:
            title = R.string.localizable.coinHistoryListReceived()
        case .send:
            title = R.string.localizable.coinHistoryListSend()
        case .all:
            title = R.string.localizable.coinHistoryListAll()
        case .department:
            title = R.string.localizable.coinHistoryListDepartment()
        }
    }

    func showCoinHistoryList(_ data: [Present], _ coins: [Coin], _ users: [UserRelation], _ loginUser: UserData) {
        presents = data
        self.coins = coins
        self.users = users
        self.loginUser = loginUser
        tableView.reloadData()
    }

    func showMoreCoinHistoryList(_ data: [Present], _ coins: [Coin], _ users: [UserRelation], _ loginUser: UserData) {
        presents = (presents + data).distinct()
        self.coins = (self.coins + coins).distinct()
        self.users = (self.users + users).distinct()
        self.loginUser = loginUser
        tableView.reloadData()
    }

    func updateData(_ present: Present) {
        let index = presents.firstIndex(of: present)!
        presents.remove(at: index)
        presents.insert(present, at: index)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CoinHistoryListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presents.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.coinHistoryTableViewCell, for: indexPath)!
        cell.refreshFontSize()
        let present = presents[indexPath.section]
        let isClapped = present.attributes.clapperIds.contains(Int(loginUser.data.id)!)
        cell.setData(present, coins, users, isClapped, loginUser)
        cell.didTapUser = { [unowned self] userId in
            self.presenter.didTapUser(userId)
        }
        cell.didTapRemoveClap = { [unowned self] in
            self.presenter.didTapRemoveClap(present)
        }
        cell.didTapAddClap = { [unowned self] in
            self.presenter.didTapAddClap(present)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CoinHistoryListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

// MARK: - UIScrollViewDelegate
extension CoinHistoryListViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !tableView.isDragging {
            return
        }
        if tableView.contentOffset.y + tableView.frame.size.height > tableView.contentSize.height {
            presenter.didReachBottom()
        }
    }
}
