//
//  SystemScreens.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/09/14.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

/// システムスクリーン
public enum SystemScreens: String, CaseIterable, Screen {
    case imagePicker
    case alert
    case actionSheet
    case activity

    public var path: String {
        return rawValue
    }

    public var transition: NavigateTransions {
        switch self {
        case .imagePicker, .alert, .actionSheet, .activity:
            return .present
            //        default:
            //            return .push
        }
    }

    public func createViewController(_ payload: Any? = nil) -> UIViewController {
        switch self {
        case .imagePicker:
            guard let payload = payload as? (CameraRollDelegate, UIImagePickerController.SourceType, CFString) else {
                fatalError()
            }
            let vc = UIImagePickerController()
            vc.delegate = payload.0
            vc.sourceType = payload.1
            vc.mediaTypes = [payload.2 as String]
            return vc
        case .alert:
            return createUIAlertController(payload, .alert)
        case .actionSheet:
            return createUIAlertController(payload, .actionSheet)
        case .activity:
            guard let payload = payload as? ActivityInfo else {
                fatalError("invalid payload")
            }
            let vc = UIActivityViewController(activityItems: payload.activityItems,
                                              applicationActivities: payload.applicationActivities)
            vc.excludedActivityTypes = payload.excludedActivityTypes
            vc.popoverPresentationController?.sourceView = vc.view
            vc.popoverPresentationController?.sourceRect = CGRect(x: vc.view.frame.midX,
                                                                  y: vc.view.frame.midY,
                                                                  width: 0,
                                                                  height: 0)
            vc.popoverPresentationController?.permittedArrowDirections = []
            return vc
        }
    }

    private func createUIAlertController(_ payload: Any?,
                                         _ preferredStyle: UIAlertController.Style) -> UIAlertController {
        guard let payload = payload as? AlertInfo else {
            fatalError()
        }
        let vc =  UIAlertController(title: nil, message: nil, preferredStyle: preferredStyle)
        vc.title = payload.title
        vc.message = payload.message
        var actions = payload.actions.map { pair -> UIAlertAction in
            return UIAlertAction(title: pair.key, style: pair.value.0, handler: { _ in
                pair.value.1()
            })
        }
        if let cancel = payload.cancel {
            let cancelAction = UIAlertAction(title: cancel, style: .destructive, handler: { _ in
                payload.onCancel?()
            })
            if vc.preferredStyle == .alert {
                actions.insert(cancelAction, at: 0)
            } else {
                actions.append(cancelAction)
            }
        }
        vc.popoverPresentationController?.sourceView = vc.view
        vc.popoverPresentationController?.sourceRect = CGRect(x: vc.view.frame.midX,
                                                              y: vc.view.frame.midY,
                                                              width: 0,
                                                              height: 0)
        vc.popoverPresentationController?.permittedArrowDirections = []
        actions.forEach { vc.addAction($0) }
        return vc
    }
}

/// Alert情報
public struct AlertInfo {
    public let title: String?
    public let message: String?
    public let actions: [String: (UIAlertAction.Style, () -> Void)]
    public let cancel: String?
    public let onCancel: (() -> Void)?

    public init(title: String?,
                message: String?,
                actions: [String: (UIAlertAction.Style, () -> Void)],
                cancel: String?,
                onCancel: (() -> Void)?) {
        self.title = title
        self.message = message
        self.actions = actions
        self.cancel = cancel
        self.onCancel = onCancel
    }
}

/// Activity情報
public struct ActivityInfo {
    public let activityItems: [Any]
    public let applicationActivities: [UIActivity]?
    public let excludedActivityTypes: [UIActivity.ActivityType]?

    public init(activityItems: [Any],
                applicationActivities: [UIActivity]?,
                excludedActivityTypes: [UIActivity.ActivityType]?) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        self.excludedActivityTypes = excludedActivityTypes
    }
}

/// CameraRollDelegate
public protocol CameraRollDelegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func onFailAccessCamera()
    func onFailAccessPhotoLibrary()
}
