//
//  WireframeInterface.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

// MARK: - General
extension WireframeInterface {

    /// アプリ設定表示
    public func showAppSettings() {
        // Helper function inserted by Swift 4.2 migrator.
        func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(
            _ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
            return Dictionary(uniqueKeysWithValues:
                input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)}
            )
        }
        UIApplication.shared.open(
            URL(string: "app-settings:root=General&path=" + Bundle.main.bundleIdentifier!)!,
            options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
            completionHandler: nil
        )
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

// MARK: - Navigate
extension WireframeInterface {

    /// dismiss Screen
    public func dismissScreen(result: Any? = nil) {
        navigator.dismissScreen(result: result)
    }

    /// pop Screen
    public func popScreen(result: Any? = nil, _ animate: Bool = true) {
        navigator.popScreen(result: result, animate: animate)
    }

    /// pop to root
    public func popToRootScreen(result: Any? = nil, _ animate: Bool = true) {
        navigator.popToRootScreen(result: result, animate: animate)
    }
}

// MARK: - AlertShowable
extension WireframeInterface {

    public func showAlert(_ alertInfo: AlertInfo) {
        navigator.navigate(screen: SystemScreens.alert, payload: alertInfo)
    }
}

// MARK: - ActionSheetShowable
extension WireframeInterface {

    public func showActionSheet(_ alertInfo: AlertInfo) {
        navigator.navigate(screen: SystemScreens.actionSheet, payload: alertInfo)
    }
}

// MARK: - ActivityShowable
extension WireframeInterface {

    public func showActivityScreen(_ activityInfo: ActivityInfo) {
        navigator.navigate(screen: SystemScreens.activity, payload: activityInfo)
    }
}

// MARK: - ImagePickerShowable
extension WireframeInterface {

    public func showImagePickerScreen(_ imagePickerInfo: ImagePickerInfo) {
        navigator.navigate(screen: SystemScreens.imagePicker, payload: imagePickerInfo)
    }
}

// MARK: - DocumentBrowserShowable
extension WireframeInterface {

    public func showDocumentBrowserScreen(_ documentBrowserInfo: DocumentBrowserInfo) {
        navigator.navigate(screen: SystemScreens.documentBrowser, payload: documentBrowserInfo)
    }
}

// MARK: - DocumentPickerShowable
extension WireframeInterface {

    public func showDocumentPickerScreen(_ documentPickerInfo: DocumentPickerInfo) {
        navigator.navigate(screen: SystemScreens.documentPicker, payload: documentPickerInfo)
    }
}
