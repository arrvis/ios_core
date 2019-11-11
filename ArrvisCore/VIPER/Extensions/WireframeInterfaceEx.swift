//
//  WireframeInterface.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Photos
import RxSwift

private var cameraRollHandlerKey = 0
private var disposeBagKey = 1

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
}

// MARK: - SystemScreenShowable
extension WireframeInterface {

    public func showAlert(_ alertInfo: AlertInfo) {
        navigator.navigate(screen: SystemScreens.alert, payload: alertInfo)
    }

    public func showActionSheet(_ alertInfo: AlertInfo) {
        navigator.navigate(screen: SystemScreens.actionSheet, payload: alertInfo)
    }

    public func showActivityScreen(_ activityInfo: ActivityInfo) {
        navigator.navigate(screen: SystemScreens.activity, payload: activityInfo)
    }

    private var cameraRollHandler: CameraRollEventHandler? {
        get {
            return objc_getAssociatedObject(self, &cameraRollHandlerKey) as? CameraRollEventHandler ?? nil
        }
        set {
            objc_setAssociatedObject(self, &cameraRollHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
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

    public func showMediaPickerSelectActionSheet(
        _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate & CameraRollEventHandler,
        _ handler: MediaPickerTypeSelectActionSheetInfoHandler,
        _ mediaTypes: [CFString]) {
        var actions = [
            UIAlertAction(
                title: handler.photoLibraryButtonTitle(),
                style: .default,
                handler: { [unowned self] _ in
                    self.showLibraryScreen(delegate, mediaTypes)
            })
        ]
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actions.append(UIAlertAction(
                title: handler.cameraButtonTitle(),
                style: .default,
                handler: { [unowned self] _ in
                    self.showCameraScreen(delegate, mediaTypes)
                }
            ))
        }
        showActionSheet(
            handler.sheetTitle(),
            handler.sheetMessage(),
            actions,
            handler.cancelButtonTitle()) {
                handler.onCancel()
        }
    }

    public func showLibraryScreen(
        _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate & CameraRollEventHandler,
        _ mediaTypes: [CFString]) {
        func requestAccessToPhotoLibrary() -> Observable<PHAuthorizationStatus> {
            return Observable.create({ observer in
                PHPhotoLibrary.requestAuthorization { status in
                    observer.onNext(status)
                    observer.onCompleted()
                }
                return Disposables.create()
            })
        }
        requestAccessToPhotoLibrary().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] status in
            if status == .authorized {
                let imagePickerInfo = ImagePickerInfo(
                    delegate: delegate,
                    sourceType: .photoLibrary,
                    mediaTypes: mediaTypes
                )
                self.navigator.navigate(screen: SystemScreens.imagePicker, payload: imagePickerInfo)
            } else {
                delegate.onFailAccessPhotoLibrary()
            }
        }).disposed(by: disposeBag)
    }

    /// カメラスクリーン表示
    public func showCameraScreen(
        _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate & CameraRollEventHandler,
        _ mediaTypes: [CFString]) {
        func requestAccessToTakeMovie() -> Observable<Bool> {
            return Observable.create({ observer in
                AVCaptureDevice.requestAccess(for: .video) { authorized in
                    observer.onNext(authorized)
                    observer.onCompleted()
                }
                return Disposables.create()
            })
        }
        requestAccessToTakeMovie().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] ret in
            if ret {
                let imagePickerInfo = ImagePickerInfo(delegate: delegate, sourceType: .camera, mediaTypes: mediaTypes)
                self.navigator.navigate(screen: SystemScreens.imagePicker, payload: imagePickerInfo)
            } else {
                delegate.onFailAccessCamera()
            }
        }).disposed(by: disposeBag)
    }
}
