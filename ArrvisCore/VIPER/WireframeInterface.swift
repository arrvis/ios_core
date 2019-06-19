//
//  WireframeInterface.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos

public protocol WireframeInterface: class, ErrorHandleable {

    /// Navigator
    var navigator: BaseNavigator {get}

    /// モジュール生成
    ///
    /// - Parameter payload: ペイロード
    /// - Returns: UIViewController
    static func generateModule(_ payload: Any?) -> UIViewController
}

extension WireframeInterface {

    /// アプリ設定表示
    public func showAppSettings() {
        UIApplication.shared.open(URL(string: "app-settings:root=General&path=" + Bundle.main.bundleIdentifier!)!,
                                  options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                                  completionHandler: nil)
    }

    /// dismiss Screen
    public func dismissScreen(result: Any? = nil) {
        navigator.dismissScreen(result: result)
    }

    /// pop Screen
    public func popScreen(result: Any? = nil, _ animate: Bool = true) {
        navigator.popScreen(result: result, animate: animate)
    }

    /// 画像Picker表示
    public func showImagePickerScreen(_ title: String?,
                                      _ message: String?,
                                      _ library: String,
                                      _ camera: String,
                                      _ cancel: String,
                                      _ delegate: CameraRollDelegate) {
        showImageVideoPickerScreen(title, message, library, camera, cancel, delegate, true)
    }

    /// 動画Picker表示
    public func showVideoPickerScreen(_ title: String?,
                                      _ message: String?,
                                      _ library: String,
                                      _ camera: String,
                                      _ cancel: String,
                                      _ delegate: CameraRollDelegate) {
        showImageVideoPickerScreen(title, message, library, camera, cancel, delegate, false)
    }

    private func showImageVideoPickerScreen(_ title: String?,
                                            _ message: String?,
                                            _ library: String,
                                            _ camera: String,
                                            _ cancel: String,
                                            _ delegate: CameraRollDelegate,
                                            _ isImage: Bool) {
        var actions = [
            library: (UIAlertAction.Style.default, {
                PHPhotoLibrary.requestAuthorization { status in
                    NSObject.runOnMainThread { [unowned self] in
                        if status == .authorized {
                            self.navigator.navigate(
                                screen: SystemScreens.imagePicker,
                                payload: (
                                    delegate,
                                    UIImagePickerController.SourceType.photoLibrary,
                                    isImage ? kUTTypeImage : kUTTypeMovie
                                )
                            )
                        } else {
                            delegate.onFailAccessPhotoLibrary()
                        }
                    }
                }
            })
        ]
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actions[camera] = (.default, { [unowned self] in
                if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized {
                    self.navigator.navigate(
                        screen: SystemScreens.imagePicker,
                        payload: (
                            delegate,
                            UIImagePickerController.SourceType.camera,
                            isImage ? kUTTypeImage : kUTTypeMovie
                        )
                    )
                } else {
                    delegate.onFailAccessCamera()
                }
            })
        }
        showActionSheet(title: title, message: message, actions: actions, cancel: cancel, onCancel: nil)
    }

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
    public func showOkAlert(title: String?, message: String?) {
        showOkAlert(title: title, message: message, onOk: {})
    }

    /// OKアラート表示
    public func showOkAlert(title: String?, message: String?, onOk: @escaping () -> Void) {
        showAlert(title: title, message: message, actions: [ "OK": (.default, { onOk() }) ] )
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
