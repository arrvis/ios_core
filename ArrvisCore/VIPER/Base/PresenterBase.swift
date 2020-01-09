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

    public func onShowCameraScreenRequired(_ mediaTypes: [CFString]) {
        wireframeInterface.showCameraScreen(self, mediaTypes)
    }

    public func onFailAccessCamera() {
        viewInterface?.showFailAccessCameraAlert()
    }

    public func onFailAccessPhotoLibrary() {
        viewInterface?.showFaukAccessPhotoLibraryAlert()
    }

    open func onImagePickCanceled() {}

    open func onImageSelected(_ image: UIImage) {}

    open func onMediaSelected(_ url: URL) {}

    open func handleError(_ error: Error, _ completion: (() -> Void)?) {
        viewInterface?.hideLoading()
        viewInterface?.handleError(error, completion)
    }

    open func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Helper function inserted by Swift 4.2 migrator.
        func convertFromUIImagePickerControllerInfoKeyDictionary(
            _ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
            return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
        }
        func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
            return input.rawValue
        }
        func assetFromInfoKey(_ info: [String: Any]) -> PHAsset? {
            if #available(iOS 11.0, *) {
                return info[UIImagePickerController.InfoKey.phAsset.rawValue] as? PHAsset
            } else {
                guard let url = info[UIImagePickerController.InfoKey.referenceURL.rawValue] as? URL else { return nil }
                return PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject
            }
        }

        picker.dismiss(animated: true) { [unowned self] in
            let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
            if let image = info[convertFromUIImagePickerControllerInfoKey(.originalImage)] as? UIImage {
                self.onImageSelected(image)
            } else if let url = info[convertFromUIImagePickerControllerInfoKey(.mediaURL)] as? URL {
                self.onMediaSelected(url)
            } else if let asset = assetFromInfoKey(info) {
                asset.getURL(completionHandler: { [unowned self] responseUrl in
                    if let url = responseUrl {
                        self.onMediaSelected(url)
                    }
                })
            }
        }
    }

    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [unowned self] in
            self.onImagePickCanceled()
        }
    }
}
