//
//  AppBasePagerTabStripViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import XLPagerTabStrip

class AppBasePagerTabStripViewController: ButtonBarPagerTabStripViewController {

    // MARK: - Variables

    open var tabs: [(AppScreens, Any)] {
        return []
    }

    // MARK: - Life-Cycle

    open override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = AppStyles.colorWhite
        settings.style.buttonBarItemBackgroundColor = AppStyles.colorWhite
        settings.style.selectedBarBackgroundColor = AppStyles.colorRed
        settings.style.buttonBarItemFont = AppStyles.fontBold
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = AppStyles.colorText
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarHeight = 44

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = AppStyles.colorText
            newCell?.label.textColor = AppStyles.colorRed
        }

        super.viewDidLoad()
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.onDidFirstLayoutSubviews()
            }).disposed(by: self)
    }

    open func onDidFirstLayoutSubviews() {}

    // MARK: - PagerTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return tabs.map { $0.0.createViewController($0.1) }
    }
}
