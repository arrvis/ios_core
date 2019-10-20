//
//  SystemScreens.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/09/14.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

/// システムスクリーン
public enum SystemScreens: String, CaseIterable, Screen {
    case alert
    case actionSheet
    case activity
    case imagePicker

    public var path: String {
        return rawValue
    }

    public var transition: NavigateTransions {
        switch self {
        case .imagePicker, .alert, .actionSheet, .activity:
            return .present
        }
    }

    public func createViewController(_ payload: Any? = nil) -> UIViewController {
        switch self {
        case .alert:
            guard let payload = payload as? AlertInfo else {
                fatalError("required payload type AlertInfo")
            }
            return payload.createAlertController(.alert)
        case .actionSheet:
            guard let payload = payload as? AlertInfo else {
                fatalError("required payload type AlertInfo")
            }
            return payload.createAlertController(.actionSheet)
        case .activity:
            guard let payload = payload as? ActivityInfo else {
                fatalError("required payload type ActivityInfo")
            }
            return payload.createActivityViewController()
        case .imagePicker:
            guard let payload = payload as? ImagePickerInfo else {
                fatalError("required payload type ImagePickerInfo")
            }
            return payload.createImagePickerController()
        }
    }
}

/// Alert情報
public struct AlertInfo {

    /// タイトル
    public let title: String?

    /// メッセージ
    public let message: String?

    /// アクション
    public let actions: [String: (UIAlertAction.Style, () -> Void)]

    /// キャンセルタイトル
    public let cancel: String?

    /// キャンセルハンドラー
    public let onCancel: (() -> Void)?

    /// UIAlertController生成
    ///
    /// - Parameter preferredStyle: preferredStyle
    /// - Returns: UIAlertController
    public func createAlertController(_ preferredStyle: UIAlertController.Style) -> UIAlertController {
        let vc =  UIAlertController(title: nil, message: nil, preferredStyle: preferredStyle)
        vc.title = title
        vc.message = message
        var actions = self.actions.map { pair -> UIAlertAction in
            return UIAlertAction(title: pair.key, style: pair.value.0, handler: { _ in
                pair.value.1()
            })
        }
        if let cancel = cancel {
            let cancelAction = UIAlertAction(title: cancel, style: .destructive, handler: { _ in
                self.onCancel?()
            })
            if vc.preferredStyle == .alert {
                actions.insert(cancelAction, at: 0)
            } else {
                actions.append(cancelAction)
            }
        }
        vc.popoverPresentationController?.sourceView = vc.view
        vc.popoverPresentationController?.sourceRect = CGRect(
            x: vc.view.frame.midX,
            y: vc.view.frame.midY,
            width: 0,
            height: 0
        )
        vc.popoverPresentationController?.permittedArrowDirections = []
        actions.forEach { vc.addAction($0) }
        return vc
    }
}

/// Activity情報
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

/// ImagePicker情報
public struct ImagePickerInfo {

    /// delegate
    public weak var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?

    /// sourceType
    public let sourceType: UIImagePickerController.SourceType

    /// mediaTypes
    public let mediaTypes: [CFString]

    /// UIImagePickerController生成
    ///
    /// - Returns: UIImagePickerController
    public func createImagePickerController() -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.delegate = delegate
        vc.sourceType = sourceType
        vc.mediaTypes = mediaTypes as [String]
        return vc
    }
}
