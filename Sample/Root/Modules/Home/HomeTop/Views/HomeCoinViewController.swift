//
//  HomeCoinViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

final class HomeCoinViewController: AppBasePagerTabStripViewController {

    // MARK: - Variables

    override var tabs: [(AppScreens, Any)] {
        return [
            (AppScreens.coinHistoryList, CoinHistoryListType.received),
            (AppScreens.coinHistoryList, CoinHistoryListType.send)
        ]
    }
}
