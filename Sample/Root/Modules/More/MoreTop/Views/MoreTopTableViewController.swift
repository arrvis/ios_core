//
//  MoreTopTableViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/10.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TinyConstraints

final class MoreTopTableViewController: AppTableViewController {

    // MARK: - Outlets

    @IBOutlet weak private var imageViewUserIcon: UIImageView!
    @IBOutlet weak private var labelUserName: AppLabel!
    @IBOutlet weak private var labelNotificationStatus: AppLabel!

    // MARK: - Variables

    var didTapHelp: Observable<Void> {
        return didTapHelpSubject
    }
    private let didTapHelpSubject = PublishSubject<Void>()

    var didTapChangeTextSize: Observable<Void> {
        return didTapChangeTextSizeSubject
    }
    private let didTapChangeTextSizeSubject = PublishSubject<Void>()

    var didTapNotificationEnabled: Observable<Void> {
        return didTapNotificationEnabledSubject
    }
    private let didTapNotificationEnabledSubject = PublishSubject<Void>()

    // MARK: - Overrides

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = AppLabel()
        label.appearanceType = AppLabel.AppearanceType.primary.rawValue
        label.font = AppStyles.fontBold.withSize(13)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        view.addSubview(label)
        label.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 0, left: 18, bottom: 7, right: 0))
        return view
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                didTapHelpSubject.onNext(())
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                didTapChangeTextSizeSubject.onNext(())
            } else if indexPath.row == 2 {
                didTapNotificationEnabledSubject.onNext(())
            }
        }
    }

    // MARK: - Methods

    func showLoginUser(_ loginUser: UserData) {
        if let icon = loginUser.data.attributes.icon {
            imageViewUserIcon.af_setImage(withURL: URL(string: icon)!)
        }
        labelUserName.text = loginUser.data.attributes.fullName
    }

    func showNotificationEnabled(_ enabled: Bool) {
        labelNotificationStatus.text = enabled ? R.string.localizable.on() : R.string.localizable.off()
    }
}
