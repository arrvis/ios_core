//
//  UserProfileCoinViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

final class UserProfileCoinViewController: AppBasePagerTabStripViewController {

    // MARK: - Variables

    override var tabs: [(AppScreens, Any)] {
        return [
            (AppScreens.coinHistoryList, (CoinHistoryListType.received, userId)),
            (AppScreens.coinHistoryList, (CoinHistoryListType.send, userId))
        ]
    }

    var userId: String!
}
