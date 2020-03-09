//
//  AppBaseViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/10/01.
//  Copyright © 2019 grabss All rights reserved.
//

import ArrvisCore
import LifetimeTracker

/// アプリViewController基底クラス
open class AppBaseViewController: BaseViewController, LifetimeTrackable {

    public class var lifetimeConfiguration: LifetimeConfiguration {
        return LifetimeConfiguration(maxCount: 1, groupName: "VC")
    }

    // MARK: - Life-Cycle

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        trackLifetime()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
//        trackLifetime()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        configureStatusBar()
        configureNavigationItem()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.refreshFontSize()
    }
}

// MARK: - UIViewController Extension
extension UIViewController {

    /// ステータスバー設定
    func configureStatusBar() {
        UIApplication.shared.statusBarUIView?.backgroundColor = AppStyles.colorWhite
    }

    /// NavigationItem設定
    func configureNavigationItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems?.forEach({ item in
           item.setTitleTextAttributes([
               NSAttributedString.Key.font: AppStyles.fontBold.withSize(17 * fontScaleRatio)
           ], for: .normal)
       })
    }

    /// RightBarButtonItemsをBlueに
    func configureRightItemsToBlue() {
        navigationItem.rightBarButtonItems?.forEach({ item in
            item.tintColor = AppStyles.colorBlue
        })
    }
}

private var originalFontKey = 0

extension UIView {

    var originalFont: UIFont? {
        get {
            return objc_getAssociatedObject(self, &originalFontKey) as? UIFont
        }
        set {
            objc_setAssociatedObject(self, &originalFontKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func refreshFontSize() {
        func refresh(_ subview: UIView) {
            if let label = subview as? UILabel {
                if label.originalFont == nil {
                    label.originalFont = label.font
                }
                label.font = label.originalFont!.withSize(label.originalFont!.pointSize * fontScaleRatio)
            } else if let button = subview as? UIButton, let label = button.titleLabel {
                refresh(label)
            } else if let textView = subview as? UITextView {
                if textView.originalFont == nil {
                    textView.originalFont = textView.font
                }
                textView.font = textView.originalFont!.withSize(textView.originalFont!.pointSize * fontScaleRatio)
            } else if let textField = subview as? UITextField {
                if textField.originalFont == nil {
                    textField.originalFont = textField.font
                }
                textField.font = textField.originalFont!.withSize(textField.originalFont!.pointSize * fontScaleRatio)
            } else if let search = subview as? UISearchBar {
                if let v = search.inputAccessoryView {
                    getChilds(v).forEach { subview in
                        refresh(subview)
                    }
                }
            }
        }
        getChilds(self).forEach { subview in
            refresh(subview)
        }
    }

    private func getChilds(_ view: UIView) -> [UIView] {
        return view.subviews.flatMap { subview in
            return getChilds(subview)
        } + view.subviews
    }
}
