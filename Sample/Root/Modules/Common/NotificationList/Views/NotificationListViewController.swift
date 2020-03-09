//
//  NotificationListViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - NotificationListViewController
final class NotificationListViewController: ViewBase {

    // MARK: - Variables

    private var presenter: NotificationListPresenterInterface {
        return presenterInterface as! NotificationListPresenterInterface
    }
}

// MARK: - NotificationListViewInterface
extension NotificationListViewController: NotificationListViewInterface {
}
