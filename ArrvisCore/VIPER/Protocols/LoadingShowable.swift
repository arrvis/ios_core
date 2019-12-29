//
//  LoadingShowable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import TinyConstraints

public protocol LoadingShowable {}

extension LoadingShowable where Self: UIViewController {

    public func showLoading(
        message: String? = nil,
        _ needFullScreen: Bool = false,
        _ usingSafeArea: Bool = false) {
        view.endEditing(true)
        if needFullScreen {
            ActivityIndicatorManager.shared.show(
                parent: UIApplication.shared.keyWindow!,
                message: message,
                usingSafeArea: usingSafeArea)
        } else {
            ActivityIndicatorManager.shared.show(parent: view, message: message, usingSafeArea: usingSafeArea)
        }
    }

    public func hideLoading() {
        ActivityIndicatorManager.shared.hide()
    }
}

private struct ActivityIndicatorManager {

    static let shared: ActivityIndicatorManager = {
        return ActivityIndicatorManager()
    }()

    private var container: UIView
    private var indicator: UIActivityIndicatorView
    private var label: UILabel

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

extension ActivityIndicatorManager {

    func show(parent: UIView, message: String? = nil, usingSafeArea: Bool = false) {
        label.text = message
        indicator.startAnimating()
        parent.addSubviewWithFit(container, usingSafeArea: usingSafeArea)
    }

    func hide() {
        indicator.stopAnimating()
        container.removeFromSuperview()
    }
}
