//
//  SplashViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - SplashViewController
final class SplashViewController: ViewBase {

    // MARK: - Variables

    private var presenter: SplashPresenterInterface {
        return presenterInterface as! SplashPresenterInterface
    }
}

// MARK: - SplashViewInterface
extension SplashViewController: SplashViewInterface {
}
