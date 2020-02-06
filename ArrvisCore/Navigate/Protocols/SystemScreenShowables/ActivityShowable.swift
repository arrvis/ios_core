//
//  ActivityShowable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2020/02/07.
//  Copyright © 2020 Arrvis Co., Ltd. All rights reserved.
//

public struct ActivityInfo {

    /// activityItems
    public let activityItems: [Any]

    /// applicationActivities
    public let applicationActivities: [UIActivity]?

    /// excludedActivityTypes
    public let excludedActivityTypes: [UIActivity.ActivityType]?

    /// UIActivityViewController生成
    ///
    /// - Returns: UIActivityViewController
    public func createActivityViewController() -> UIActivityViewController {
        let vc = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        vc.excludedActivityTypes = excludedActivityTypes
        vc.popoverPresentationController?.sourceView = vc.view
        vc.popoverPresentationController?.sourceRect = CGRect(
            x: vc.view.frame.midX,
            y: vc.view.frame.midY,
            width: 0,
            height: 0
        )
        vc.popoverPresentationController?.permittedArrowDirections = []
        return vc
    }
}

public protocol ActivityShowable {
    func showActivityScreen(_ activityInfo: ActivityInfo)
}

extension ActivityShowable {

    public func showActivityScreen(
        _ activityItems: [Any] = [],
        _ applicationActivities: [UIActivity]? = nil,
        _ excludedActivityTypes: [UIActivity.ActivityType]? = nil) {
        let activityInfo = ActivityInfo(
            activityItems: activityItems,
            applicationActivities: applicationActivities,
            excludedActivityTypes: excludedActivityTypes
        )
        showActivityScreen(activityInfo)
    }
}
