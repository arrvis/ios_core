//
//  RequestPermissionsViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - RequestPermissionsViewController
final class RequestPermissionsViewController: ViewBase {

    // MARK: - Outlet

    @IBOutlet weak private var imageView: UIImageView!

    // MARK: - Variables

    private var presenter: RequestPermissionsPresenterInterface {
        return presenterInterface as! RequestPermissionsPresenterInterface
    }

    // MARK: - Actions

    @IBAction private func didTapNext(_ sender: Any) {
        presenter.didTapNext()
    }
}

// MARK: - RequestPermissionsViewInterface
extension RequestPermissionsViewController: RequestPermissionsViewInterface {

    func showRequestNotificationAuthorization() {
        title = R.string.localizable.requestPermissionsTitleNotification()
        imageView.image = R.image.requestNotificationAuthorization()
    }

    func showRequestLocationAuthorization() {
        title = R.string.localizable.requestPermissionsTitleLocation()
        imageView.image = R.image.requestLocationAuthorization()
    }
}
