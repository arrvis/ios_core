//
//  LatestNotificationsViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 23/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - LatestNotificationsViewController
final class LatestNotificationsViewController: ViewBase {

    // MARK: - Variables

    private var presenter: LatestNotificationsPresenterInterface {
        return presenterInterface as! LatestNotificationsPresenterInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.latestNotifications()
    }
}

// MARK: - LatestNotificationsViewInterface
extension LatestNotificationsViewController: LatestNotificationsViewInterface {
}
