//
//  WireframeInterface.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

public protocol WireframeInterface: class, ErrorHandleable, MediaPickerTypeSelectActionSheetHandler {

    /// Navigator
    var navigator: BaseNavigator {get}

    /// モジュール生成
    ///
    /// - Parameter payload: ペイロード
    /// - Returns: UIViewController
    static func generateModule(_ payload: Any?) -> UIViewController
}

/// General
extension WireframeInterface {

    /// アプリ設定表示
    public func showAppSettings() {
        UIApplication.shared.open(URL(string: "app-settings:root=General&path=" + Bundle.main.bundleIdentifier!)!,
                                  options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                                  completionHandler: nil)
    }

    /// URLを開く
    public func openURL(_ url: String) -> Bool {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            return false
        }
        UIApplication.shared.open(url)
        return true
    }
}

/// Screen
extension WireframeInterface {

    /// dismiss Screen
    public func dismissScreen(result: Any? = nil) {
        navigator.dismissScreen(result: result)
    }

    /// pop Screen
    public func popScreen(result: Any? = nil, _ animate: Bool = true) {
        navigator.popScreen(result: result, animate: animate)
    }
}

/// Activity / Alert / ActionSheet
extension WireframeInterface {

    /// Activity表示
    public func showActivityScreen(_ activityItems: [Any],
                                   _ applicationActivities: [UIActivity]? = nil,
                                   _ excludedActivityTypes: [UIActivity.ActivityType]? = nil) {
        navigator.navigate(screen: SystemScreens.activity,
                           payload: ActivityInfo(activityItems: activityItems,
                                                 applicationActivities: applicationActivities,
                                                 excludedActivityTypes: excludedActivityTypes)
        )
    }

    /// OKアラート表示
    public func showOkAlert(title: String?, message: String?, ok: String?) {
        showOkAlert(title: title, message: message, ok: ok, onOk: {})
    }

    /// OKアラート表示
    public func showOkAlert(title: String?, message: String?, ok: String?, onOk: @escaping () -> Void) {
        showAlert(title: title, message: message, actions: [ (ok ?? "OK"): (.default, { onOk() }) ] )
    }

    /// 確認アラート表示
    public func showConfirmAlert(title: String? = "",
                                 message: String?,
                                 ok: String,
                                 onOk: @escaping () -> Void,
                                 cancel: String,
                                 onCancel: (() -> Void)? = nil) {
        showAlert(
            title: title,
            message: message,
            actions: [
                ok: (.default, { onOk() })
            ],
            cancel: cancel,
            onCancel: onCancel)
    }

    /// アラート表示
    public func showAlert(title: String?,
                          message: String?,
                          actions: [String: (UIAlertAction.Style, () -> Void)],
                          cancel: String? = nil,
                          onCancel: (() -> Void)? = nil) {
        let alertInfo = AlertInfo(
            title: title,
            message: message,
            actions: actions,
            cancel: cancel,
            onCancel: onCancel
        )
        navigator.navigate(screen: SystemScreens.alert, payload: alertInfo)
    }

    /// アクションシート表示
    public func showActionSheet(title: String?,
                                message: String?,
                                actions: [String: (UIAlertAction.Style, () -> Void)],
                                cancel: String? = nil,
                                onCancel: (() -> Void)? = nil) {
        let alertInfo = AlertInfo(
            title: title,
            message: message,
            actions: actions,
            cancel: cancel,
            onCancel: nil
        )
        navigator.navigate(screen: SystemScreens.actionSheet, payload: alertInfo)
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(
    _ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues:
        input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)}
    )
}
