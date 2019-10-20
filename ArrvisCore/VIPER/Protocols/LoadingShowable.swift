//
//  LoadingShowable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import TinyConstraints

public protocol LoadingShowable {
    func showLoading()
    func showLoading(_ needFullScreen: Bool)
    func showLoading(message: String)
    func showLoading(message: String, _ needFullScreen: Bool)
    func hideLoading()
}

extension LoadingShowable where Self: UIViewController {

    public func showLoading() {
        showLoading(false)
    }

    public func showLoading(_ needFullScreen: Bool) {
        view.endEditing(true)
        if needFullScreen {
            ActivityIndicatorManager.shared.show(parent: UIApplication.shared.keyWindow!)
        } else if let superview = view.superview {
            ActivityIndicatorManager.shared.show(parent: superview)
        }
    }

    func showLoading(message: String) {
        showLoading(message: message, false)
    }

    public func showLoading(message: String, _ needFullScreen: Bool = false) {
        view.endEditing(true)
        if needFullScreen {
            ActivityIndicatorManager.shared.show(parent: UIApplication.shared.keyWindow!)
        } else if let superview = view.superview {
            ActivityIndicatorManager.shared.show(parent: superview, message: message)
        }
    }

    public func hideLoading() {
        ActivityIndicatorManager.shared.hide()
    }
}

struct ActivityIndicatorManager {

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

    func show(parent: UIView, message: String? = nil) {
        label.text = message
        indicator.startAnimating()
        parent.addSubviewWithFit(container)
    }

    func hide() {
        indicator.stopAnimating()
        container.removeFromSuperview()
    }
}
