//
//  ActivityIndicatorManager.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import TinyConstraints
import ios_extensions

/// インディケーター管理
public struct ActivityIndicatorManager {

    // MARK: - Variables

    /// 共有インスタンス
    public static let shared: ActivityIndicatorManager = {
        return ActivityIndicatorManager()
    }()

    private var container: UIView
    private var indicator: UIActivityIndicatorView
    private var label: UILabel

    // MARK: - Initializer

    private init() {
        container = UIView()
        container.backgroundColor = UIColor(white: 1, alpha: 0.5)

        let loadingView = UIView()
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.size(CGSize(width: 80, height: 80))
        container.addSubviewToCenter(loadingView)

        indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.size(CGSize(width: 40, height: 40))
        loadingView.addSubviewToCenter(indicator)

        label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.sizeToFit()
        label.textAlignment = .center
        loadingView.addSubview(label)
        label.edgesToSuperview(excluding: .top)
        label.height(label.bounds.height)
    }
}

// MARK: - Public
extension ActivityIndicatorManager {

    /// 表示
    ///
    /// - Parameters:
    ///   - parent: 親
    ///   - message: メッセージ
    public func show(parent: UIView, message: String? = nil) {
        label.text = message
        indicator.startAnimating()
        parent.addSubviewWithFit(container)
    }

    /// 非表示
    public func hide() {
        indicator.stopAnimating()
        container.removeFromSuperview()
    }
}
