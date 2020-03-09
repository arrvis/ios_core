//
//  CoinTabViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/25.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

final class CoinTabViewController: AppBasePagerTabStripViewController {

    // MARK: - Variables

    override var tabs: [(AppScreens, Any)] {
        return [
            (AppScreens.coinHistoryList, CoinHistoryListType.all),
            (AppScreens.coinHistoryList, CoinHistoryListType.department)
        ]
    }

    // MARK: - Life-Cycle

    override func onDidFirstLayoutSubviews() {
        super.onDidFirstLayoutSubviews()
        moveToViewController(at: 1, animated: false)
    }
}
