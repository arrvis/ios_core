//
//  AlertShowable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2020/02/07.
//  Copyright © 2020 Arrvis Co., Ltd. All rights reserved.
//

public struct AlertInfo {

    /// タイトル
    public let title: String?

    /// メッセージ
    public let message: String?

    /// アクション
    public let actions: [UIAlertAction]

    /// キャンセルタイトル
    public let cancel: String?

    /// キャンセルハンドラー
    public let onCancel: (() -> Void)?

    /// UIAlertController生成
    public func createAlertController(_ preferredStyle: UIAlertController.Style) -> UIAlertController {
        let vc =  UIAlertController(title: nil, message: nil, preferredStyle: preferredStyle)
        vc.title = title
        vc.message = message
        var mutableActions = actions
        if let cancel = cancel {
            let cancelAction = UIAlertAction(title: cancel, style: .destructive, handler: { _ in
                self.onCancel?()
            })
            if vc.preferredStyle == .alert {
                mutableActions.insert(cancelAction, at: 0)
            } else {
                mutableActions.append(cancelAction)
            }
        }
        mutableActions.forEach { vc.addAction($0) }
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

public protocol AlertShowable {
    func showAlert(_ alertInfo: AlertInfo)
}

extension AlertShowable {

    public func showOkAlert(
        _ title: String? = nil,
        _ message: String? = nil,
        _ ok: String,
        _ onOk: (() -> Void)? = nil) {
        let alertInfo = AlertInfo(
            title: title,
            message: message,
            actions: [
                UIAlertAction(title: ok, style: .default, handler: { _ in
                    onOk?()
                })
            ],
            cancel: nil,
            onCancel: nil
        )
        showAlert(alertInfo)
    }

    public func showConfirmAlert(
        _ title: String? = nil,
        _ message: String? = nil,
        _ ok: String,
        _ onOk: @escaping () -> Void,
        _ cancel: String,
        _ onCancel: (() -> Void)? = nil) {
        let alertInfo = AlertInfo(
            title: title,
            message: message,
            actions: [
                UIAlertAction(title: ok, style: .default, handler: { _ in
                    onOk()
                })
            ],
            cancel: cancel,
            onCancel: onCancel
        )
        showAlert(alertInfo)
    }

    public func showAlert(
        _ title: String? = nil,
        _ message: String? = nil,
        _ actions: [UIAlertAction],
        _ cancel: String,
        _ onCancel: (() -> Void)? = nil) {
        let alertInfo = AlertInfo(
            title: title,
            message: message,
            actions: actions,
            cancel: cancel,
            onCancel: onCancel
        )
        showAlert(alertInfo)
    }
}

public protocol ActionSheetShowable {
    func showActionSheet(_ alertInfo: AlertInfo)
}

extension ActionSheetShowable {

    public func showActionSheet(
        _ title: String? = nil,
        _ message: String? = nil,
        _ actions: [UIAlertAction],
        _ cancel: String,
        _ onCancel: (() -> Void)? = nil) {
        let alertInfo = AlertInfo(
            title: title,
            message: message,
            actions: actions,
            cancel: cancel,
            onCancel: onCancel
        )
        showActionSheet(alertInfo)
    }
}
