//
//  HomeTopViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit
import XLPagerTabStrip

// MARK: - HomeTopViewController
final class HomeTopViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var btnUserIcon: UIButton!
    @IBOutlet weak private var labelUserName: AppLabel!
    @IBOutlet weak private var labelTitle: AppLabel!
    @IBOutlet weak private var labelComment: AppLabel!
    @IBOutlet weak private var labelClappers: AppLabel!
    @IBOutlet weak private var labelUseablePoints: AppLabel!
    @IBOutlet weak private var viewPointsBar: UIView!
    @IBOutlet weak private var widthOfCurrentPointsBar: NSLayoutConstraint!
    @IBOutlet weak private var labelCurrentPoints: AppLabel!
    @IBOutlet weak private var labelTotalPoints: AppLabel!
    @IBOutlet weak private var heightOfCoinHistoryList: NSLayoutConstraint!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var containerView: UIView!

    // MARK: - Variables

    private var presenter: HomeTopPresenterInterface {
        return presenterInterface as! HomeTopPresenterInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.home()
        view.isHidden = true
        btnUserIcon.imageView?.contentMode = .scaleAspectFill
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HomeCoinViewController {
            vc.rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:))).subscribe(onNext: { [unowned self] _ in
                vc.viewControllers.compactMap { $0 as? CoinHistoryListViewController }.forEach { coinVC in
                    coinVC.didContentSizeChanged.subscribe(onNext: { size in
                        coinVC.isScrollEnabled = false
                        if coinVC == vc.viewControllers[vc.currentIndex] {
                            self.heightOfCoinHistoryList.constant = max(vc.buttonBarView.bounds.height + size.height, self.scrollView.frame.height - self.containerView.frame.origin.y)
                        }
                    }).disposed(by: self)
                }
            }).disposed(by: self)
        }
    }

    // MARK: - Overrides

    override func didTapLeftBarButtonItem(_ index: Int) {
        presenter.didTapLatestNotifications()
    }

    // MARK: - Action

    @IBAction private func didTapChangeIcon(_ sender: Any) {
        presenter.didTapChangeIcon()
    }

    @IBAction func didTapEditComment(_ sender: Any) {
        presenter.didTapEditComment()
    }

    @IBAction func didTapExchangeCoin(_ sender: Any) {
        presenter.didTapExchangeCoin()
    }
}

// MARK: - HomeTopViewInterface
extension HomeTopViewController: HomeTopViewInterface {

    func showLoginUser(_ loginUser: UserData) {
        if let icon = loginUser.data.attributes.icon {
            btnUserIcon.setImageWithUrlString(for: .normal, icon)
        }
        labelUserName.text = loginUser.data.attributes.fullName
        labelTitle.text = loginUser.title
        labelComment.text = loginUser.data.attributes.comment
        labelClappers.text = loginUser.data.attributes.totalReceivedClappers.toNumberString()
        labelUseablePoints.text = loginUser.data.attributes.useablePoints.toNumberString()
        NSObject.runOnMainThread { [unowned self] in
            self.widthOfCurrentPointsBar.constant = CGFloat(loginUser.data.attributes.presentablePoints) / CGFloat(loginUser.role.coinSendablePerMonthNumber) * self.viewPointsBar.frame.width
        }
        labelCurrentPoints.text = loginUser.data.attributes.presentablePoints.toNumberString()
        labelTotalPoints.text = "/\(loginUser.role.coinSendablePerMonthNumber.toNumberString())"
        view.isHidden = false
    }
}
