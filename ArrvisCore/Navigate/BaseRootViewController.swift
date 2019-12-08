//
//  BaseRootViewController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/09/18.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftEventBus

/// ルートViewController基底クラス
open class BaseRootViewController: UIViewController {

    // MARK: - Const

    /// Present時の閉じるボタンタイプ
    public enum PresentCloseButtonType {
        case none
        case left
        case right
    }

    // MARK: - Variables

    /// Present時の閉じるボタンタイプ
    open var presentCloseButtonType: PresentCloseButtonType {
        return .left
    }

    private var currentRootViewController: UIViewController?
    private var currentRootNavigationController: UINavigationController? {
        if let current = currentRootViewController as? UINavigationController {
            return current
        } else if let current = currentRootViewController as? UITabBarController,
            let selected = current.selectedViewController as? UINavigationController {
            return selected
        }
        return nil
    }

    private var navigator: BaseNavigator!

    // MARK: - Initializer

    public convenience init(navigator: BaseNavigator) {
        self.init(nibName: nil, bundle: nil)
        self.navigator = navigator

        navigator.replace.subscribe(onNext: { [unowned self] vc in
            self.replaceChildViewController(vc)
        }).disposed(by: self)

        navigator.push.subscribe(onNext: { [unowned self] vc, fromRoot, animate in
            self.pushChildViewController(vc, fromRoot, animate)
        }).disposed(by: self)
        navigator.pop.subscribe(onNext: { [unowned self] result, animate in
            self.popChildViewController(result, animate)
        }).disposed(by: self)
        navigator.popToRoot.subscribe(onNext: { [unowned self] result, animate in
            self.popToRoot(result, animate)
        }).disposed(by: self)

        navigator.present.subscribe(onNext: { [unowned self] vc, animate in
            self.presentChildViewController(vc, animate)
        }).disposed(by: self)
        navigator.dismiss.subscribe(onNext: { [unowned self] result, animate in
            self.dismisssChildViewController(result, animate)
        }).disposed(by: self)
    }

    // MARK: - Navigate

    /// Replace
    open func replaceChildViewController(_ vc: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
        subscribeEvents(vc)
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

    /// Push
    open func pushChildViewController(_ vc: UIViewController, _ fromRoot: Bool, _ animate: Bool) {
        subscribeEvents(vc)
        if fromRoot {
            currentRootNavigationController?.pushViewController(vc, animated: animate)
        } else {
            currentNavigationController(from: nil)?.pushViewController(vc, animated: animate)
        }
    }

    /// Pop
    open func popChildViewController(_ result: Any?, _ animate: Bool) {
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

    /// PopToRoot
    open func popToRoot(_ result: Any?, _ animate: Bool) {
        while currentViewController()?.navigationController?.popViewController(animated: animate) != nil {
        }

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

    /// Present
    open func presentChildViewController(_ vc: UIViewController, _ animate: Bool) {
        let buttonDismiss = UIBarButtonItem(barButtonSystemItem: .stop)
        buttonDismiss.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismisssChildViewController(nil, true)
        }).disposed(by: self.self)
        switch presentCloseButtonType {
        case .left:
            if let top = (vc as? UINavigationController)?.topViewController {
                top.navigationItem.leftBarButtonItem = buttonDismiss
            } else {
                vc.navigationItem.leftBarButtonItem = buttonDismiss
            }
        case .right:
            if let top = (vc as? UINavigationController)?.topViewController {
                top.navigationItem.rightBarButtonItem = buttonDismiss
            } else {
                vc.navigationItem.rightBarButtonItem = buttonDismiss
            }
        default:
            break
        }
        subscribeEvents(vc)
        currentViewController()?.present(vc, animated: animate)
    }

    /// Dismiss
    open func dismisssChildViewController(_ result: Any?, _ animate: Bool, _ completion: (() -> Void)? = nil) {
        currentViewController()?.dismiss(animated: animate, completion: { [unowned self] in
            if let current = self.currentViewController() {
                self.setBackResultIfCan(vc: current, result: result)
            }
            completion?()
        })
    }

    private func setBackResultIfCan(vc: UIViewController, result: Any?) {
        guard let ex = vc as? ExtendsViewControllerEventsHandleable else {
            return
        }
        ex.onBackFromNext(result)
    }

    private func subscribeEvents(_ vc: UIViewController) {
        vc.rx.methodInvoked(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .subscribe(onNext: { _ in
                SwiftEventBus.post(SystemBusEvents.currentViewControllerChanged)
            }).disposed(by: self)
        vc.rx.methodInvoked(#selector(UIViewController.dismiss))
            .subscribe(onNext: { _ in
                SwiftEventBus.post(SystemBusEvents.currentViewControllerChanged)
            }).disposed(by: self)
    }
}

// MARK: - Private
extension BaseRootViewController {

    private func currentViewController(from: UIViewController? = nil) -> UIViewController? {
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
