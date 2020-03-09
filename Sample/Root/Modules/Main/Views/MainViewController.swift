//
//  MainViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit
import ArrvisCore
import SwiftEventBus

// MARK: - MainViewController
final class MainViewController: TabBarViewBase {

    // MARK: - Variables

    private var presenter: MainPresenterInterface {
        return presenterInterface as! MainPresenterInterface
    }

    private let tabs: [(AppScreens, UIImage, String)] = [
        (AppScreens.homeTop, R.image.tabIconHome()!, R.string.localizable.home()),
        (AppScreens.groupTop, R.image.tabIconGroup()!, R.string.localizable.group()),
        (AppScreens.notificationTop, R.image.tabIconNotification()!, R.string.localizable.notification()),
        (AppScreens.coinTop, R.image.tabIconCoin()!, R.string.localizable.coin()),
        (AppScreens.moreTop, R.image.tabIconMore()!, R.string.localizable.more())
    ]

    // MARK: - Life-Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - MainViewInterface
extension MainViewController: MainViewInterface {

    func showViewControllers() {
        setViewControllers(tabs.map {$0.0.createViewController() }, animated: false)
        var index = 0
        tabBar.items?.forEach({ item in
            item.image = tabs[index].1
            item.title = tabs[index].2
            index += 1
        })
    }

    func showBadgeCounts(_ footer: Footer) {
        guard let items = tabBar.items, items.count == 5 else {
            NSObject.runAfterDelay(delayMSec: 100) { [weak self] in
                self?.showBadgeCounts(footer)
            }
            return
        }
        items[1].badgeValue = footer.notReadMessagesCount == 0 ? nil : String(footer.notReadMessagesCount)
        items[2].badgeValue = footer.notReadNotificationsCount == 0 ? nil : String(footer.notReadNotificationsCount)
        items[3].badgeValue = footer.hasNewPresent ? "N" : nil
    }
}
