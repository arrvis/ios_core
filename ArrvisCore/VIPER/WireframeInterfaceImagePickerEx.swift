//
//  WireframeInterfaceImagePickerEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/08/02.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import MobileCoreServices
import Photos
import RxSwift

private var imagePickerDelegateKey = 0
private var disposeBagKey = 1

/// ImagePicker
extension WireframeInterface {

    private var imagePickerDelegate: ImagePickerDelegate? {
        get {
            return objc_getAssociatedObject(self, &imagePickerDelegateKey) as? ImagePickerDelegate ?? nil
        }
        set {
            objc_setAssociatedObject(self, &imagePickerDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    fileprivate var disposeBag: DisposeBag {
        get {
            guard let object = objc_getAssociatedObject(self, &disposeBagKey) as? DisposeBag else {
                self.disposeBag = DisposeBag()
                return self.disposeBag
            }
            return object
        }
        set {
            objc_setAssociatedObject(self, &disposeBagKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    /// メディア選択アクションシート表示
    public func showMediaPickerSelectActionSheetScreen(
        _ cameraRollEventHandler: CameraRollEventHandler,
        _ mediaTypes: [CFString] = [kUTTypeImage, kUTTypeMovie]) {
        var actions = [
            photoLibraryButtonTitle(): (UIAlertAction.Style.default, { [unowned self] in
                self.showLibraryScreen(cameraRollEventHandler, mediaTypes)
            })
        ]
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actions[cameraButtonTitle()] = (.default, { [unowned self] in
                self.showCameraScreen(cameraRollEventHandler, mediaTypes)
            })
        }
        showActionSheet(title: sheetTitle(),
                        message: sheetMessage(),
                        actions: actions,
                        cancel: cancelButtonTitle()) { [unowned self] in
                            self.onCancel()
        }
    }

    /// ライブラリスクリーン表示
    public func showLibraryScreen(_ handler: CameraRollEventHandler,
                                  _ mediaTypes: [CFString] = [kUTTypeImage, kUTTypeMovie]) {
        requestAccessToPhotoLibrary().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] status in
            if status == .authorized {
                self.imagePickerDelegate = ImagePickerDelegate(handler)
                self.navigator.navigate(
                    screen: SystemScreens.imagePicker,
                    payload: (
                        self.imagePickerDelegate,
                        UIImagePickerController.SourceType.photoLibrary,
                        mediaTypes
                    )
                )
            } else {
                handler.onFailAccessPhotoLibrary()
            }
        }).disposed(by: disposeBag)
    }

    /// カメラスクリーン表示
    public func showCameraScreen(_ handler: CameraRollEventHandler,
                                 _ mediaTypes: [CFString] = [kUTTypeImage, kUTTypeMovie]) {
        requestAccessToTakeMovie().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] ret in
            if ret {
                self.imagePickerDelegate = ImagePickerDelegate(handler)
                self.navigator.navigate(
                    screen: SystemScreens.imagePicker,
                    payload: (
                        self.imagePickerDelegate,
                        UIImagePickerController.SourceType.camera,
                        mediaTypes
                    )
                )
            } else {
                handler.onFailAccessCamera()
            }
        }).disposed(by: disposeBag)
    }

    /// フォトライブラリへのアクセスリクエスト
    public func requestAccessToPhotoLibrary() -> Observable<PHAuthorizationStatus> {
        return Observable.create({ observer in
            PHPhotoLibrary.requestAuthorization { status in
                observer.onNext(status)
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }

    /// 動画撮影アクセスリクエスト
    public func requestAccessToTakeMovie() -> Observable<Bool> {
        return Observable.create({ observer in
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                observer.onNext(authorized)
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }
}

private class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var cameraRollEventHandler: CameraRollEventHandler

    init(_ cameraRollEventHandler: CameraRollEventHandler) {
        self.cameraRollEventHandler = cameraRollEventHandler
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) { [unowned self] in
            let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
            if let image = info[convertFromUIImagePickerControllerInfoKey(.originalImage)] as? UIImage {
                self.cameraRollEventHandler.onImageSelected(image)
            } else if let url = info[convertFromUIImagePickerControllerInfoKey(.mediaURL)] as? URL {
                self.cameraRollEventHandler.onMediaSelected(url)
            } else if let asset = self.assetFromInfoKey(info) {
                asset.getURL(completionHandler: { [unowned self] responseUrl in
                    if let url = responseUrl {
                        self.cameraRollEventHandler.onMediaSelected(url)
                    }
                })

            }
        }
    }

    private func assetFromInfoKey(_ info: [String: Any]) -> PHAsset? {
        if #available(iOS 11.0, *) {
            return info[UIImagePickerController.InfoKey.phAsset.rawValue] as? PHAsset
        } else {
            guard let url = info[UIImagePickerController.InfoKey.referenceURL.rawValue] as? URL else { return nil }
            return PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [unowned self] in
            self.cameraRollEventHandler.onCanceled()
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(
    _ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
