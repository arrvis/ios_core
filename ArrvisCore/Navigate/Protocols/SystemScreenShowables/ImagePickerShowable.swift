//
//  ImagePickerShowable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2020/02/07.
//  Copyright © 2020 Arrvis Co., Ltd. All rights reserved.
//

public struct ImagePickerInfo {

    /// delegate
    public weak var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?

    /// sourceType
    public let sourceType: UIImagePickerController.SourceType

    /// mediaTypes
    public let mediaTypes: [CFString]

    /// UIImagePickerController生成
    public func createImagePickerController() -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.delegate = delegate
        vc.sourceType = sourceType
        vc.mediaTypes = mediaTypes as [String]
        return vc
    }
}

public protocol ImagePickerShowable {
    func showMediaPickerSelectActionSheet(
        _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate & CameraRollEventHandler,
        _ handler: MediaPickerTypeSelectActionSheetInfoHandler,
        _ mediaTypes: [CFString]
    )
    func showLibraryScreen(
        _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate & CameraRollEventHandler,
        _ mediaTypes: [CFString]
    )
    func showCameraScreen(
        _ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate & CameraRollEventHandler,
        _ mediaTypes: [CFString]
    )
}
