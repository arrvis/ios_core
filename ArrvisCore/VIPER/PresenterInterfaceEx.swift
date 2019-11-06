//
//  PresenterInterfaceEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/11/07.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import Photos

private var payloadKey = 0

extension PresenterInterface {

    /// Payload
    public var payload: Any? {
        get {
            return objc_getAssociatedObject(self, &payloadKey)
        }
        set {
            objc_setAssociatedObject(self, &payloadKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

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
