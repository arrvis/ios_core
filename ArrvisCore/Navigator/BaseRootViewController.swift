//
//  BaseRootViewController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/09/18.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ios_extensions

/// ルートViewController基底クラス
open class BaseRootViewController: UIViewController {

    /// DisposeBag
    public let disposeBag = DisposeBag()

    /// layoutSubViewsが終わったか
    private(set) var didLayoutSubviews = false

    /// カレントのルートViewController
    public var currentRootViewController: UIViewController?

    private var currentRootNavigationController: UINavigationController? {
        if let current = currentRootViewController as? UINavigationController {
            return current
        } else if let current = currentRootViewController as? UITabBarController,
            let selected = current.selectedViewController as? UINavigationController {
            return selected
        }
        return nil
    }

    /// Navigator
    public private(set) var navigator: BaseNavigator!

    public convenience init(navigator: BaseNavigator) {
        self.init(nibName: nil, bundle: nil)
        self.navigator = navigator

        navigator.replace.subscribe(onNext: { [unowned self] vc in
            self.replaceChildViewController(vc)
        }).disposed(by: disposeBag)

        navigator.push.subscribe(onNext: { [unowned self] vc, fromRoot, animate in
            self.pushChildViewController(vc, fromRoot, animate)
        }).disposed(by: disposeBag)
        navigator.pop.subscribe(onNext: { [unowned self] result, animate in
            self.popChildViewController(result, animate)
        }).disposed(by: disposeBag)

        navigator.present.subscribe(onNext: { [unowned self] vc, animate in
            self.presentChildViewController(vc, animate)
            // 左上に閉じるボタンを追加
            let buttonDismiss = UIBarButtonItem(barButtonSystemItem: .stop)
            buttonDismiss.rx.tap.subscribe(onNext: { [weak self] in
                self?.dismisssChildViewController(nil, true)
            }).disposed(by: self.disposeBag)
            if let top = (vc as? UINavigationController)?.topViewController {
                top.navigationItem.leftBarButtonItem = buttonDismiss
            } else {
                vc.navigationItem.leftBarButtonItem = buttonDismiss
            }
        }).disposed(by: disposeBag)
        navigator.dismiss.subscribe(onNext: { [unowned self] result, animate in
            self.dismisssChildViewController(result, animate)
        }).disposed(by: disposeBag)
    }

    // MARK: - open

    open func currentViewController(from: UIViewController? = nil) -> UIViewController? {
        if let from = from {
            if let presented = from.presentedViewController {
                return currentViewController(from: presented)
            }
            if let nav = from as? UINavigationController {
                if let last = nav.children.last {
                    return currentViewController(from: last)
                }
                return nav
            }
            if let tab = from as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return currentViewController(from: selected)
                }
                return tab
            }
            return from
        } else if let presented = presentedViewController {
            return currentViewController(from: presented)
        } else if let currentRootViewController = currentRootViewController {
            return currentViewController(from: currentRootViewController)
        } else {
            return nil
        }
    }

    // MARK: - Life-Cycle

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        didLayoutSubviews = true
    }
}

// MARK: - GetViewController
extension BaseRootViewController {

    private func currentNavigationController(from: UIViewController?) -> UINavigationController? {
        if let from = from {
            if let nav = from as? UINavigationController {
                return nav
            }
            if let navigationController = from.navigationController {
                return navigationController
            }
            if let parent = from.parent {
                return currentNavigationController(from: parent)
            }
            return nil
        } else {
            return currentNavigationController(from: currentViewController(from: from)!)
        }
    }

}

// MARK: - Navigate
extension BaseRootViewController {

    public func replaceChildViewController(_ vc: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
        func change() {
            addChild(vc)
            view.addSubviewWithFit(vc.view)
            vc.didMove(toParent: self)
            currentRootViewController = vc
        }

        if let current = currentRootViewController {
            current.willMove(toParent: nil)
            change()
            current.view.removeFromSuperview()
            current.removeFromParent()
        } else {
            change()
        }
    }

    public func pushChildViewController(_ vc: UIViewController, _ fromRoot: Bool, _ animate: Bool) {
        if fromRoot {
            currentRootNavigationController?.pushViewController(vc, animated: animate)
        } else {
            currentNavigationController(from: nil)?.pushViewController(vc, animated: animate)
        }
    }

    public func popChildViewController(_ result: Any?, _ animate: Bool) {
        currentViewController()?.navigationController?.popViewController(animated: animate)

        func completed() {
            if let current = currentViewController() {
                setBackResultIfCan(vc: current, result: result)
            }
        }

        if let coordinator = currentViewController()?.navigationController?.transitionCoordinator, animate {
            coordinator.animate(alongsideTransition: nil) { _ in
                completed()
            }
        } else {
            completed()
        }
    }

    public func presentChildViewController(_ vc: UIViewController, _ animate: Bool) {
        currentViewController()?.present(vc, animated: animate)
    }

    public func dismisssChildViewController(_ result: Any?, _ animate: Bool, _ completion: (() -> Void)? = nil) {
        currentViewController()?.dismiss(animated: animate, completion: { [unowned self] in
            if let current = self.currentViewController() {
                self.setBackResultIfCan(vc: current, result: result)
            }
            completion?()
        })
    }
}

// MARK: - Private
extension BaseRootViewController {

    private func setBackResultIfCan(vc: UIViewController, result: Any?) {
        guard let backFromNextHandleable = vc as? BackFromNextHandleable else {
            return
        }
        backFromNextHandleable.onBackFromNext(result)
    }
}
