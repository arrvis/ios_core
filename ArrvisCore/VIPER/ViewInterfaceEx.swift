//
//  ViewInterfaceEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/10/21.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import MobileCoreServices
import Photos
import RxSwift

extension ViewInterface {

    /// メディア選択アクションシート表示
    public func showMediaPickerSelectActionSheet(
        _ showable: SystemScreenShowable,
        _ mediaTypes: [CFString] = [kUTTypeImage, kUTTypeMovie]) {
        var actions = [
            photoLibraryButtonTitle(): (UIAlertAction.Style.default, { [unowned self] in
                showable.showLibraryScreen(self, mediaTypes)
            })
        ]
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actions[cameraButtonTitle()] = (.default, { [unowned self] in
                showable.showCameraScreen(self, mediaTypes)
            })
        }
        showable.showActionSheet(
            sheetTitle(),
            sheetMessage(),
            actions,
            cancelButtonTitle()) { [unowned self] in
            self.onCancel()
        }
    }
}

extension ViewInterface {

    func imagePickerController(
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

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [unowned self] in
            self.onImagePickCanceled()
        }
    }
}
