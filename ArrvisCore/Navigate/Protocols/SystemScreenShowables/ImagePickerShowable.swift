//
//  ImagePickerShowable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2020/02/07.
//  Copyright © 2020 Arrvis Co., Ltd. All rights reserved.
//

import Photos
import RxSwift

private var disposeBagKey = 0

public struct ImagePickerInfo {

    /// delegate
    public weak var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?

    /// sourceType
    public let sourceType: UIImagePickerController.SourceType

    /// mediaTypes
    public let mediaTypes: [CFString]?

    /// avaiableExtensions
    public let avaiableExtensions: [String]?

    /// UIImagePickerController生成
    public func createImagePickerController() -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.delegate = delegate
        vc.sourceType = sourceType
        if let mediaTypes = mediaTypes as [String]? {
            vc.mediaTypes = mediaTypes
        } else if let availableExtensions = avaiableExtensions {
            vc.mediaTypes = availableExtensions.compactMap { DocumentUtil.documentType(fromExt: $0) }
        }
        return vc
    }
}

public protocol ImagePickerShowable: ActionSheetShowable, NSObject {
    func showImagePickerScreen(_ imagePickerInfo: ImagePickerInfo)
}

extension ImagePickerShowable {

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
        _ mediaTypes: [CFString]
    ) {
        showMediaPickerSelectActionSheet(delegate, handler, { [unowned self] in
            self.showLibraryScreen(delegate, mediaTypes)
        }, { [unowned self] in
            self.showCameraScreen(delegate, mediaTypes)
        })
    }

    public func showMediaPickerSelectActionSheet(
        _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate & CameraRollEventHandler,
        _ handler: MediaPickerTypeSelectActionSheetInfoHandler,
        _ availableExtensions: [String]
    ) {
        showMediaPickerSelectActionSheet(delegate, handler, { [unowned self] in
            self.showLibraryScreen(delegate, availableExtensions)
        }, { [unowned self] in
            self.showCameraScreen(delegate, availableExtensions)
        })
    }

    private func showMediaPickerSelectActionSheet(
        _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate & CameraRollEventHandler,
        _ handler: MediaPickerTypeSelectActionSheetInfoHandler,
        _ onLibrarySelected:@escaping () -> Void,
        _ onCameraSelected:@escaping () -> Void) {
        var actions = [
            UIAlertAction(
                title: handler.photoLibraryButtonTitle(),
                style: .default,
                handler: { _ in
                    onLibrarySelected()
            })
        ]
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actions.append(UIAlertAction(
                title: handler.cameraButtonTitle(),
                style: .default,
                handler: { _ in
                    onCameraSelected()
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
        showLibraryScreen({ [unowned self] in
            let imagePickerInfo = ImagePickerInfo(
                delegate: delegate,
                sourceType: .photoLibrary,
                mediaTypes: mediaTypes,
                avaiableExtensions: nil
            )
            self.showImagePickerScreen(imagePickerInfo)
        }, {
            delegate.onFailAccessPhotoLibrary()
        })
    }

    public func showLibraryScreen(
        _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate & CameraRollEventHandler,
        _ availableExtensions: [String]
    ) {
        showLibraryScreen({ [unowned self] in
            let imagePickerInfo = ImagePickerInfo(
                delegate: delegate,
                sourceType: .photoLibrary,
                mediaTypes: nil,
                avaiableExtensions: availableExtensions
            )
            self.showImagePickerScreen(imagePickerInfo)
        }, {
            delegate.onFailAccessPhotoLibrary()
        })
    }

    private func showLibraryScreen(_ onAuthorized:@escaping () -> Void, _ onFail:@escaping () -> Void) {
        func requestAccessToPhotoLibrary() -> Observable<PHAuthorizationStatus> {
            return Observable.create({ observer in
                PHPhotoLibrary.requestAuthorization { status in
                    observer.onNext(status)
                    observer.onCompleted()
                }
                return Disposables.create()
            })
        }
        requestAccessToPhotoLibrary().observeOn(MainScheduler.instance).subscribe(onNext: { status in
            if status == .authorized {
                onAuthorized()
            } else {
                onFail()
            }
        }).disposed(by: disposeBag)
    }

    public func showCameraScreen(
        _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate & CameraRollEventHandler,
        _ mediaTypes: [CFString]
    ) {
        showCameraScreen({ [unowned self] in
            let imagePickerInfo = ImagePickerInfo(
                delegate: delegate,
                sourceType: .camera,
                mediaTypes: mediaTypes,
                avaiableExtensions: nil)
            self.showImagePickerScreen(imagePickerInfo)
        }, {
            delegate.onFailAccessCamera()
        })
    }

    public func showCameraScreen(
        _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate & CameraRollEventHandler,
        _ availableExtensions: [String]
    ) {
        showCameraScreen({ [unowned self] in
            let imagePickerInfo = ImagePickerInfo(
                delegate: delegate,
                sourceType: .camera,
                mediaTypes: nil,
                avaiableExtensions: availableExtensions)
            self.showImagePickerScreen(imagePickerInfo)
        }, {
            delegate.onFailAccessCamera()
        })
    }

    private func showCameraScreen(_ onAuthorized:@escaping () -> Void, _ onFail:@escaping () -> Void) {
        func requestAccessToTakeMovie() -> Observable<Bool> {
            return Observable.create({ observer in
                AVCaptureDevice.requestAccess(for: .video) { authorized in
                    observer.onNext(authorized)
                    observer.onCompleted()
                }
                return Disposables.create()
            })
        }
        requestAccessToTakeMovie().observeOn(MainScheduler.instance).subscribe(onNext: { ret in
            if ret {
                onAuthorized()
            } else {
                onFail()
            }
        }).disposed(by: disposeBag)
    }
}
