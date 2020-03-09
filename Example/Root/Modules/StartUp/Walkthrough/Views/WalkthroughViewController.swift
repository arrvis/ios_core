//
//  WalkthroughViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - WalkthroughViewController
final class WalkthroughViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var btnNext: AppButton!
    @IBOutlet weak private var stackViewPage: UIStackView!

    // MARK: - Variables

    private var presenter: WalkthroughPresenterInterface {
        return presenterInterface as! WalkthroughPresenterInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshPager()
    }

    // MARK: - Actions

    @IBAction private func didTapNext(_ sender: Any) {
        if scrollView.isLastHorizontalPage {
            presenter.didTapNext()
        } else {
            scrollView.scrollToHorizontalNextPage(duration: 0.3) { [unowned self] in
                self.refreshPager()
            }
        }
    }

    // MARK: - Private

    private func refreshPager() {
        stackViewPage.arrangedSubviews.enumerated().forEach { offset, subview in
            subview.backgroundColor = offset == scrollView.currentHorizontalPage ? AppStyles.colorMoveBlue : AppStyles.colorLineGray
        }
        btnNext.setTitle(scrollView.isLastHorizontalPage ? R.string.localizable.walkthroughStart() : R.string.localizable.next(), for: .normal)
    }
}

// MARK: - UIScrollViewDelegate
extension WalkthroughViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        refreshPager()
    }
}

// MARK: - WalkthroughViewInterface
extension WalkthroughViewController: WalkthroughViewInterface {
}
