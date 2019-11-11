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

    var viewInterface: ViewInterface?
    var interactorInterface: InteractorInterface!
    var wireframeInterface: WireframeInterface!

    public func viewDidLoad() {}
    public func viewWillAppear(_ animated: Bool) {}
    public func viewDidAppear(_ animated: Bool) {}
    public func onDidFirstLayoutSubviews() {}
    public func viewWillDisappear(_ animated: Bool) {}
    public func viewDidDisappear(_ animated: Bool) {}
    public func onBackFromNext(_ result: Any?) {}

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

    public func onImagePickCanceled() {}

    public func onImageSelected(_ image: UIImage) {}

    public func onMediaSelected(_ url: URL) {}

    public func handleError(_ error: Error, _ completion: (() -> Void)?) {
        viewInterface?.hideLoading()
        viewInterface?.handleError(error, completion)
    }

    public func imagePickerController(
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

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [unowned self] in
            self.onImagePickCanceled()
        }
    }
}
