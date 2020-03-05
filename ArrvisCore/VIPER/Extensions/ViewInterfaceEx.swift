//
//  ViewInterfaceEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2020/02/10.
//  Copyright © 2020 Arrvis Co., Ltd. All rights reserved.
//

import MobileCoreServices

private var presenterInterfaceKey = 0

extension ViewInterface {

    public var presenterInterface: PresenterInterface! {
        get {
            return objc_getAssociatedObject(self, &presenterInterfaceKey) as? PresenterInterface
        }
        set {
            objc_setAssociatedObject(self, &presenterInterfaceKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    public func showActivity(
        _ activityItems: [Any],
        _ applicationActivities: [UIActivity]?,
        _ excludedActivityTypes: [UIActivity.ActivityType]?) {
        presenterInterface.onShowActivityScreenRequired(
            activityItems,
            applicationActivities,
            excludedActivityTypes
        )
    }

    public func showOkAlert(
        _ title: String? = nil,
        _ message: String? = nil,
        _ ok: String? = nil,
        _ onOk: @escaping () -> Void) {
        presenterInterface.onShowOkAlertRequired(
            title,
            message,
            ok == nil ? "OK" : ok!,
            onOk
        )
    }

    public func showConfirmAlert(
        _ title: String? = nil,
        _ message: String? = nil,
        _ ok: String? = nil,
        _ onOk: @escaping () -> Void,
        _ cancel: String? = nil,
        _ onCancel: (() -> Void)? = nil) {
        presenterInterface.onShowConfirmAlertRequired(
            title,
            message,
            ok == nil ? "OK" : ok!,
            onOk,
            cancel == nil ? "Cancel" : cancel!
        ) {
            onCancel?()
        }
    }

    public func showAlert(
        _ title: String? = nil,
        _ message: String? = nil,
        _ actions: [UIAlertAction],
        _ cancel: String? = nil,
        _ onCancel: (() -> Void)? = nil) {
        presenterInterface.onShowAlertRequired(
            title,
            message,
            actions,
            cancel == nil ? "Cancel" : cancel!,
            onCancel
        )
    }

    public func showActionSheet(
        _ title: String? = nil,
        _ message: String? = nil,
        _ actions: [UIAlertAction],
        _ cancel: String? = nil,
        _ onCancel: (() -> Void)? = nil) {
        presenterInterface.onShowActionSheetRequired(
            title,
            message,
            actions,
            cancel == nil ? "Cancel" : cancel!,
            onCancel
        )
    }

    public func showMediaPickerSelectActionSheet(_ mediaTypes: [CFString] = [kUTTypeImage, kUTTypeMovie]) {
        presenterInterface.onShowMediaPickerSelectActionSheetScreenRequired(self, mediaTypes)
    }

    public func showLibrary(_ mediaTypes: [CFString] = [kUTTypeImage, kUTTypeMovie]) {
        presenterInterface.onShowLibraryScreenRequired(mediaTypes)
    }

    public func showCamera(_ mediaTypes: [CFString] = [kUTTypeImage, kUTTypeMovie]) {
        presenterInterface.onShowCameraScreenRequired(mediaTypes)
    }

    public func showDocumentBrowser(
        _ avaiableExtensions: [String]?,
        _ allowsDocumentCreation: Bool,
        _ allowsPickingMultipleItems: Bool) {
        presenterInterface.onShowDocumentBrowserScreenRequired(
            avaiableExtensions,
            allowsDocumentCreation,
            allowsPickingMultipleItems)
    }

    public func showDocumentPicker(
       _ avaiableExtensions: [String],
       _ mode: UIDocumentPickerMode,
       _ allowsMultipleSelection: Bool) {
        presenterInterface.onShowDocumentPickerScreenRequired(
            avaiableExtensions,
            mode,
            allowsMultipleSelection)
    }
}
