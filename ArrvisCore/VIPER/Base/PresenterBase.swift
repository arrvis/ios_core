//
//  PresenterBase.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/11/12.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import Photos

/// Presenter基底クラス
open class PresenterBase: NSObject, PresenterInterface {

    // MARK: - Variables

    public var viewInterface: ViewInterface?
    public var interactorInterface: InteractorInterface!
    public var wireframeInterface: WireframeInterface!

    open func viewDidLoad() {}
    open func viewWillAppear(_ animated: Bool) {}
    open func viewDidAppear(_ animated: Bool) {}
    open func onDidFirstLayoutSubviews() {}
    open func viewWillDisappear(_ animated: Bool) {}
    open func viewDidDisappear(_ animated: Bool) {}
    open func onBackFromNext(_ result: Any?) {}

    public func onShowActivityScreenRequired(
        _ activityItems: [Any],
        _ applicationActivities: [UIActivity]?,
        _ excludedActivityTypes: [UIActivity.ActivityType]?) {
        wireframeInterface.showActivityScreen(activityItems, applicationActivities, excludedActivityTypes)
    }

    public func onShowOkAlertRequired(
        _ title: String?,
        _ message: String?,
        _ ok: String,
        _ onOk: @escaping () -> Void) {
        wireframeInterface.showOkAlert(title, message, ok, onOk)
    }

    public func onShowConfirmAlertRequired(
        _ title: String?,
        _ message: String?,
        _ ok: String,
        _ onOk: @escaping () -> Void,
        _ cancel: String,
        _ onCancel: (() -> Void)?) {
        wireframeInterface.showConfirmAlert(title, message, ok, onOk, cancel, onCancel)
    }

    public func onShowAlertRequired(
        _ title: String?,
        _ message: String?,
        _ actions: [UIAlertAction],
        _ cancel: String,
        _ onCancel: (() -> Void)?) {
        wireframeInterface.showAlert(title, message, actions, cancel, onCancel)
    }

    public func onShowActionSheetRequired(
        _ title: String?,
        _ message: String?,
        _ actions: [UIAlertAction],
        _ cancel: String,
        _ onCancel: (() -> Void)?) {
        wireframeInterface.showActionSheet(title, message, actions, cancel, onCancel)
    }

    public func onShowMediaPickerSelectActionSheetScreenRequired(
        _ handler: MediaPickerTypeSelectActionSheetInfoHandler,
        _ mediaTypes: [CFString]) {
        wireframeInterface.showMediaPickerSelectActionSheet(self, handler, mediaTypes)
    }

    public func onShowLibraryScreenRequired(_ mediaTypes: [CFString]) {
        wireframeInterface.showLibraryScreen(self, mediaTypes)
    }

    public func onShowLibraryScreenRequired(_ availableExtensions: [String]) {
        wireframeInterface.showLibraryScreen(self, availableExtensions)
    }

    public func onShowCameraScreenRequired(_ mediaTypes: [CFString]) {
        wireframeInterface.showCameraScreen(self, mediaTypes)
    }

    public func onShowCameraScreenRequired(_ availableExtensions: [String]) {
        wireframeInterface.showCameraScreen(self, availableExtensions)
    }

    public func onFailAccessCamera() {
        viewInterface?.showFailAccessCameraAlert()
    }

    public func onFailAccessPhotoLibrary() {
        viewInterface?.showFailAccessPhotoLibraryAlert()
    }

    open func onImagePickCanceled() {}

    open func onImageSelected() {}

    open func onImageAdjustCompleted(_ image: UIImage, _ info: [UIImagePickerController.InfoKey: Any]) {}

    open func onImageSelected(_ image: UIImage, _ info: [UIImagePickerController.InfoKey: Any]) {}

    open func onMediaSelected(_ url: URL, _ info: [UIImagePickerController.InfoKey: Any]) {}

    open func onUnknownItemSelected(_ info: [UIImagePickerController.InfoKey: Any]) {}

    open func handleError(_ error: Error, _ completion: (() -> Void)?) {
        viewInterface?.hideLoading()
        viewInterface?.handleError(error, completion)
    }

    open func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        onImageSelected()
        picker.dismiss(animated: true) { [unowned self] in
            if let image = info[.originalImage] as? UIImage {
                DispatchQueue.global().async { [unowned self] in
                    var imageOriginal = image
                    UIGraphicsBeginImageContextWithOptions(imageOriginal.size, false, 0.0)
                    imageOriginal.draw(in: CGRect(
                        x: 0,
                        y: 0,
                        width: imageOriginal.size.width,
                        height: imageOriginal.size.height)
                    )
                    imageOriginal = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    NSObject.runOnMainThread { [unowned self] in
                        self.onImageAdjustCompleted(imageOriginal, info)
                    }
                }
            } else if let url = info[.mediaURL] as? URL {
                self.onMediaSelected(url, info)
            } else {
                self.onUnknownItemSelected(info)
            }
        }
    }

    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [unowned self] in
            self.onImagePickCanceled()
        }
    }

    public func onShowDocumentBrowserScreenRequired(
        _ avaiableExtensions: [String]?,
        _ allowsDocumentCreation: Bool,
        _ allowsPickingMultipleItems: Bool) {
        wireframeInterface.showDocumentBrowserScreen(
            avaiableExtensions,
            allowsDocumentCreation,
            allowsPickingMultipleItems,
            self)
    }

    public func onShowDocumentPickerScreenRequired(
       _ avaiableExtensions: [String],
       _ mode: UIDocumentPickerMode,
       _ allowsMultipleSelection: Bool) {
        wireframeInterface.showDocumentPickerScreen(
            avaiableExtensions,
            mode,
            allowsMultipleSelection,
            self)
    }
}
